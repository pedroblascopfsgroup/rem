package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationRunner;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVValidationResult;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVMultiColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.dto.ResultadoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;

@Component
public class MSVActualizarPropuestaPreciosActivo extends MSVExcelValidatorAbstract {

	// Primera fila de la propuesta y columna con "num activo"
	public static final int EXCEL_FILA_INICIAL = 8;
	public static final int EXCEL_COL_NUMACTIVO = 5;
	
	// Posición de columna de los importes de valores/precios de la propuesta
	public static final int COL_VAL_VNC = 38; //VNC
	public static final int COL_VAL_PAV = 66; //Precio aut. venta
	public static final int COL_VAL_PAR = 69; //Precio aut. renta
	public static final int COL_VAL_MIN = 62; //Precio minimo
	public static final int COL_VAL_PDA = 56; //Precio desc. aprob.
	public static final int COL_VAL_PDP = 59; //Precio desc. publ.
	public static final int COL_VAL_VEV = 30; //Valor estimado venta
	public static final int COL_VAL_VRF = 36; //Valor referencia
	public static final int COL_VAL_VTF = 38; //Valor transferencia
	public static final int COL_VAL_CAD = 39; //Coste adquisicion
	public static final int COL_VAL_FSV = 34; //FSV Venta
	
	// Posicion de columna de las fechas INICIO/FIN de los precios
	public static final int COL_FINI_PAV = 67;
	public static final int COL_FFIN_PAV = 68;
	public static final int COL_FINI_PAR = 70;
	public static final int COL_FFIN_PAR = 71;
	public static final int COL_FINI_MIN = 63;
	public static final int COL_FFIN_MIN = 64;
	public static final int COL_FINI_PDA = 57;
	public static final int COL_FFIN_PDA = 58;
	public static final int COL_FINI_PDP = 60;
	public static final int COL_FFIN_PDP = 61;

	// Posicion de columna de las fechas de valores
	public static final int COL_FECHA_VEV = 31;
	public static final int COL_FECHA_VRF = 37;
	public static final int COL_FECHA_FSV = 35;
	
	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_PRIZE_NAN = "msg.error.masivo.actualizar.propuesta.precios.activo.activoPrecioNaN";
	public static final String ACTIVE_PRIZES_DESCUENTOS_LIMIT_EXCEEDED = "El precio de descuento aprobado no puede ser mayor al precio de descuento publicado (P.Descuento <= P.Descuento Pub.) o uno de estos precios no tiene un formato correcto";
	public static final String ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED = "msg.error.masivo.actualizar.propuesta.precios.activo.activoPrecioVentaMinimoLimiteExcedido";
	public static final String ACTIVE_PRIZES_VENTA_DESCUENTOWEB_LIMIT_EXCEEDED = "El precio de descuento publicado no puede ser mayor al precio aprobado de venta (P.Descuento Pub. <= P.Aprobado Venta) o uno de estos precios no tiene un formato correcto";
	public static final String ACTIVE_PAV_DATE_INIT_EXCEEDED = "La fecha de inicio del precio aprobado de venta no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_PMA_DATE_INIT_EXCEEDED = "msg.error.masivo.actualizar.propuesta.precios.activo.activoPMAFechaExcedida";
	public static final String ACTIVE_PAR_DATE_INIT_EXCEEDED = "La fecha de inicio del precio aprobado de renta no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_PDA_DATE_INIT_EXCEEDED = "La fecha de inicio del precio de descuento aprobado no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_PDP_DATE_INIT_EXCEEDED = "La fecha de inicio del precio de descuento publicado no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	
	public static final String ACTIVE_FSV_DATE_INIT_FORMAT = "La fecha del valor FSV venta no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_VRF_DATE_INIT_FORMAT = "La fecha del valor de referencia no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_VEV_DATE_INIT_FORMAT = "La fecha del valor estimado de venta no tiene un formato correcto (DD/MM/AAAA)";
	
