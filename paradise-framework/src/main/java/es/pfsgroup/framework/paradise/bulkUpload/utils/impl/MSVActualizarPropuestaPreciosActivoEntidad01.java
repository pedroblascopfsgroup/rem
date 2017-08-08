package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
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
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
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
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;

@Component
public class MSVActualizarPropuestaPreciosActivoEntidad01 extends MSVExcelValidatorAbstract {

	// Primera fila de la propuesta y columna con "num activo"
	public static final int EXCEL_FILA_INICIAL = 6;
	public static final int EXCEL_COL_NUMACTIVO = 7;
	
	// Posición de columna de los importes de valores/precios de la propuesta
	public static final int COL_VAL_VNC = 33; //VNC
	public static final int COL_VAL_PAV = 61; //Precio aut. venta (Actual web)
	public static final int COL_VAL_PAR = 64; //Precio aut. renta
	public static final int COL_VAL_MIN = 57; //Precio minimo (Autorizado Cajamar)
	public static final int COL_VAL_VEV = 31; //Valor estimado venta (Valor colaborador)
	public static final int COL_VAL_VTF = 33; //Valor transferencia
	public static final int COL_VAL_CAD = 34; //Coste adquisicion
	public static final int COL_VAL_FSV = 29; //FSV Venta (valor Haya)
	
	// Posicion de columna de las fechas INICIO/FIN de los precios
	public static final int COL_FINI_MIN = 59;
	public static final int COL_FFIN_MIN = 60;
	public static final int COL_FINI_PAV = 62;
	public static final int COL_FFIN_PAV = 63;
	public static final int COL_FINI_PAR = 65;
	public static final int COL_FFIN_PAR = 66;

	// Posicion de columna de las fechas de valores
	public static final int COL_FECHA_VEV = 32;
	public static final int COL_FECHA_FSV = 30;
	
	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_NOT_INCLUDED_IN_PROPUESTA = "El activo no pertece a la propuesta cargada";
	public static final String ACTIVE_PRIZE_NAN = "msg.error.masivo.actualizar.propuesta.precios.activo.activoPrecioNaN";
	public static final String ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED = "msg.error.masivo.actualizar.propuesta.precios.activo.entidad01.activoPrecioVentaMinimoLimiteExcedido";
	public static final String ACTIVE_PRIZES_NOT_GREATER_ZERO = "msg.error.masivo.comunes.importe.no.mayor.cero";
	public static final String ACTIVE_PRIZES_NOT_GREATER_EQUAL_ZERO = "msg.error.masivo.comunes.importe.no.mayor.igual.cero";
	
	public static final String ACTIVE_MIN_DATE_INIT_EXCEEDED = "La fecha de inicio del precio autorizado cajamar no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_PAV_DATE_INIT_EXCEEDED = "La fecha de inicio del precio actual web no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_PAR_DATE_INIT_EXCEEDED = "La fecha de inicio del precio autorizado de renta no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	
	public static final String ACTIVE_FSV_DATE_INIT_FORMAT = "La fecha del valor HAYA no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_VEV_DATE_INIT_FORMAT = "La fecha del valor colaborador no tiene un formato correcto (DD/MM/AAAA)";
	
