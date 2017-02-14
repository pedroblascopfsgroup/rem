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
public class MSVActualizarPropuestaPreciosActivoEntidad03 extends MSVExcelValidatorAbstract {

	// Primera fila de la propuesta y columna con "num activo"
	public static final int EXCEL_FILA_INICIAL = 8;
	public static final int EXCEL_COL_NUMACTIVO = 3;
	
	// Posición de columna de los importes de valores/precios de la propuesta
	public static final int COL_VAL_VNC = 16; //VNC
	public static final int COL_VAL_PAV = 18; //Precio aut. venta
	public static final int COL_VAL_PAR = 24; //Precio aut. renta
	public static final int COL_VAL_MIN = 21; //Precio minimo
	public static final int COL_VAL_VEV = 11; //Valor estimado venta
	public static final int COL_VAL_VRF = 15; //Valor referencia
	public static final int COL_VAL_VTF = 16; //Valor transferencia
	public static final int COL_VAL_FSV = 13; //FSV Venta
	
	// Posicion de columna de las fechas INICIO/FIN de los precios
	public static final int COL_FINI_PAV = 19;
	public static final int COL_FFIN_PAV = 20;
	public static final int COL_FINI_PAR = 25;
	public static final int COL_FFIN_PAR = 26;
	public static final int COL_FINI_MIN = 22;
	public static final int COL_FFIN_MIN = 23;

	// Posicion de columna de las fechas de valores
	public static final int COL_FECHA_VEV = 10;
	public static final int COL_FECHA_VRF = 14;
	public static final int COL_FECHA_FSV = 12;
	
	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_NOT_INCLUDED_IN_PROPUESTA = "El activo no pertece a la propuesta cargada";
	public static final String ACTIVE_PRIZE_NAN = "msg.error.masivo.actualizar.propuesta.precios.activo.activoPrecioNaN";
	public static final String ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED = "msg.error.masivo.actualizar.propuesta.precios.activo.entidad03.activoPrecioVentaMinimoLimiteExcedido";
	public static final String ACTIVE_PAV_DATE_INIT_EXCEEDED = "La fecha de inicio del precio propuesto no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_PMA_DATE_INIT_EXCEEDED = "msg.error.masivo.actualizar.propuesta.precios.activo.entidad03.activoPMAFechaExcedida";
	public static final String ACTIVE_PAR_DATE_INIT_EXCEEDED = "La fecha de inicio del precio de renta no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_FSV_DATE_INIT_FORMAT = "La fecha del valor FSV no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_VRF_DATE_INIT_FORMAT = "La fecha del valor de asesoramiento JLL no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_VEV_DATE_INIT_FORMAT = "La fecha del valor colaborador no tiene un formato correcto (DD/MM/AAAA)";
	
	public static final String PROPUESTA_YA_CARGADA = "Esta propuesta ya ha sido cargada anteriormente.";

