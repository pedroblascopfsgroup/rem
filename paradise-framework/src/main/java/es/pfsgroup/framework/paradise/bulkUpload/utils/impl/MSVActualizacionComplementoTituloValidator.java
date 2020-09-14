package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
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
public class MSVActualizacionComplementoTituloValidator extends MSVExcelValidatorAbstract{
	
	private final String CHECK_ACTIVO_ID = "msg.error.activo.id";
	private final String TIPO_TITULO_NO_VALIDO = "msg.error.masivo.complemento.titulo.tipo.no.valido";
	private final String FECHA_RECEPCION_MAYOR = "msg.error.masivo.complemento.titulo.fecha.recepcion.menor";
	private final String FECHA_INSCRIPCION_MAYOR = "msg.error.masivo.complemento.titulo.fecha.inscripcion.mayor.igual";
		
	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int NUM_COLS = 7;	
	private final int COL_ID_ACTIVO = 0;
	private final int COL_TIPO_TITULO = 1;
	private final int COL_FECHA_SOLICITUD = 2;
	private final int COL_FECHA_TITULO = 3;
	private final int COL_FECHA_RECEPCION = 4;
	private final int COL_FECHA_INSCRIPCION = 5;
	private final int COL_OBSERVACIONES = 6;
	
	
	private Integer numFilasHoja;	
	private Map<String, List<Integer>> mapaErrores;	
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private MSVExcelParser excelParser;

	@Autowired
	private MSVBusinessValidationFactory validationFactory;

	@Autowired
	private MSVBusinessValidationRunner validationRunner;

	@Autowired
	private ParticularValidatorApi particularValidator;

	@Autowired
	private MSVProcesoApi msvProcesoApi;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Resource
	MessageService messageServices;

	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();

		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVActualizacionComplementoTituloValidator::validarContenidoFichero -> idTipoOperacion no puede ser null");
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
		String celda;
		
		for (int columna = 0; columna < NUM_COLS; columna++) {
			listasError.add(columna, new ArrayList<Integer>());
		}

		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
				String celdaFechaTitulo = null;

				
				for (int columna = 0; columna < NUM_COLS; columna++) {
					errList = listasError.get(columna);
					celdaFechaTitulo = exc.dameCelda(fila, COL_FECHA_TITULO);
					celda = exc.dameCelda(fila, columna);
					boolean valorOK = true;

					switch (columna) {
						case COL_ID_ACTIVO:
							valorOK = celda != null && particularValidator.existeActivo(celda) &&
							particularValidator.esActivoIncluidoPerimetro(celda) && particularValidator.esActivoIncluidoPerimetroAdmision(celda);
							break;
	
						case COL_TIPO_TITULO:
							valorOK = celda != null && particularValidator.comprobarCodigoTipoTitulo(celda);
							break;	
	
						case COL_FECHA_INSCRIPCION:
						case COL_FECHA_RECEPCION:
							valorOK = comprobarFechas(celdaFechaTitulo, celda);
							break;
						case COL_OBSERVACIONES:
						case COL_FECHA_SOLICITUD:
						case COL_FECHA_TITULO:
							valorOK = true;
							break;					
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
			mapaErrores.put(messageServices.getMessage(CHECK_ACTIVO_ID), listasError.get(COL_ID_ACTIVO));			
			mapaErrores.put(messageServices.getMessage(TIPO_TITULO_NO_VALIDO), listasError.get(COL_TIPO_TITULO));			
			mapaErrores.put(messageServices.getMessage(FECHA_RECEPCION_MAYOR), listasError.get(COL_FECHA_RECEPCION));		
			mapaErrores.put(messageServices.getMessage(FECHA_INSCRIPCION_MAYOR), listasError.get(COL_FECHA_INSCRIPCION));
		}
		
		return esCorrecto;
	}
	
	private boolean comprobarFechas(String fechaMenor, String fechaMayor ) {
		
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yy");
		if(fechaMayor.isEmpty() || fechaMenor.isEmpty())
			return true;
		try {
			Date fechaMenorF = df.parse(fechaMenor);
			Date fechaMayorF = df.parse(fechaMayor);
			
			if(fechaMenorF.before(fechaMayorF) || fechaMayor.equals(fechaMenor)) {
				return true;
			} else {
				return false;
			}
			
		} catch (ParseException e) {
			e.printStackTrace();
			return false;
		}

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


}