	public static final String PROPUESTA_YA_CARGADA = "Esta propuesta ya ha sido cargada anteriormente.";

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private MSVExcelParser excelParser;
	
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
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) {
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
				
		// El masivo de propuesta NO REALIZA las validaciones de contenido y formato
		// que se realizan por defecto en todos los masivos
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = new MSVDtoValidacion();
		dtoValidacionContenido.setFicheroTieneErrores(false);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion --------------
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(1, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
			mapaErrores.put(PROPUESTA_YA_CARGADA, isPropuestaYaCargada(exc));
			//Si la propuesta ya ha sido cargada, no se realizan el resto de comprobaciones
			if(mapaErrores.get(PROPUESTA_YA_CARGADA).isEmpty()) {
				mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
				mapaErrores.put(ACTIVE_NOT_INCLUDED_IN_PROPUESTA, isActiveNotIncludesInPropuestaRows(exc));
				mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZE_NAN), getNANPrecioIncorrectoRows(exc));
				mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED), getLimitePreciosAprobadoMinimoIncorrectoRows(exc));
				//HREOS-2608 - El importe 0 se utiliza para descartar activos de la propuesta
				mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZES_NOT_GREATER_EQUAL_ZERO), isPreciosMayorIgualCeroRows(exc));
				mapaErrores.put(ACTIVE_PAV_DATE_INIT_EXCEEDED, getFechaInicioAprobadoVentaIncorrectaRows(exc));
				mapaErrores.put(ACTIVE_PAR_DATE_INIT_EXCEEDED, getFechaInicioAprobadoRentaIncorrectaRows(exc));
				mapaErrores.put(ACTIVE_MIN_DATE_INIT_EXCEEDED, getFechaMINIncorrectaRows(exc));
				mapaErrores.put(ACTIVE_VEV_DATE_INIT_FORMAT, getFechaVEVIncorrectaRows(exc));
				mapaErrores.put(ACTIVE_FSV_DATE_INIT_FORMAT, getFechaFSVIncorrectaRows(exc));
			}

			try{
				if(!mapaErrores.get(PROPUESTA_YA_CARGADA).isEmpty() ||
						!mapaErrores.get(ACTIVE_NOT_EXISTS).isEmpty() ||
						!mapaErrores.get(ACTIVE_NOT_INCLUDED_IN_PROPUESTA).isEmpty() ||
						!mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZE_NAN)).isEmpty() ||
						!mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED)).isEmpty() ||
						!mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZES_NOT_GREATER_EQUAL_ZERO)).isEmpty() ||
						!mapaErrores.get(ACTIVE_PAV_DATE_INIT_EXCEEDED).isEmpty() ||
						!mapaErrores.get(ACTIVE_PAR_DATE_INIT_EXCEEDED).isEmpty() ||
						!mapaErrores.get(ACTIVE_MIN_DATE_INIT_EXCEEDED).isEmpty() ||
						!mapaErrores.get(ACTIVE_VEV_DATE_INIT_FORMAT).isEmpty() ||
						!mapaErrores.get(ACTIVE_FSV_DATE_INIT_FORMAT).isEmpty() ) {
					dtoValidacionContenido.setFicheroTieneErrores(true);
					exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
					String nomFicheroErrores = exc.crearExcelErroresMejoradoByHojaAndFilaCabecera(mapaErrores,1,5);
					FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
					dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
				}
			} catch (Exception e) {
				logger.error(e.getMessage());
				e.printStackTrace();
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
	
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=EXCEL_FILA_INICIAL; i<numFilasHoja;i++){
				try {
					if(!particularValidator.existeActivo(exc.dameCeldaByHoja(i, EXCEL_COL_NUMACTIVO, 1)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
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
		Double valorEstimadoVenta = null;
		Double valorTransferencia = null;
		Double costeAdquisicion = null;
		Double valorFSVVenta = null;
		
		// Validacion que evalua si los precios son numeros correctos
		try {
			for(int i=EXCEL_FILA_INICIAL; i<numFilasHoja;i++){
				try{
					precioVNC = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VNC, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VNC, 1)) : null;
					precioVentaAprobado = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_PAV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_PAV, 1)) : null;
					precioRentaAprobado = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_PAR, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_PAR, 1)) : null;
					precioMinimoAuth = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_MIN, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_MIN, 1)) : null;
					valorEstimadoVenta = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VEV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VEV, 1)) : null;
					valorTransferencia = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VTF, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VTF, 1)) : null;
					costeAdquisicion = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_CAD, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_CAD, 1)) : null;
					valorFSVVenta = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_FSV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_FSV, 1)) : null;
					
					// Si alguno de los precios no es un numero
					if((!Checks.esNulo(precioVNC) && precioVNC.isNaN()) ||
						(!Checks.esNulo(precioVentaAprobado) && precioVentaAprobado.isNaN()) ||
						(!Checks.esNulo(precioRentaAprobado) && precioRentaAprobado.isNaN()) ||
						(!Checks.esNulo(precioMinimoAuth) && precioMinimoAuth.isNaN()) ||
						(!Checks.esNulo(valorEstimadoVenta) && valorEstimadoVenta.isNaN()) ||
						(!Checks.esNulo(valorTransferencia) && valorTransferencia.isNaN()) ||
						(!Checks.esNulo(costeAdquisicion) && costeAdquisicion.isNaN()) ||
						(!Checks.esNulo(valorFSVVenta) && valorFSVVenta.isNaN()) )
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getNANPrecioIncorrectoRows()");
				} catch (NumberFormatException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getNANPrecioIncorrectoRows()");
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> isPreciosMayorCeroRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioVNC = null;
		Double precioVentaAprobado = null;
		Double precioRentaAprobado = null;
		Double precioMinimoAuth = null;
		Double valorEstimadoVenta = null;
		Double valorTransferencia = null;
		Double costeAdquisicion = null;
		Double valorFSVVenta = null;
		
		// Validacion que evalua si los precios son mayores que cero
		try {
			for(int i=EXCEL_FILA_INICIAL; i<numFilasHoja;i++){
				try{
					precioVNC = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VNC, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VNC, 1)) : null;
					precioVentaAprobado = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_PAV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_PAV, 1)) : null;
					precioRentaAprobado = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_PAR, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_PAR, 1)) : null;
					precioMinimoAuth = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_MIN, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_MIN, 1)) : null;
					valorEstimadoVenta = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VEV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VEV, 1)) : null;
					valorTransferencia = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VTF, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VTF, 1)) : null;
					costeAdquisicion = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_CAD, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_CAD, 1)) : null;
					valorFSVVenta = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_FSV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_FSV, 1)) : null;
					
					if((!Checks.esNulo(precioVNC) && precioVNC.compareTo(0.0D) <= 0) ||
						(!Checks.esNulo(precioVentaAprobado) && precioVentaAprobado.compareTo(0.0D) <= 0) ||
						(!Checks.esNulo(precioRentaAprobado) && precioRentaAprobado.compareTo(0.0D) <= 0) ||
						(!Checks.esNulo(precioMinimoAuth) && precioMinimoAuth.compareTo(0.0D) <= 0) ||
						(!Checks.esNulo(valorEstimadoVenta) && valorEstimadoVenta.compareTo(0.0D) <= 0) ||
						(!Checks.esNulo(valorTransferencia) && valorTransferencia.compareTo(0.0D) <= 0) ||
						(!Checks.esNulo(costeAdquisicion) && costeAdquisicion.compareTo(0.0D) <= 0) ||
						(!Checks.esNulo(valorFSVVenta) && valorFSVVenta.compareTo(0.0D) <= 0) )
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getNANPrecioIncorrectoRows()");
				} catch (NumberFormatException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getNANPrecioIncorrectoRows()");
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> isPreciosMayorIgualCeroRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioVNC = null;
		Double precioVentaAprobado = null;
		Double precioRentaAprobado = null;
		Double precioMinimoAuth = null;
		Double valorEstimadoVenta = null;
		Double valorTransferencia = null;
		Double costeAdquisicion = null;
		Double valorFSVVenta = null;
		
		// Validacion que evalua si los precios son mayores que cero
		try {
			for(int i=EXCEL_FILA_INICIAL; i<numFilasHoja;i++){
				try{
					precioVNC = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VNC, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VNC, 1)) : null;
					precioVentaAprobado = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_PAV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_PAV, 1)) : null;
					precioRentaAprobado = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_PAR, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_PAR, 1)) : null;
					precioMinimoAuth = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_MIN, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_MIN, 1)) : null;
					valorEstimadoVenta = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VEV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VEV, 1)) : null;
					valorTransferencia = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VTF, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VTF, 1)) : null;
					costeAdquisicion = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_CAD, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_CAD, 1)) : null;
					valorFSVVenta = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_FSV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_FSV, 1)) : null;
					
					if((!Checks.esNulo(precioVNC) && precioVNC.compareTo(0.0D) < 0) ||
						(!Checks.esNulo(precioVentaAprobado) && precioVentaAprobado.compareTo(0.0D) < 0) ||
						(!Checks.esNulo(precioRentaAprobado) && precioRentaAprobado.compareTo(0.0D) < 0) ||
						(!Checks.esNulo(precioMinimoAuth) && precioMinimoAuth.compareTo(0.0D) < 0) ||
						(!Checks.esNulo(valorEstimadoVenta) && valorEstimadoVenta.compareTo(0.0D) < 0) ||
						(!Checks.esNulo(valorTransferencia) && valorTransferencia.compareTo(0.0D) < 0) ||
						(!Checks.esNulo(costeAdquisicion) && costeAdquisicion.compareTo(0.0D) < 0) ||
						(!Checks.esNulo(valorFSVVenta) && valorFSVVenta.compareTo(0.0D) < 0) )
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getNANPrecioIncorrectoRows()");
				} catch (NumberFormatException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getNANPrecioIncorrectoRows()");
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
			for(int i=EXCEL_FILA_INICIAL; i<numFilasHoja;i++){
				try{
					precioVentaAprobado = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_PAV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_PAV, 1)) : null;
					precioMinimoAuth = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_MIN, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_MIN, 1)) : null;
					
					// Limite: Precio Aprobado Venta >= Precio Minimo Auth
					if(!Checks.esNulo(precioMinimoAuth) && 
							!Checks.esNulo(precioVentaAprobado) &&
							(precioMinimoAuth > precioVentaAprobado)){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getLimitePreciosAprobadoMinimoIncorrectoRows()");
				} catch (NumberFormatException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getLimitePreciosAprobadoMinimoIncorrectoRows()");
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> getFechaMINIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioMIN = null;
		Date fechaFinMIN = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try {
			for(int i=EXCEL_FILA_INICIAL; i<numFilasHoja;i++){
				try{
					fechaInicioMIN = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_FINI_MIN, 1)) ? ft.parse(exc.dameCeldaByHoja(i, COL_FINI_MIN, 1)) : null;
					fechaFinMIN = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_FFIN_MIN, 1)) ? ft.parse(exc.dameCeldaByHoja(i, COL_FFIN_MIN, 1)) : null;
					
					//Fecha Inicio <= Fecha Fin
					if(!Checks.esNulo(fechaInicioMIN) && 
							!Checks.esNulo(fechaFinMIN) &&
							(fechaInicioMIN.after(fechaFinMIN))){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getFechaMINIncorrectaRows()");
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
			for(int i=EXCEL_FILA_INICIAL; i<numFilasHoja;i++){
				try{
					fechaInicioPAV = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_FINI_PAV, 1)) ? ft.parse(exc.dameCeldaByHoja(i, COL_FINI_PAV, 1)) : null;
					fechaFinPAV = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_FFIN_PAV, 1)) ? ft.parse(exc.dameCeldaByHoja(i, COL_FFIN_PAV, 1)) : null;
					
					//Fecha Inicio <= Fecha Fin
					if(!Checks.esNulo(fechaInicioPAV) && 
							!Checks.esNulo(fechaFinPAV) &&
							(fechaInicioPAV.after(fechaFinPAV))){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getFechaInicioAprobadoVentaIncorrectaRows()");
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
			for(int i=EXCEL_FILA_INICIAL; i<numFilasHoja;i++){
				try{
					fechaInicioPAR = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_FINI_PAR, 1)) ? ft.parse(exc.dameCeldaByHoja(i, COL_FINI_PAR, 1)) : null;
					fechaFinPAR = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_FFIN_PAR, 1)) ? ft.parse(exc.dameCeldaByHoja(i, COL_FFIN_PAR, 1)) : null;
					
					//Fecha Inicio <= Fecha Fin
					if(!Checks.esNulo(fechaInicioPAR) && 
							!Checks.esNulo(fechaFinPAR) &&
							(fechaInicioPAR.after(fechaFinPAR))){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getFechaInicioAprobadoRentaIncorrectaRows()");
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}	
		return listaFilas;
	}
	
	
	
	@SuppressWarnings("unused")
	private List<Integer> getFechaVEVIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaVEV = null;
		
		// Validacion que evalua si las fechas tienen un formato correcto
		try {
			for(int i=EXCEL_FILA_INICIAL; i<numFilasHoja;i++){
				try{
					fechaVEV = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_FECHA_VEV, 1)) ? ft.parse(exc.dameCeldaByHoja(i, COL_FECHA_VEV, 1)) : null;
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getFechaVEVIncorrectaRows()");
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}	
		return listaFilas;
	}
	
	@SuppressWarnings("unused")
	private List<Integer> getFechaFSVIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaFSV = null;
		
		// Validacion que evalua si las fechas tienen un formato correcto
		try {
			for(int i=EXCEL_FILA_INICIAL; i<numFilasHoja;i++){
				try{
					fechaFSV = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_FECHA_FSV, 1)) ? ft.parse(exc.dameCeldaByHoja(i, COL_FECHA_FSV, 1)) : null;
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getFechaFSVIncorrectaRows()");
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
			numPropuesta = Long.parseLong(exc.dameCeldaByHoja(1, 2, 1));
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
	
	private List<Integer> isActiveNotIncludesInPropuestaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=EXCEL_FILA_INICIAL; i<numFilasHoja;i++){
				String numActivo = exc.dameCeldaByHoja(i, EXCEL_COL_NUMACTIVO, 1);
				if(!Checks.esNulo(numActivo) && !particularValidator.existeActivoEnPropuesta(exc.dameCeldaByHoja(i, EXCEL_COL_NUMACTIVO, 1),exc.dameCeldaByHoja(1, 2, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

}