	protected final Log logger = LogFactory.getLog(getClass());
	
//	private int numUltimaFila; // En esta excel, el último registro es un resumen, no se tiene en cuenta para validar
	
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
		
//		this.numUltimaFila = this.getNumFilasRealesHojaExcel(exc);
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
				Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
				mapaErrores.put(PROPUESTA_YA_CARGADA, isPropuestaYaCargada(exc));
				//Si la propuesta ya ha sido cargada, no se realizan el resto de comprobaciones
				if(mapaErrores.get(PROPUESTA_YA_CARGADA).isEmpty()) {
					mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
					mapaErrores.put(ACTIVE_NOT_INCLUDED_IN_PROPUESTA, isActiveNotIncludesInPropuestaRows(exc));
					mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZE_NAN), getNANPrecioIncorrectoRows(exc));
					mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED), getLimitePreciosAprobadoMinimoIncorrectoRows(exc));
					mapaErrores.put(ACTIVE_PAV_DATE_INIT_EXCEEDED, getFechaInicioAprobadoVentaIncorrectaRows(exc));
					mapaErrores.put(ACTIVE_PAR_DATE_INIT_EXCEEDED, getFechaInicioAprobadoRentaIncorrectaRows(exc));
					mapaErrores.put(messageServices.getMessage(ACTIVE_PMA_DATE_INIT_EXCEEDED), getFechaInicioMinimoAuthIncorrectaRows(exc));
					mapaErrores.put(ACTIVE_VEV_DATE_INIT_FORMAT, getFechaVEVIncorrectaRows(exc));
					mapaErrores.put(ACTIVE_VRF_DATE_INIT_FORMAT, getFechaVRFIncorrectaRows(exc));
					mapaErrores.put(ACTIVE_FSV_DATE_INIT_FORMAT, getFechaFSVIncorrectaRows(exc));
				}

				try{
					if(!mapaErrores.get(PROPUESTA_YA_CARGADA).isEmpty() ||
							!mapaErrores.get(ACTIVE_NOT_EXISTS).isEmpty() ||
							!mapaErrores.get(ACTIVE_NOT_INCLUDED_IN_PROPUESTA).isEmpty() ||
							!mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZE_NAN)).isEmpty() ||
							!mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED)).isEmpty() ||
							!mapaErrores.get(ACTIVE_PAV_DATE_INIT_EXCEEDED).isEmpty() ||
							!mapaErrores.get(ACTIVE_PAR_DATE_INIT_EXCEEDED).isEmpty() ||
							!mapaErrores.get(messageServices.getMessage(ACTIVE_PMA_DATE_INIT_EXCEEDED)).isEmpty() ||
							!mapaErrores.get(ACTIVE_VEV_DATE_INIT_FORMAT).isEmpty() ||
							!mapaErrores.get(ACTIVE_VRF_DATE_INIT_FORMAT).isEmpty() ||
							!mapaErrores.get(ACTIVE_FSV_DATE_INIT_FORMAT).isEmpty() ){
						dtoValidacionContenido.setFicheroTieneErrores(true);
						exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
						String nomFicheroErrores = exc.crearExcelErroresMejoradoByHojaAndFilaCabecera(mapaErrores,1,7);
						FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
						dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
					}
				} catch (Exception e) {
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
			for(int i=EXCEL_FILA_INICIAL; i<=exc.getNumeroFilasByHoja(1, EXCEL_FILA_INICIAL);i++){
				try {
					if(!particularValidator.existeActivo(exc.dameCeldaByHoja(i, EXCEL_COL_NUMACTIVO, 1)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			listaFilas.add(EXCEL_FILA_INICIAL);
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
		Double valorReferencia = null;
		Double valorTransferencia = null;
		Double valorFSVVenta = null;
		
		// Validacion que evalua si los precios son numeros correctos
		try {
			for(int i=EXCEL_FILA_INICIAL; i<=exc.getNumeroFilasByHoja(1, EXCEL_FILA_INICIAL);i++){
				try{
					precioVNC = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VNC, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VNC, 1)) : null;
					precioVentaAprobado = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_PAV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_PAV, 1)) : null;
					precioRentaAprobado = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_PAR, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_PAR, 1)) : null;
					precioMinimoAuth = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_MIN, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_MIN, 1)) : null;
					valorEstimadoVenta = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VEV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VEV, 1)) : null;
					valorReferencia = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VRF, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VRF, 1)) : null;
					valorTransferencia = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_VTF, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_VTF, 1)) : null;
					valorFSVVenta = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_FSV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_FSV, 1)) : null;
					
					// Si alguno de los precios no es un numero
					if((!Checks.esNulo(precioVNC) && precioVNC.isNaN()) ||
						(!Checks.esNulo(precioVentaAprobado) && precioVentaAprobado.isNaN()) ||
						(!Checks.esNulo(precioRentaAprobado) && precioRentaAprobado.isNaN()) ||
						(!Checks.esNulo(precioMinimoAuth) && precioMinimoAuth.isNaN()) ||
						(!Checks.esNulo(valorEstimadoVenta) && valorEstimadoVenta.isNaN()) ||
						(!Checks.esNulo(valorReferencia) && valorReferencia.isNaN()) ||
						(!Checks.esNulo(valorTransferencia) && valorTransferencia.isNaN()) ||
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

	private List<Integer> getLimitePreciosAprobadoMinimoIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioVentaAprobado = null;
		Double precioMinimoAuth = null;
		
		// Validacion que evalua si los precios estan dentro de los límites, comparandolos entre si
		try {
			for(int i=EXCEL_FILA_INICIAL; i<=exc.getNumeroFilasByHoja(1, EXCEL_FILA_INICIAL);i++){
				try{
					precioVentaAprobado = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_PAV, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_PAV, 1)) : null;
					precioMinimoAuth = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_VAL_MIN, 1)) ? Double.parseDouble(exc.dameCeldaByHoja(i, COL_VAL_MIN, 1)) : null;
					
					// Condiciones Limites: dto<=dto web<=aprobado
					
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
	
	private List<Integer> getFechaInicioAprobadoVentaIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioPAV = null;
		Date fechaFinPAV = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try {
			for(int i=EXCEL_FILA_INICIAL; i<=exc.getNumeroFilasByHoja(1, EXCEL_FILA_INICIAL);i++){
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
			for(int i=EXCEL_FILA_INICIAL; i<=exc.getNumeroFilasByHoja(1, EXCEL_FILA_INICIAL);i++){
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

	private List<Integer> getFechaInicioMinimoAuthIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioPMA = null;
		Date fechaFinPMA = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try {
			for(int i=EXCEL_FILA_INICIAL; i<=exc.getNumeroFilasByHoja(1, EXCEL_FILA_INICIAL);i++){
				try{
					fechaInicioPMA = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_FINI_MIN, 1)) ? ft.parse(exc.dameCeldaByHoja(i, COL_FINI_MIN, 1)) : null;
					fechaFinPMA = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_FFIN_MIN, 1)) ? ft.parse(exc.dameCeldaByHoja(i, COL_FFIN_MIN, 1)) : null;
					
					//Fecha Inicio <= Fecha Fin
					if(!Checks.esNulo(fechaInicioPMA) && 
							!Checks.esNulo(fechaFinPMA) &&
							(fechaInicioPMA.after(fechaFinPMA))){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getFechaInicioMinimoAuthIncorrectaRows()");
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
			for(int i=EXCEL_FILA_INICIAL; i<=exc.getNumeroFilasByHoja(1, EXCEL_FILA_INICIAL);i++){
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
	private List<Integer> getFechaVRFIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaVRF = null;
		
		// Validacion que evalua si las fechas tienen un formato correcto
		try {
			for(int i=EXCEL_FILA_INICIAL; i<=exc.getNumeroFilasByHoja(1, EXCEL_FILA_INICIAL);i++){
				try{
					fechaVRF = !Checks.esNulo(exc.dameCeldaByHoja(i, COL_FECHA_VRF, 1)) ? ft.parse(exc.dameCeldaByHoja(i, COL_FECHA_VRF, 1)) : null;
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getFechaVRFIncorrectaRows()");
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
			for(int i=EXCEL_FILA_INICIAL; i<=exc.getNumeroFilasByHoja(1, EXCEL_FILA_INICIAL);i++){
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
			logger.error(e.getMessage()+" in method: isPropuestaYaCargada()");
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
//	/**
//	 * Esta excel puede contener una fila RESUMEN en la última posición, y no se debe tener en cuenta 
//	 * para las validadciones.
//	 * @param exc
//	 * @return
//	 */
//	private Integer getNumFilasRealesHojaExcel(MSVHojaExcel exc) {
//		Integer ultimaFila = null;
//		
//		try {
//			ultimaFila = exc.getNumeroFilasByHoja(1) - 1;
//			if(exc.dameCeldaByHoja(ultimaFila, EXCEL_COL_NUMACTIVO, 1).isEmpty() && 
//					exc.dameCeldaByHoja(ultimaFila, 6, 1).contains("Activos:"))
//				ultimaFila--;
//		
//		} catch (IllegalArgumentException e) {
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		} catch (IOException e) {
//			logger.error(e.getMessage());
//			e.printStackTrace();
//		}
//		
//		return ultimaFila;
//	}
	
	private List<Integer> isActiveNotIncludesInPropuestaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilasByHoja(1,EXCEL_FILA_INICIAL);i++){
				if(!particularValidator.existeActivoEnPropuesta(exc.dameCeldaByHoja(i, EXCEL_COL_NUMACTIVO, 1),exc.dameCeldaByHoja(1, 2, 1)))
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
