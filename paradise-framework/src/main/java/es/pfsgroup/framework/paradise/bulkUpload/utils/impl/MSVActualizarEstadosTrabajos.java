package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
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
public class MSVActualizarEstadosTrabajos extends MSVExcelValidatorAbstract {
		
	//Textos con errores de validacion
	public static final String TRABAJO_NO_EXISTE = "El trabajo no existe.";
	public static final String ACCION_VALIDA = "msg.error.masivo.estado.trabajos.accion.valida";
	public static final String COMENTARIO_OBLIGATORIO = "msg.error.masivo.estado.trabajos.comentario.obligatorio";
	public static final String ESTADO_FINALIZADO_SUBSANADO = "msg.error.masivo.estado.trabajos.estado.finalizado.subsanado";
	public static final String FECHA_EJECUCION_CUMPLIMENTADA = "msg.error.masivo.estado.trabajos.fecha.ejecucion.cumplimentada";
	public static final String RESOLUCION_COMITE = "msg.error.masivo.estado.trabajos.resolucion.comite";
	public static final String LLAVES_CUMPLIMENTADAS = "msg.error.masivo.estado.trabajos.llaves.cumplimentadas";
	public static final String LA_ACCION_MAYUSCULA = "msg.error.masivo.estado.trabajos.accion.mayusculas";


	//Posicion fija de Columnas excel, para validaciones especiales de diccionario
	public static final int COL_ID_TRABAJO = 0;
	public static final int COL_ACCION= 1;
	public static final int COL_COMENTARIO = 2;

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
	
