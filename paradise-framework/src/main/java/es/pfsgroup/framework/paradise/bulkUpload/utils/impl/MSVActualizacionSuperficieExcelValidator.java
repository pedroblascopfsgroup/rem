package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
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
public class MSVActualizacionSuperficieExcelValidator extends MSVExcelValidatorAbstract {
	
	private static final String ACTIVO_NO_EXISTE = "msg.error.masivo.listado.validator.activos.deben.existir";
	private static final String ACTIVO_CARTERA_ERR = "msg.error.masivo.err.cartera.activo";
	private static final String ERR_SUPERFICIE_CONSTRUIDA = "msg.error.masivo.superficies.err.superficie.construida";
	private static final String ERR_SUPERFICIE_UTIL = "msg.error.masivo.superficies.err.superficie.util";
	private static final String ERR_REPERCUSION_EECC = "msg.error.masivo.superficies.err.repercusion.eecc";
	private static final String ERR_PARCELA = "msg.error.masivo.superficies.err.parcela";	
	private static final String ACTIVO_UA = "activo.aviso.unidad.alquilable";
	
	private	static final int FILA_CABECERA = 0;
	private	static final int DATOS_PRIMERA_FILA = 1;
		
	private	static final int COL_NUM_ID_ACTIVO_HAYA = 0;
	private	static final int COL_NUM_SUP_CONSTRUIDA = 1;
	private	static final int COL_NUM_SUP_UTIL = 2;
	private	static final int COL_NUM_REPERCUSION_EECC = 3;
	private	static final int COL_NUM_PARCELA = 4;		
	


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
	
	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		
		List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion()));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), isActiveNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_CARTERA_ERR), isActivoNotBankiaLiberbank(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_UA), esUnidadAlquilable(exc));
			mapaErrores.put(messageServices.getMessage(ERR_SUPERFICIE_CONSTRUIDA), isColumnNANSuperficieIncorrectoByRows(exc, COL_NUM_SUP_CONSTRUIDA));
			mapaErrores.put(messageServices.getMessage(ERR_SUPERFICIE_UTIL), isColumnNANSuperficieIncorrectoByRows(exc, COL_NUM_SUP_UTIL));
			mapaErrores.put(messageServices.getMessage(ERR_REPERCUSION_EECC), isColumnNANSuperficieIncorrectoByRows(exc, COL_NUM_REPERCUSION_EECC));
			mapaErrores.put(messageServices.getMessage(ERR_PARCELA), isColumnNANSuperficieIncorrectoByRows(exc, COL_NUM_REPERCUSION_EECC));
						
			for (Entry<String, List<Integer>> registros : mapaErrores.entrySet()) {
				if(!registros.getValue().isEmpty()) {
					dtoValidacionContenido.setFicheroTieneErrores(true);
					dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
				}
			}
		}
		
		exc.cerrar();
		
		return dtoValidacionContenido;
	}

	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda, MSVBusinessValidators contentValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);
		
		if ((contentValidators != null) && (contentValidators.getValidatorForColumn(nombreColumna.trim()) != null)){
			MSVColumnValidator v = contentValidators.getValidatorForColumn(nombreColumna.trim());
			MSVValidationResult result = validationRunner.runValidation(v,contenidoCelda);
			resultado.setValido(result.isValid());
			resultado.setErroresFila(result.getErrorMessage());
		}
		return resultado;
	}

	/**
	 * Realiza validaciones multivalor con diferentes valores de la fila
	 * @param mapaDatos
	 * @param compositeValidators
	 * @return
	 */
	protected ResultadoValidacion validaContenidoFila(
			Map<String, String> mapaDatos,
			List<String> listaCabeceras,
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
	
	/**
	 * Comprueba si el activo existe o esta borrado
	 * @param exc
	 * @return listado fillas erroneas
	 */
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.existeActivo(exc.dameCelda(i, COL_NUM_ID_ACTIVO_HAYA)))
					listaFilas.add(i);
			} catch (ParseException e) {
				listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		}
		return listaFilas;
	}

	/**
	 * Comprueba que el activo existe
	 * @param exc
	 * @return listado fillas erroneas
	 */
	private List<Integer> isActivoNotBankiaLiberbank(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.isActivoNotBankiaLiberbank(exc.dameCelda(i, COL_NUM_ID_ACTIVO_HAYA)))
					listaFilas.add(i);
			} catch (ParseException e) {
				listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		}
		return listaFilas;
	}
	
	/**
	 * Comprueba si el Activo pertenece a una Unidad Alquilable
	 * @param exc
	 * @return listado filas erroneas
	 */
	private List<Integer> esUnidadAlquilable(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if (particularValidator.esUnidadAlquilable(exc.dameCelda(i, COL_NUM_ID_ACTIVO_HAYA)))
					listaFilas.add(i);
			} catch (ParseException e) {
				listaFilas.add(i);
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e);				
			}
		}
		return listaFilas;
	}
	
	private List<Integer> isColumnNANSuperficieIncorrectoByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double superficie = null;

		for (int i = DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String value = exc.dameCelda(i, columnNumber);
				if (!Checks.esNulo(value) && !esArroba(value)) {
					if (value.contains(",")) {
						value = value.replace(",", ".");
					}
					superficie = !Checks.esNulo(value) ? Double.parseDouble(value) : null;

					// Si el superficie no es un número válido.
					if (!Checks.esNulo(superficie) && superficie.isNaN()) {
						listaFilas.add(i);
					}
				}
			} catch (NumberFormatException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
		
	 
	
	private boolean esArroba(String cadena) {
		return cadena.trim().equals("@");
	}
}

