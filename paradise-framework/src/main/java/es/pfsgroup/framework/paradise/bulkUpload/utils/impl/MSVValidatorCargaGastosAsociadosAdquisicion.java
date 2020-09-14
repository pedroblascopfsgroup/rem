package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.termino.model.ValoresCamposTermino;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelRepoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationFactory;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationRunner;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVValidationResult;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVMultiColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.dto.ResultadoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;

@Component
public class MSVValidatorCargaGastosAsociadosAdquisicion extends MSVExcelValidatorAbstract {

	private final String CHECK_NUM_ACTIVO_NO_EXISTE = "msg.error.masivo.gastos.asociados.adquisicion.activo.no.valido";
	private final String CHECK_NUM_ACTIVO_FUERA_PERIMETRO_HAYA = "msg.error.masivo.gastos.asociados.adquisicion.activo.fuera.phaya";
	private final String CHECK_NUM_ACTIVO_FUERA_PERIMETRO_ADMISION = "msg.error.masivo.gastos.asociados.adquisicion.activo.fuera.padmision";
	private final String CHECK_TIPO_GASTO_INCORRECTO = "msg.error.masivo.gastos.asociados.adquisicion.gasto.no.valido";
	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int NUM_COLS = 5;

	private final int COL_NUM_ACTIVO = 0;
	private final int COL_TIPO_GASTO = 1;
	private final int COL_F_SOLICITUD = 2;
	private final int COL_F_PAGO = 3;
	private final int COL_OBSERVACIONES = 4;
	
	
	

	@Resource
	private MessageService messageServices;

	@Autowired
	private MSVExcelParser excelParser;

	@Autowired
	private MSVBusinessValidationRunner validationRunner;

	@Autowired
	private ParticularValidatorApi particularValidator;

	@Autowired
	private MSVProcesoApi msvProcesoApi;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private MSVBusinessValidationFactory validationFactory;

	private Integer numFilasHoja;

	protected final Log logger = LogFactory.getLog(getClass());

	Map<String, List<Integer>> mapaErrores;

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();

		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVValidatorCargaGastosAsociadosAdquisicion::validarContenidoFichero -> idTipoOperacion no puede ser null");
		}

		List<String> lista = recuperarFormato(idTipoOperacion);
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(idTipoOperacion));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(idTipoOperacion));
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(idTipoOperacion));
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(idTipoOperacion);

		// Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		// Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		if (!dtoValidacionContenido.getFicheroTieneErrores() && !validarFichero(exc)) {
			dtoValidacionContenido.setFicheroTieneErrores(true);
			dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
		}
		exc.cerrar();
		return dtoValidacionContenido;
	}

	private boolean validarFichero(MSVHojaExcel exc) {
		boolean esCorrecto = true;
		mapaErrores = new HashMap<String, List<Integer>>();
		ArrayList<ArrayList<Integer>> listasError = new ArrayList<ArrayList<Integer>>();
		ArrayList<Integer> errList = null;
		ArrayList <Integer>listaErroresActivo = new ArrayList<Integer>();
		String[] listaValidos = { "1", "0" };
		String celda;
		boolean validacionActicoFueraPA = true;
		boolean validacionActivoFueraPH = true;
		boolean validacionActivo = true;

		for (int columna = 0; columna < NUM_COLS; columna++) {
			listasError.add(columna, new ArrayList<Integer>());
		}

		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
				

				for (int columna = 0; columna < NUM_COLS; columna++) {
					errList = listasError.get(columna);
					celda = exc.dameCelda(fila, columna);
					boolean valorOK = true;
											
					switch (columna) {
					
					case COL_NUM_ACTIVO:
						
						valorOK = celda!=null && particularValidator.existeActivo(celda);
						break;

					case COL_TIPO_GASTO:
						valorOK = celda!=null && particularValidator.existeTipoDeGastoAsociadoCMGA(celda);
						break;

					case COL_F_SOLICITUD:
					case COL_F_PAGO:
					case COL_OBSERVACIONES:
					}

					if (!valorOK) {
						errList.add(fila);
						esCorrecto = false;
					}

				}

			} catch (ParseException e) {
				errList.add(fila);
				logger.error(e.getMessage());
			} catch (Exception e) {
				errList.add(0);
				logger.error(e.getMessage());
			}
		}
		
		if (!esCorrecto) {
		
			mapaErrores.put(messageServices.getMessage(CHECK_NUM_ACTIVO_NO_EXISTE), listasError.get(COL_NUM_ACTIVO));
			mapaErrores.put(messageServices.getMessage(CHECK_NUM_ACTIVO_FUERA_PERIMETRO_HAYA),activoDentroPerimetroHaya(exc));	
			mapaErrores.put(messageServices.getMessage(CHECK_NUM_ACTIVO_FUERA_PERIMETRO_ADMISION),activoDentroPerimetroAdmision(exc));				
			mapaErrores.put(messageServices.getMessage(CHECK_TIPO_GASTO_INCORRECTO), listasError.get(COL_TIPO_GASTO));
			
		
			
		
		}
		return esCorrecto;
	}

	@Override
	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda,
			MSVBusinessValidators contentValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);

		if ((contentValidators != null) && (contentValidators.getValidatorForColumn(nombreColumna.trim()) != null)) {
			MSVColumnValidator v = contentValidators.getValidatorForColumn(nombreColumna.trim());
			MSVValidationResult result = validationRunner.runValidation(v, contenidoCelda);
			resultado.setValido(result.isValid());
			resultado.setErroresFila(result.getErrorMessage());
		}
		return resultado;
	}

	@Override
	protected ResultadoValidacion validaContenidoFila(Map<String, String> mapaDatos, List<String> listaCabeceras,
			MSVBusinessCompositeValidators compositeValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);

		if (compositeValidators != null) {
			List<MSVMultiColumnValidator> listaValidadores = compositeValidators.getValidatorForColumns(listaCabeceras);
			if (listaValidadores != null) {
				MSVValidationResult result = validationRunner.runCompositeValidation(listaValidadores, mapaDatos);
				resultado.setValido(result.isValid());
				resultado.setErroresFila(result.getErrorMessage());
			}
		}
		return resultado;
	}

	private List<Integer> activoDentroPerimetroHaya(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.esActivoIncluidoPerimetro(exc.dameCelda(i, COL_NUM_ACTIVO))) {
					listaFilas.add(i);
				}
					
			}
		} catch (Exception e) {
			if (i != 0) {
				listaFilas.add(i);
			}
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activoDentroPerimetroAdmision(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.esActivoIncluidoPerimetroAdmision(exc.dameCelda(i, COL_NUM_ACTIVO))) {
					listaFilas.add(i);
				}
					
			}
		} catch (Exception e) {
			if (i != 0) {
				listaFilas.add(i);
			}
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}

}
