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
	
	
//	
//	private List<Integer> getFormalizarActivoNoComercializable(MSVHojaExcel exc){
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		
//		/* Validacion que evalua en el caso de poner valor S en Formalizar y no informar Comercializar.
//		 * Comprueba que el activo sea comercializable para poder activar Formalizar.
//		 */
//		try{
//			String valorConFormalizar = "-";
//			for(int i=1; i<this.numFilasHoja;i++){
//				
//				try {
//					valorConFormalizar = exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).trim().toUpperCase();
//					if("S".equals(valorConFormalizar)) {
//						
//						String valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();				
//						if("-".equals(valorConComercial) ) {
//							
//							if(particularValidator.isActivoNoComercializable(exc.dameCelda(i, 0)))
//								listaFilas.add(i);
//						}
//					}
//				} catch (ParseException e) {
//					listaFilas.add(i);
//				}
//			}
//		} catch (Exception e) {
//			listaFilas.add(0);
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		}
//		return listaFilas;
//	}
//	
//	private List<Integer> getComercializarConOfertasVivas(MSVHojaExcel exc){
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		
//		/* Validacion que evalua en el caso de poner valor N en Comercializar (o en Perimetro).
//		 * Comprueba que el activo NO tenga ofertas vivas, para poder quitarlo de comercialización.
//		 */
//		try{
//			for(int i=1; i<this.numFilasHoja;i++){
//				try {
//					String valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();	
//					String valorEnPerimetro = exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).trim().toUpperCase();
//					if("N".equals(valorConComercial) || "N".equals(valorEnPerimetro)) {
//						
//						if(particularValidator.existeActivoConOfertaViva(exc.dameCelda(i, 0)))
//							listaFilas.add(i);
//					}
//				} catch (ParseException e) {
//					listaFilas.add(i);
//				}
//			}
//		} catch (Exception e) {
//			listaFilas.add(0);
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		}
//		return listaFilas;
//	}
//	
//	private List<Integer> getFormalizarConExpedienteVivo(MSVHojaExcel exc){
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		
//		/* Validacion que evalua en el caso de poner valor N en Formalizar (o en Comercializar, o en Perimetro)
//		 * Comprueba que el activo NO tenga un expediente comercial vivo (con tareas activas), para poder sacarlo de formalización.
//		 */
//		try{
//			for(int i=1; i<this.numFilasHoja;i++){
//				try {
//					String valorConFormalizar= exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_FORMALIZAR_SN).trim().toUpperCase();
//					String valorEnPerimetro = exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN).trim().toUpperCase();
//					String valorConComercial = exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).isEmpty() ? "-" : exc.dameCelda(i, COL_NUM_CON_COMERCIAL_SN).trim().toUpperCase();	
//					if("N".equals(valorConFormalizar) || "N".equals(valorEnPerimetro) || "N".equals(valorConComercial)) {
//						
//						if(particularValidator.existeActivoConExpedienteComercialVivo(exc.dameCelda(i, 0)))
//							listaFilas.add(i);
//					}
//				} catch (ParseException e) {
//					listaFilas.add(i);
//				}
//			}
//		} catch (Exception e) {
//			listaFilas.add(0);
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		}
//		return listaFilas;
//	}
//
//
//	private List<Integer> getOfertasVentaVivasRows(MSVHojaExcel exc) {
//		List<Integer> listaFilas = new ArrayList<Integer>();
//
//		/**
//		 * 		Validará que no se intenté cambiar de venta a alquiler un activo que tenga ofertas
//		 *		de tipo venta vivas
//		 */
//		try{
//			String codigoDestinoComercial = null;
//			String codigoDestinoComercialActual = null;
//			for(int i=1; i<this.numFilasHoja;i++){
//
//				try {
//
//					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL))) {
//						codigoDestinoComercial = exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL).substring(0, 2);
//					} else {
//						codigoDestinoComercial = null;
//					}
//
//				  	codigoDestinoComercialActual = particularValidator.getCodigoDestinoComercialByNumActivo(exc.dameCelda(i, COL_NUM_ACTIVO_HAYA));
//
//					if (!Checks.esNulo(codigoDestinoComercialActual) && !Checks.esNulo(codigoDestinoComercial)
//							&& CODIGO_SOLO_ALQUILER.equals(codigoDestinoComercial)
//							&& (CODIGO_VENTA.equals(codigoDestinoComercialActual)
//									|| CODIGO_ALQUILER_VENTA.equals(codigoDestinoComercialActual))
//							&& particularValidator.existeActivoConOfertaVentaViva("" + exc.dameCelda(i, COL_NUM_ACTIVO_HAYA))) {
//						listaFilas.add(i);
//					}
//
//				} catch (ParseException e) {
//					listaFilas.add(i);
//				}
//
//			}
//		} catch (Exception e) {
//			listaFilas.add(0);
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		}
//		return listaFilas;
//	}
//
//
//	private List<Integer> getOfertasAlquilerVivasRows(MSVHojaExcel exc) {
//		List<Integer> listaFilas = new ArrayList<Integer>();
//
//		/**
//		 * 		Validará que no se intenté cambiar de alquiler a venta un activo que tenga ofertas
//		 *		de tipo alquiler vivas
//		 */
//		try{
//			String codigoDestinoComercial = null;
//			String codigoDestinoComercialActual = null;
//			for(int i=1; i<this.numFilasHoja;i++){
//
//				try {
//
//					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL))) {
//						codigoDestinoComercial = exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL).substring(0, 2);
//					} else {
//						codigoDestinoComercial = null;
//					}
//
//				  	codigoDestinoComercialActual = particularValidator.getCodigoDestinoComercialByNumActivo(exc.dameCelda(i, COL_NUM_ACTIVO_HAYA));
//
//					if (!Checks.esNulo(codigoDestinoComercialActual) && !Checks.esNulo(codigoDestinoComercial)
//							&& CODIGO_VENTA.equals(codigoDestinoComercial)
//							&& (CODIGO_SOLO_ALQUILER.equals(codigoDestinoComercialActual)
//									|| CODIGO_ALQUILER_VENTA.equals(codigoDestinoComercialActual))
//							&& particularValidator.existeActivoConOfertaAlquilerViva("" + exc.dameCelda(i, COL_NUM_ACTIVO_HAYA))) {
//						listaFilas.add(i);
//					}
//
//				} catch (ParseException e) {
//					listaFilas.add(i);
//				}
//
//			}
//		} catch (Exception e) {
//			listaFilas.add(0);
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		}
//		return listaFilas;
//	}
//	
//	private List<Integer> isActivoFinanciero(MSVHojaExcel exc){
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		
//		try{
//			for(int i=1; i<this.numFilasHoja;i++){
//				try {
//					if(particularValidator.isActivoFinanciero(exc.dameCelda(i, COL_NUM_ACTIVO_HAYA)) && CHECK_VALOR_SI.equals(getCheckValue(exc.dameCelda(i, COL_NUM_EN_PERIMETRO_SN))))
//						listaFilas.add(i);
//				} catch (ParseException e) {
//					listaFilas.add(i);
//				}
//			}
//		} catch (Exception e) {
//			listaFilas.add(0);
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		}
//		return listaFilas;
//	}
//
//	private Integer getCheckValue(String cellValue){
//		if(!Checks.esNulo(cellValue)){
//			if("S".equalsIgnoreCase(cellValue) || String.valueOf(CHECK_VALOR_SI).equalsIgnoreCase(cellValue))
//				return CHECK_VALOR_SI;
//			else
//				return CHECK_VALOR_NO;
//		}
//		return CHECK_NO_CAMBIAR;	
//	}
//	
//	private List<Integer> isActivoMatriz(MSVHojaExcel exc){
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		
//		try{
//			for(int i=1; i<this.numFilasHoja;i++){
//				try {
//					if(particularValidator.isActivoMatriz(exc.dameCelda(i, 0)))
//						listaFilas.add(i);
//				} catch (ParseException e) {
//					listaFilas.add(i);
//				}
//			}
//		} catch (Exception e) {
//			listaFilas.add(0);
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		}
//		return listaFilas;
//	}
//	
//	private List<Integer> isUA(MSVHojaExcel exc){
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		
//		try{
//			for(int i=1; i<this.numFilasHoja;i++){
//				try {
//					if(particularValidator.isUA(exc.dameCelda(i, 0)))
//						listaFilas.add(i);
//				} catch (ParseException e) {
//					listaFilas.add(i);
//				}
//			}
//		} catch (Exception e) {
//			listaFilas.add(0);
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		}
//		return listaFilas;
//	}
//	
//	private List<Integer> isActivoEnCesionDeUso(MSVHojaExcel exc){
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		
//		try{
//			for(int i=1; i<this.numFilasHoja;i++){
//				try {
//					if(particularValidator.isActivoEnCesionDeUso(exc.dameCelda(i, 0)))
//						listaFilas.add(i); 
//				} catch (ParseException e) {
//					listaFilas.add(i);
//				}
//			}
//		} catch (Exception e) {
//			listaFilas.add(0);
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		}
//		return listaFilas;
//	}
//	private List<Integer> isActivoEnAlquilerSocial(MSVHojaExcel exc){
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		
//		try{
//			for(int i=1; i<this.numFilasHoja;i++){
//				try {
//					if(particularValidator.isActivoEnAlquilerSocial(exc.dameCelda(i, 0)))
//						listaFilas.add(i);
//				} catch (ParseException e) {
//					listaFilas.add(i);
//				}
//			}
//		} catch (Exception e) {
//			listaFilas.add(0);
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		}
//		
//		return listaFilas;
//	}
//	
//	private List<Integer> esSegmentoValido(MSVHojaExcel exc) {
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
//			try {
//				String celda = exc.dameCelda(i, COL_NUM_SEGMENTO);
//				if (!Checks.esNulo(celda) && !particularValidator.esSegmentoValido(celda))
//					listaFilas.add(i);
//			} catch (Exception e) {
//				listaFilas.add(i);
//				logger.error(e.getMessage());
//			}
//		}
//		return listaFilas;
//	}
//
//	private List<Integer> esPerimetroValido(MSVHojaExcel exc) {
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		String[] listaSN = { "SI", "S", "NO", "N" };
//		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
//			try {
//				String celda = exc.dameCelda(i, COL_NUM_PERIMETRO_MACC);
//				if (!Checks.esNulo(celda) && !Arrays.asList(listaSN).contains(celda.toUpperCase()))
//					listaFilas.add(i);
//			} catch (Exception e) {
//				listaFilas.add(i);
//				logger.error(e.getMessage());
//			}
//		}
//		return listaFilas;
//	}
//
//	private List<Integer> perteneceSegmentoCraScr(MSVHojaExcel exc) {
//		List<Integer> listaFilas = new ArrayList<Integer>();
//	
//		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
//			try {
//				String celdaActivo = exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);		
//				String celdaSegmento = exc.dameCelda(i, COL_NUM_SEGMENTO);
//				
//				if(celdaSegmento != null && !celdaSegmento.isEmpty() && !particularValidator.perteneceSegmentoCraScr(celdaSegmento, celdaActivo)) {
//					listaFilas.add(i);
//				}
//			} catch (Exception e) {
//				listaFilas.add(i);
//				logger.error(e.getMessage());
//			}
//		}
//		return listaFilas;
//	}
//	
//	private List<Integer> esSubcarteraDivarian(MSVHojaExcel exc) {
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
//			try {
//				String celdaActivo = exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);
//				String celdaMacc = exc.dameCelda(i, COL_NUM_PERIMETRO_MACC);
//				if (!Checks.esNulo(celdaMacc) && !particularValidator.esSubcarteraDivarian(celdaActivo))
//					listaFilas.add(i);
//			} catch (Exception e) {
//				listaFilas.add(i);
//				logger.error(e.getMessage());
//			}
//		}
//		return listaFilas;
//	}
//	
//	private List<Integer> esSegmentoMacc(MSVHojaExcel exc) {
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		String[] listaSi = { "SI", "S"};
//		final String DD_TIPO_MACC = "03";
//		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
//			try {
//				String celdaSegmento = exc.dameCelda(i, COL_NUM_SEGMENTO);
//				String celdaMacc = exc.dameCelda(i, COL_NUM_PERIMETRO_MACC);
//				if (!Checks.esNulo(celdaMacc) 
//						&& Arrays.asList(listaSi).contains(celdaMacc.toUpperCase())
//						&& !Checks.esNulo(celdaSegmento) && !DD_TIPO_MACC.equals(celdaSegmento)	)
//					listaFilas.add(i);
//			} catch (Exception e) {
//				listaFilas.add(i);
//				logger.error(e.getMessage());
//			}
//		}
//		return listaFilas;
//	}
//	
//	private List<Integer> esPerimetroMaccDestinoAlquiler(MSVHojaExcel exc) {
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		String[] listaSi = { "SI", "S" };
//		final String DD_DESTINO_ALQUILER = "03";
//		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
//			try {
//				String celdaDestinoComercial = exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL);
//				String celdaMacc = exc.dameCelda(i, COL_NUM_PERIMETRO_MACC);
//				String celdaActivo = exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);
//
//				if (!Checks.esNulo(celdaMacc) && Arrays.asList(listaSi).contains(celdaMacc.toUpperCase())
//						&&(!Checks.esNulo(celdaDestinoComercial) && !DD_DESTINO_ALQUILER.equals(celdaDestinoComercial)
//								|| Checks.esNulo(celdaDestinoComercial) && !particularValidator.activoConDestinoComercialAlquiler(celdaActivo))) {
//					listaFilas.add(i);				
//				}
//				
//			} catch (Exception e) {
//				listaFilas.add(i);
//				logger.error(e.getMessage());
//			}
//		}
//		return listaFilas;
//	}
//	
//	private List<Integer> esSegmentoInformado(MSVHojaExcel exc) {
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		String[] listaNo = { "NO", "N"};	
//		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
//			try {
//				String celdaSegmento = exc.dameCelda(i, COL_NUM_SEGMENTO);
//				String celdaMacc = exc.dameCelda(i, COL_NUM_PERIMETRO_MACC);
//				String celdaActivo = exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);
//				if (!Checks.esNulo(celdaMacc) 
//						&& Arrays.asList(listaNo).contains(celdaMacc.toUpperCase())
//						&& Checks.esNulo(celdaSegmento)	
//						&& Boolean.FALSE.equals((particularValidator.esSubcarteraApple(celdaActivo))))
//					listaFilas.add(i);
//			} catch (Exception e) {
//				listaFilas.add(i);
//				logger.error(e.getMessage());
//			}
//		}
//		return listaFilas;
//	}
//	
//	private List<Integer> esPerimetorYSegmentoMACC(MSVHojaExcel exc){
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		String[] listaSi = { "SI", "S" };
//		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
//			try {
//				String celdaDestinoComercial = exc.dameCelda(i, COL_NUM_DESTINO_COMERCIAL);
//				String celdaMacc = exc.dameCelda(i, COL_NUM_PERIMETRO_MACC);
//				String celdaActivo = exc.dameCelda(i, COL_NUM_ACTIVO_HAYA);
//				String celdaSegmento = exc.dameCelda(i, COL_NUM_SEGMENTO);
//				
//				if (!Checks.esNulo(celdaMacc) && Arrays.asList(listaSi).contains(celdaMacc.toUpperCase())
//						&&(!Checks.esNulo(celdaDestinoComercial) && !Checks.esNulo(celdaSegmento) && !Checks.esNulo(celdaActivo)
//						&& CODIGO_DD_TIPO_MACC.equals(celdaSegmento) && !particularValidator.aCambiadoDestinoComercial(celdaActivo,celdaDestinoComercial))
//						){
//					listaFilas.add(i);				
//				}
//				
//			} catch (Exception e) {
//				listaFilas.add(i);
//				logger.error(e.getMessage());
//			}
//		}
//		return listaFilas;
//	}
//	
//	
//	private List<Integer> isBooleanValidator(MSVHojaExcel exc, Integer col){
//		List<Integer> listaFilas = new ArrayList<Integer>();
//		
//		
//		try{
//			for(int i=1; i<this.numFilasHoja;i++){
//				try {
//					String celda = exc.dameCelda(i, col);
//					if(!Checks.esNulo(celda) && !Arrays.asList(listaValidos).contains(celda.toUpperCase()))
//						listaFilas.add(i);
//				} catch (ParseException e) {
//					listaFilas.add(i);
//				}
//			}
//		} catch (IllegalArgumentException e) {
//			listaFilas.add(0);
//			e.printStackTrace();
//		} catch (IOException e) {
//			listaFilas.add(0);
//			e.printStackTrace();
//		}
//		
//		return listaFilas;
//	}
	
	
}