	public static final String PROPUESTA_YA_CARGADA = "Esta propuesta ya ha sido cargada anteriormente.";
	
//	public static final String ACTIVE_NOT_ACTUALIZABLE = "El estado del activo no puede actualizarse al indicado.";
//	public static final String ACTIVE_PRECIOS_BLOQUEO = "El activo tiene habilitado el bloqueo de precios. No se pueden actualizar precios";
//	public static final String ACTIVE_OFERTA_APROBADA = "El activo tiene ofertas aprobadas. No se pueden actualizar precios";

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Resource
    MessageService messageServices;

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) {
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}

		// El masivo de propuesta NO REALIZA las validaciones de contenido y formato
		// que se realizan por defecto en todos los masivos
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = new MSVDtoValidacion();
		dtoValidacionContenido.setFicheroTieneErrores(false);
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion --------------
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
//			if (!isActiveExists(exc)){
				Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
				mapaErrores.put(PROPUESTA_YA_CARGADA, isPropuestaYaCargada(exc));
				//Si la propuesta ya ha sido cargada, no se realizan el resto de comprobaciones
				if(mapaErrores.get(PROPUESTA_YA_CARGADA).isEmpty()) {
					mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
					mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZE_NAN), getNANPrecioIncorrectoRows(exc));
					mapaErrores.put(ACTIVE_PRIZES_DESCUENTOS_LIMIT_EXCEEDED, getLimitePreciosDescAprobDescWebIncorrectoRows(exc));
					mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED), getLimitePreciosAprobadoMinimoIncorrectoRows(exc));
					mapaErrores.put(ACTIVE_PRIZES_VENTA_DESCUENTOWEB_LIMIT_EXCEEDED, getLimitePreciosAprobadoDescWebIncorrectoRows(exc));
					mapaErrores.put(ACTIVE_PAV_DATE_INIT_EXCEEDED, getFechaInicioAprobadoVentaIncorrectaRows(exc));
					mapaErrores.put(ACTIVE_PAR_DATE_INIT_EXCEEDED, getFechaInicioAprobadoRentaIncorrectaRows(exc));
					mapaErrores.put(messageServices.getMessage(ACTIVE_PMA_DATE_INIT_EXCEEDED), getFechaInicioMinimoAuthIncorrectaRows(exc));
					mapaErrores.put(ACTIVE_PDA_DATE_INIT_EXCEEDED, getFechaInicioDescuentoAprobIncorrectaRows(exc));
					mapaErrores.put(ACTIVE_PDP_DATE_INIT_EXCEEDED, getFechaInicioDescuentoPubIncorrectaRows(exc));
					mapaErrores.put(ACTIVE_VEV_DATE_INIT_FORMAT, getFechaVEVIncorrectaRows(exc));
					mapaErrores.put(ACTIVE_VRF_DATE_INIT_FORMAT, getFechaVRFIncorrectaRows(exc));
					mapaErrores.put(ACTIVE_FSV_DATE_INIT_FORMAT, getFechaFSVIncorrectaRows(exc));
				}

				try{
					if(!mapaErrores.get(PROPUESTA_YA_CARGADA).isEmpty() ||
							!mapaErrores.get(ACTIVE_NOT_EXISTS).isEmpty() ||
							!mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZE_NAN)).isEmpty() ||
							!mapaErrores.get(ACTIVE_PRIZES_DESCUENTOS_LIMIT_EXCEEDED).isEmpty() ||
							!mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED)).isEmpty() ||
							!mapaErrores.get(ACTIVE_PRIZES_VENTA_DESCUENTOWEB_LIMIT_EXCEEDED).isEmpty() || 
							!mapaErrores.get(ACTIVE_PAV_DATE_INIT_EXCEEDED).isEmpty() ||
							!mapaErrores.get(ACTIVE_PAR_DATE_INIT_EXCEEDED).isEmpty() ||
							!mapaErrores.get(messageServices.getMessage(ACTIVE_PMA_DATE_INIT_EXCEEDED)).isEmpty() ||
							!mapaErrores.get(ACTIVE_PDA_DATE_INIT_EXCEEDED).isEmpty() || 
							!mapaErrores.get(ACTIVE_PDP_DATE_INIT_EXCEEDED).isEmpty() ||
							!mapaErrores.get(ACTIVE_VEV_DATE_INIT_FORMAT).isEmpty() ||
							!mapaErrores.get(ACTIVE_VRF_DATE_INIT_FORMAT).isEmpty() ||
							!mapaErrores.get(ACTIVE_FSV_DATE_INIT_FORMAT).isEmpty() ){
						dtoValidacionContenido.setFicheroTieneErrores(true);
						exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
						String nomFicheroErrores = exc.crearExcelErroresMejoradoByHojaAndFilaCabecera(mapaErrores,0,7);
						FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
						dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
//			}
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
	
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, EXCEL_COL_NUMACTIVO)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getNANPrecioIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioVNC = null;
		Double precioVentaAprobado = null;
		Double precioRentaAprobado = null;
		Double precioMinimoAuth = null;
		Double precioDescuentoAprobado = null;
		Double precioDescuentoPublicado = null;
		Double valorEstimadoVenta = null;
		Double valorReferencia = null;
		Double valorTransferencia = null;
		Double costeAdquisicion = null;
		Double valorFSVVenta = null;
		
		// Validacion que evalua si los precios son numeros correctos
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					precioVNC = !Checks.esNulo(exc.dameCelda(i, COL_VAL_VNC)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_VNC)) : null;
					precioVentaAprobado = !Checks.esNulo(exc.dameCelda(i, COL_VAL_PAV)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_PAV)) : null;
					precioRentaAprobado = !Checks.esNulo(exc.dameCelda(i, COL_VAL_PAR)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_PAR)) : null;
					precioMinimoAuth = !Checks.esNulo(exc.dameCelda(i, COL_VAL_MIN)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_MIN)) : null;
					precioDescuentoAprobado = !Checks.esNulo(exc.dameCelda(i, COL_VAL_PDA)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_PDA)) : null;
					precioDescuentoPublicado = !Checks.esNulo(exc.dameCelda(i, COL_VAL_PDP)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_PDP)) : null;
					valorEstimadoVenta = !Checks.esNulo(exc.dameCelda(i, COL_VAL_VEV)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_VEV)) : null;
					valorReferencia = !Checks.esNulo(exc.dameCelda(i, COL_VAL_VRF)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_VRF)) : null;
					valorTransferencia = !Checks.esNulo(exc.dameCelda(i, COL_VAL_VTF)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_VTF)) : null;
					costeAdquisicion = !Checks.esNulo(exc.dameCelda(i, COL_VAL_CAD)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_CAD)) : null;
					valorFSVVenta = !Checks.esNulo(exc.dameCelda(i, COL_VAL_FSV)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_FSV)) : null;
					
					// Si alguno de los precios no es un numero
					if((!Checks.esNulo(precioVNC) && precioVNC.isNaN()) ||
						(!Checks.esNulo(precioVentaAprobado) && precioVentaAprobado.isNaN()) ||
						(!Checks.esNulo(precioRentaAprobado) && precioRentaAprobado.isNaN()) ||
						(!Checks.esNulo(precioMinimoAuth) && precioMinimoAuth.isNaN()) ||
						(!Checks.esNulo(precioDescuentoAprobado) && precioDescuentoAprobado.isNaN()) ||
						(!Checks.esNulo(precioDescuentoPublicado) && precioDescuentoPublicado.isNaN()) ||
						(!Checks.esNulo(valorEstimadoVenta) && valorEstimadoVenta.isNaN()) ||
						(!Checks.esNulo(valorReferencia) && valorReferencia.isNaN()) ||
						(!Checks.esNulo(valorTransferencia) && valorTransferencia.isNaN()) ||
						(!Checks.esNulo(costeAdquisicion) && costeAdquisicion.isNaN()) ||
						(!Checks.esNulo(valorFSVVenta) && valorFSVVenta.isNaN()) )
						listaFilas.add(i);	
				} catch (NumberFormatException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> getLimitePreciosDescAprobDescWebIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioDescuentoAprobado = null;
		Double precioDescuentoPublicado = null;
		
		// Validacion que evalua si los precios estan dentro de los límites, comparandolos entre si
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					precioDescuentoAprobado = !Checks.esNulo(exc.dameCelda(i, COL_VAL_PDA)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_PDA)) : null;
					precioDescuentoPublicado = !Checks.esNulo(exc.dameCelda(i, COL_VAL_PDP)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_PDP)) : null;
					
					// Condiciones Limites: dto<=dto web<=aprobado
					
					// Limite: Precio Descuento Web >= Precio Descuento Aprobado
					if(!Checks.esNulo(precioDescuentoAprobado) && 
							!Checks.esNulo(precioDescuentoPublicado) &&
							(precioDescuentoAprobado > precioDescuentoPublicado)){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (NumberFormatException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> getLimitePreciosAprobadoMinimoIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioVentaAprobado = null;
		Double precioMinimoAuth = null;
		
		// Validacion que evalua si los precios estan dentro de los límites, comparandolos entre si
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					precioVentaAprobado = !Checks.esNulo(exc.dameCelda(i, COL_VAL_PAV)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_PAV)) : null;
					precioMinimoAuth = !Checks.esNulo(exc.dameCelda(i, COL_VAL_MIN)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_MIN)) : null;
					
					// Condiciones Limites: dto<=dto web<=aprobado
					
					// Limite: Precio Aprobado Venta >= Precio Minimo Auth
					if(!Checks.esNulo(precioMinimoAuth) && 
							!Checks.esNulo(precioVentaAprobado) &&
							(precioMinimoAuth > precioVentaAprobado)){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (NumberFormatException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> getLimitePreciosAprobadoDescWebIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioVentaAprobado = null;
		Double precioDescuentoPublicado = null;
		
		// Validacion que evalua si los precios estan dentro de los límites, comparandolos entre si
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					precioVentaAprobado = !Checks.esNulo(exc.dameCelda(i, COL_VAL_PAV)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_PAV)) : null;
					precioDescuentoPublicado = !Checks.esNulo(exc.dameCelda(i, COL_VAL_PDP)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_PDP)) : null;
					
					// Condiciones Limites: dto<=dto web<=aprobado y aprobado>=minimo
					
					// Limite: Precio Aprobado Venta >= Precio Descuento Web
					if(!Checks.esNulo(precioVentaAprobado) && 
							!Checks.esNulo(precioDescuentoPublicado) &&
							(precioDescuentoPublicado > precioVentaAprobado)){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (NumberFormatException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> getFechaInicioAprobadoVentaIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioPAV = null;
		Date fechaFinPAV = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					fechaInicioPAV = !Checks.esNulo(exc.dameCelda(i, COL_FINI_PAV)) ? ft.parse(exc.dameCelda(i, COL_FINI_PAV)) : null;
					fechaFinPAV = !Checks.esNulo(exc.dameCelda(i, COL_FFIN_PAV)) ? ft.parse(exc.dameCelda(i, COL_FFIN_PAV)) : null;
					
					//Fecha Inicio <= Fecha Fin
					if(!Checks.esNulo(fechaInicioPAV) && 
							!Checks.esNulo(fechaFinPAV) &&
							(fechaInicioPAV.after(fechaFinPAV))){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}	
		return listaFilas;
	}

	private List<Integer> getFechaInicioAprobadoRentaIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioPAR = null;
		Date fechaFinPAR = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					fechaInicioPAR = !Checks.esNulo(exc.dameCelda(i, COL_FINI_PAR)) ? ft.parse(exc.dameCelda(i, COL_FINI_PAR)) : null;
					fechaFinPAR = !Checks.esNulo(exc.dameCelda(i, COL_FFIN_PAR)) ? ft.parse(exc.dameCelda(i, COL_FFIN_PAR)) : null;
					
					//Fecha Inicio <= Fecha Fin
					if(!Checks.esNulo(fechaInicioPAR) && 
							!Checks.esNulo(fechaFinPAR) &&
							(fechaInicioPAR.after(fechaFinPAR))){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}	
		return listaFilas;
	}

	private List<Integer> getFechaInicioMinimoAuthIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioPMA = null;
		Date fechaFinPMA = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					fechaInicioPMA = !Checks.esNulo(exc.dameCelda(i, COL_FINI_MIN)) ? ft.parse(exc.dameCelda(i, COL_FINI_MIN)) : null;
					fechaFinPMA = !Checks.esNulo(exc.dameCelda(i, COL_FFIN_MIN)) ? ft.parse(exc.dameCelda(i, COL_FFIN_MIN)) : null;
					
					//Fecha Inicio <= Fecha Fin
					if(!Checks.esNulo(fechaInicioPMA) && 
							!Checks.esNulo(fechaFinPMA) &&
							(fechaInicioPMA.after(fechaFinPMA))){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> getFechaInicioDescuentoAprobIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioPDA = null;
		Date fechaFinPDA = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					fechaInicioPDA = !Checks.esNulo(exc.dameCelda(i, COL_FINI_PDA)) ? ft.parse(exc.dameCelda(i, COL_FINI_PDA)) : null;
					fechaFinPDA = !Checks.esNulo(exc.dameCelda(i, COL_FFIN_PDA)) ? ft.parse(exc.dameCelda(i, COL_FFIN_PDA)) : null;
					
					//Fecha Inicio <= Fecha Fin
					if(!Checks.esNulo(fechaInicioPDA) && 
							!Checks.esNulo(fechaFinPDA) &&
							(fechaInicioPDA.after(fechaFinPDA))){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> getFechaInicioDescuentoPubIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioPDP = null;
		Date fechaFinPDP = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					fechaInicioPDP = !Checks.esNulo(exc.dameCelda(i, COL_FINI_PDP)) ? ft.parse(exc.dameCelda(i, COL_FINI_PDP)) : null;
					fechaFinPDP = !Checks.esNulo(exc.dameCelda(i, COL_FFIN_PDP)) ? ft.parse(exc.dameCelda(i, COL_FFIN_PDP)) : null;
					
					//Fecha Inicio <= Fecha Fin
					if(!Checks.esNulo(fechaInicioPDP) && 
							!Checks.esNulo(fechaFinPDP) &&
							(fechaInicioPDP.after(fechaFinPDP))){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getFechaVEVIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaVEV = null;
		
		// Validacion que evalua si las fechas tienen un formato correcto
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					fechaVEV = !Checks.esNulo(exc.dameCelda(i, COL_FECHA_VEV)) ? ft.parse(exc.dameCelda(i, COL_FECHA_VEV)) : null;
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}	
		return listaFilas;
	}

	private List<Integer> getFechaVRFIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaVRF = null;
		
		// Validacion que evalua si las fechas tienen un formato correcto
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					fechaVRF = !Checks.esNulo(exc.dameCelda(i, COL_FECHA_VRF)) ? ft.parse(exc.dameCelda(i, COL_FECHA_VRF)) : null;
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getFechaFSVIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaFSV = null;
		
		// Validacion que evalua si las fechas tienen un formato correcto
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					fechaFSV = !Checks.esNulo(exc.dameCelda(i, COL_FECHA_FSV)) ? ft.parse(exc.dameCelda(i, COL_FECHA_FSV)) : null;
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}	
		return listaFilas;
	}
	
	private List<Integer> isPropuestaYaCargada(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		Long numPropuesta = null;
		
		try {
			numPropuesta = Long.parseLong(exc.dameCelda(1, 2));
			if(!Checks.esNulo(numPropuesta)) {
				if(particularValidator.esPropuestaYaCargada(numPropuesta))
					listaFilas.add(1);
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
}