	private Integer numFilasHoja;
	

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getRuta());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion()));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getRuta());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {

				Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
				mapaErrores.put(TRABAJO_NO_EXISTE, isTrabajoNoExiste(exc));
				mapaErrores.put(messageServices.getMessage(ACCION_VALIDA), isAccionValid(exc));
				mapaErrores.put(messageServices.getMessage(COMENTARIO_OBLIGATORIO), comentarioObligatorio(exc));
				mapaErrores.put(messageServices.getMessage(ESTADO_FINALIZADO_SUBSANADO), isEstadoPrevioFinalizadoSubsanado(exc));
				mapaErrores.put(messageServices.getMessage(FECHA_EJECUCION_CUMPLIMENTADA), isFechaEjecucionCumplimentada(exc));
				mapaErrores.put(messageServices.getMessage(RESOLUCION_COMITE), resolucionComite(exc));
				mapaErrores.put(messageServices.getMessage(LLAVES_CUMPLIMENTADAS), isTieneLlaves(exc));
				mapaErrores.put(messageServices.getMessage(LA_ACCION_MAYUSCULA), isMayuscula(exc));


				for (Entry<String, List<Integer>> registro : mapaErrores.entrySet()) {
					if (!registro.getValue().isEmpty()) {
						dtoValidacionContenido.setFicheroTieneErrores(true);
						dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
						break;
					}
				}				
			
		exc.cerrar();
		}
		
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

	
	private List<Integer> isTrabajoNoExiste(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.existeTrabajo(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> isAccionValid(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		try{
			String codigoAccion = null;
			for(int i=1; i<this.numFilasHoja;i++){

				try {

					if(!Checks.esNulo(exc.dameCelda(i, COL_ACCION))) {
						codigoAccion = exc.dameCelda(i, COL_ACCION);
					} else {
						codigoAccion = null;
					}

					if(!Checks.esNulo(codigoAccion) && !codigoAccion.equalsIgnoreCase("13") && !codigoAccion.equalsIgnoreCase("REJ") && !codigoAccion.equalsIgnoreCase("CAN") ) {
						listaFilas.add(i);
					}

				} catch (ParseException e) {
					listaFilas.add(i);
				}

			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> comentarioObligatorio(MSVHojaExcel exc){
	List<Integer> listaFilas = new ArrayList<Integer>();
	for (int i = 1; i < this.numFilasHoja; i++) {
		try {
			String celdaAccion= exc.dameCelda(i, COL_ACCION);
			String celdaComentario = exc.dameCelda(i, COL_COMENTARIO);
			
			if (celdaAccion.equalsIgnoreCase("REJ") && Checks.esNulo(celdaComentario)){
				listaFilas.add(i);				
			}
			
		} catch (Exception e) {
			listaFilas.add(i);
			logger.error(e.getMessage());
		}
	}
	return listaFilas;
}
	
	private List<Integer> isMayuscula(MSVHojaExcel exc){
	List<Integer> listaFilas = new ArrayList<Integer>();
	for (int i = 1; i < this.numFilasHoja; i++) {
		try {
			String celdaAccion= exc.dameCelda(i, COL_ACCION);
			String accionMayus = exc.dameCelda(i, COL_ACCION).toUpperCase(); 
			if (!celdaAccion.equals(accionMayus)){
				listaFilas.add(i);				
			}
			
		} catch (Exception e) {
			listaFilas.add(i);
			logger.error(e.getMessage());
		}
	}
	return listaFilas;
}
	
	private List<Integer> isEstadoPrevioFinalizadoSubsanado(MSVHojaExcel exc){
	List<Integer> listaFilas = new ArrayList<Integer>();
	for (int i = 1; i < this.numFilasHoja; i++) {
		try {
			String celdaAccion= exc.dameCelda(i, COL_ACCION);
			String celdaTrabajo = exc.dameCelda(i, COL_ID_TRABAJO);
			
			if (celdaAccion.equalsIgnoreCase("REJ") || celdaAccion.equalsIgnoreCase("13")){
				if(!particularValidator.estadoPrevioTrabajo(celdaTrabajo)) {
					listaFilas.add(i);	
				}
			}
			
		} catch (Exception e) {
			listaFilas.add(i);
			logger.error(e.getMessage());
		}
	}
	return listaFilas;
}
	
	private List<Integer> isFechaEjecucionCumplimentada(MSVHojaExcel exc){
	List<Integer> listaFilas = new ArrayList<Integer>();
	for (int i = 1; i < this.numFilasHoja; i++) {
		try {
			String celdaAccion= exc.dameCelda(i, COL_ACCION);
			String celdaTrabajo = exc.dameCelda(i, COL_ID_TRABAJO);
			
			if (celdaAccion.equalsIgnoreCase("13")){
				if(!particularValidator.fechaEjecucionCumplimentada(celdaTrabajo)) {
					listaFilas.add(i);	
				}
			}
			
		} catch (Exception e) {
			listaFilas.add(i);
			logger.error(e.getMessage());
		}
	}
	return listaFilas;
}
	
	private List<Integer> resolucionComite(MSVHojaExcel exc){
	List<Integer> listaFilas = new ArrayList<Integer>();
	for (int i = 1; i < this.numFilasHoja; i++) {
		try {
			String celdaAccion= exc.dameCelda(i, COL_ACCION);
			String celdaTrabajo = exc.dameCelda(i, COL_ID_TRABAJO);
			
			if (celdaAccion.equalsIgnoreCase("13")){
				if(particularValidator.checkComite(celdaTrabajo)) {
					if(!particularValidator.resolucionComite(celdaTrabajo)) {
						listaFilas.add(i);	
					}
				}
			}
			
		} catch (Exception e) {
			listaFilas.add(i);
			logger.error(e.getMessage());
		}
	}
	return listaFilas;
}
	
	private List<Integer> isTieneLlaves(MSVHojaExcel exc){
	List<Integer> listaFilas = new ArrayList<Integer>();
	for (int i = 1; i < this.numFilasHoja; i++) {
		try {
			String celdaAccion= exc.dameCelda(i, COL_ACCION);
			String celdaTrabajo = exc.dameCelda(i, COL_ID_TRABAJO);
			
			if (celdaAccion.equalsIgnoreCase("13")){
				if(particularValidator.tieneLlaves(celdaTrabajo)) {
					if(!particularValidator.checkLlaves(celdaTrabajo)) {
						if(!particularValidator.checkProveedoresLlaves(celdaTrabajo)) {
							listaFilas.add(i);	
						}
					}
				}
			}
			
		} catch (Exception e) {
			listaFilas.add(i);
			logger.error(e.getMessage());
		}
	}
	return listaFilas;
	}
	
	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
}