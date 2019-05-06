package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
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
public class MSVValidatorCargaMasivaReclamacion extends MSVExcelValidatorAbstract {
	
	private static final String ACTIVO_NO_EXISTE = "msg.error.masivo.reclamacion.activo.noExiste";
	private static final String ACTIVO_SIN_COMUNICACION_ACTIVA = "msg.error.masivo.reclamacion.activo.sin.comunicacion.viva";
	private static final String ACTIVO_SIN_COMUNICACION_EN_ESTADO_COMUNICADO = "msg.error.masivo.reclamacion.activo.sin.comunicacion.comunicada";
	private static final String ACTIVO_SIN_COMUNICACION_ACTIVA_RECLAMADA = "msg.error.masivo.reclamacion.reclamada";
	
	private static final int POSICION_COLUMNA_NUMERO_ACTIVO = 0;
	
	protected final Log logger = LogFactory.getLog(getClass());

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

	@Resource
    MessageService messageServices;
	
	@Autowired
	private ExcelRepoApi excelRepoApi;
	
	private Integer numFilasHoja;

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
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
			
			// Validaciones individuales activo por activo:
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), activesNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_SIN_COMUNICACION_ACTIVA), validarActivoComunicacionViva(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_SIN_COMUNICACION_EN_ESTADO_COMUNICADO), esActivoConComunicacionComunicada(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_SIN_COMUNICACION_ACTIVA_RECLAMADA), esActivoConComunicacionReclamada(exc));
			// Validar NIF
			// Activo sin comunicación viva

			if (!mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_SIN_COMUNICACION_ACTIVA)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_SIN_COMUNICACION_EN_ESTADO_COMUNICADO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVO_SIN_COMUNICACION_ACTIVA_RECLAMADA)).isEmpty()
					) {
				dtoValidacionContenido.setFicheroTieneErrores(true);
				exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
				String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
				FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
				dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
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
	
	private File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = excelRepoApi.dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	// Validaciones para activos de la lista excel	
		private List<Integer> activesNotExistsRows(MSVHojaExcel exc) {
			List<Integer> listaFilas = new ArrayList<Integer>();

			int i = 0;
			try{
				for(i=1; i<this.numFilasHoja;i++){
					if(!particularValidator.existeActivo(exc.dameCelda(i, POSICION_COLUMNA_NUMERO_ACTIVO))) {
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
		
		private List<Integer> validarActivoComunicacionViva(MSVHojaExcel exc) {
			List<Integer> listaFilas = new ArrayList<Integer>();

			int i = 0;
			try{
				for(i=1; i<this.numFilasHoja;i++){
					if(!particularValidator.esActivoConComunicacionViva(Long.valueOf(exc.dameCelda(i, POSICION_COLUMNA_NUMERO_ACTIVO)))) {
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
		
		private List<Integer> esActivoConComunicacionComunicada(MSVHojaExcel exc) {
			List<Integer> listaFilas = new ArrayList<Integer>();

			int i = 0;
			try{
				for(i=1; i<this.numFilasHoja;i++){
					if(!particularValidator.esActivoConComunicacionComunicada(Long.valueOf(exc.dameCelda(i, POSICION_COLUMNA_NUMERO_ACTIVO)))) {
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
		
		private List<Integer> esActivoConComunicacionReclamada(MSVHojaExcel exc) {
			List<Integer> listaFilas = new ArrayList<Integer>();

			int i = 0;
			try{
				for(i=1; i<this.numFilasHoja;i++){
					if(!particularValidator.esActivoConComunicacionReclamada(Long.valueOf(exc.dameCelda(i, POSICION_COLUMNA_NUMERO_ACTIVO)))) {
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
