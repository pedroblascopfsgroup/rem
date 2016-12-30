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
public class MSVActualizarPropuestaPreciosActivoEntidad02 extends MSVExcelValidatorAbstract {

	// Primera fila de la propuesta y columna con "num activo"
	public static final int EXCEL_FILA_INICIAL = 4;
	public static final int EXCEL_COL_NUMACTIVO = 1;
	
	// Posición de columna de los importes de valores/precios de la propuesta
	public static final int COL_VAL_VNC = 44; //Valor de Transferencia (Sareb)
	public static final int COL_VAL_PAV = 48; //Precio web referencia (Sanción Sareb)
	public static final int COL_VAL_PAR = 51; //Precio renta referencia (Sanción Sareb)
	public static final int COL_VAL_MIN = 45; //Precio minimo de referencia (Sanción Sareb)
	public static final int COL_VAL_VEV = 38; //Propuesta precio del colaborador
	public static final int COL_VAL_VRF = 43; //Valor de referencia (Sareb)
	public static final int COL_VAL_VTF = 44; //Valor de transferencia (Sareb)
	
	// Posicion de columna de las fechas INICIO/FIN de los precios
	public static final int COL_FINI_PAV = 49;
	public static final int COL_FFIN_PAV = 50;
	public static final int COL_FINI_PAR = 52;
	public static final int COL_FFIN_PAR = 53;
	public static final int COL_FINI_MIN = 46;
	public static final int COL_FFIN_MIN = 47;

	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_PRIZE_NAN = "msg.error.masivo.actualizar.propuesta.precios.activo.activoPrecioNaN";
	public static final String ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED = "msg.error.masivo.actualizar.propuesta.precios.activo.entidad02.activoPrecioVentaMinimoLimiteExcedido";
	public static final String ACTIVE_PAV_DATE_INIT_EXCEEDED = "La fecha de inicio del precio web referencia no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_MIN_DATE_INIT_EXCEEDED = "msg.error.masivo.actualizar.propuesta.precios.activo.entidad02.activoPMAFechaExcedida";
	public static final String ACTIVE_PAR_DATE_INIT_EXCEEDED = "La fecha de inicio del precio renta referencia no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";	

	public static final String PROPUESTA_YA_CARGADA = "Esta propuesta ya ha sido cargada anteriormente.";

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
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
			mapaErrores.put(PROPUESTA_YA_CARGADA, isPropuestaYaCargada(exc));
			//Si la propuesta ya ha sido cargada, no se realizan el resto de comprobaciones
			if(mapaErrores.get(PROPUESTA_YA_CARGADA).isEmpty()) {
				mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
				mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZE_NAN), getNANPrecioIncorrectoRows(exc));
				mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED), getLimitePreciosAprobadoMinimoIncorrectoRows(exc));
				mapaErrores.put(ACTIVE_PAV_DATE_INIT_EXCEEDED, getFechaInicioAprobadoVentaIncorrectaRows(exc));
				mapaErrores.put(ACTIVE_PAR_DATE_INIT_EXCEEDED, getFechaInicioAprobadoRentaIncorrectaRows(exc));
				mapaErrores.put(messageServices.getMessage(ACTIVE_MIN_DATE_INIT_EXCEEDED), getFechaMINIncorrectaRows(exc));
			}

			try{
				if(!mapaErrores.get(PROPUESTA_YA_CARGADA).isEmpty() ||
						!mapaErrores.get(ACTIVE_NOT_EXISTS).isEmpty() ||
						!mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZE_NAN)).isEmpty() ||
						!mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED)).isEmpty() ||
						!mapaErrores.get(ACTIVE_PAV_DATE_INIT_EXCEEDED).isEmpty() ||
						!mapaErrores.get(ACTIVE_PAR_DATE_INIT_EXCEEDED).isEmpty() ||
						!mapaErrores.get(messageServices.getMessage(ACTIVE_MIN_DATE_INIT_EXCEEDED)).isEmpty()) 
				{
					dtoValidacionContenido.setFicheroTieneErrores(true);
					exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
					String nomFicheroErrores = exc.crearExcelErroresMejoradoByHojaAndFilaCabecera(mapaErrores,0,3);
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
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, EXCEL_COL_NUMACTIVO)))
					listaFilas.add(i);
			}
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (IOException e) {
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
		
		// Validacion que evalua si los precios son numeros correctos
		try {
			for(int i=EXCEL_FILA_INICIAL; i<exc.getNumeroFilas();i++){
				try{
					precioVNC = !Checks.esNulo(exc.dameCelda(i, COL_VAL_VNC)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_VNC).replace(",", ".")) : null;
					precioVentaAprobado = !Checks.esNulo(exc.dameCelda(i, COL_VAL_PAV)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_PAV).replace(",", ".")) : null;
					precioRentaAprobado = !Checks.esNulo(exc.dameCelda(i, COL_VAL_PAR)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_PAR).replace(",", ".")) : null;
					precioMinimoAuth = !Checks.esNulo(exc.dameCelda(i, COL_VAL_MIN)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_MIN).replace(",", ".")) : null;
					valorEstimadoVenta = !Checks.esNulo(exc.dameCelda(i, COL_VAL_VEV)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_VEV).replace(",", ".")) : null;
					valorReferencia = !Checks.esNulo(exc.dameCelda(i, COL_VAL_VRF)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_VRF).replace(",", ".")) : null;
					valorTransferencia = !Checks.esNulo(exc.dameCelda(i, COL_VAL_VTF)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_VTF).replace(",", ".")) : null;
					
					// Si alguno de los precios no es un numero
					if((!Checks.esNulo(precioVNC) && precioVNC.isNaN()) ||
						(!Checks.esNulo(precioVentaAprobado) && precioVentaAprobado.isNaN()) ||
						(!Checks.esNulo(precioRentaAprobado) && precioRentaAprobado.isNaN()) ||
						(!Checks.esNulo(precioMinimoAuth) && precioMinimoAuth.isNaN()) ||
						(!Checks.esNulo(valorEstimadoVenta) && valorEstimadoVenta.isNaN()) ||
						(!Checks.esNulo(valorReferencia) && valorReferencia.isNaN()) ||
						(!Checks.esNulo(valorTransferencia) && valorTransferencia.isNaN()))
							listaFilas.add(i);	
				} catch (NumberFormatException e) {
					listaFilas.add(i);
					logger.error(e.getMessage()+" in method: getNANPrecioIncorrectoRows()");
					
				}
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
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
					precioVentaAprobado = !Checks.esNulo(exc.dameCelda(i, COL_VAL_PAV)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_PAV).replace(",", ".")) : null;
					precioMinimoAuth = !Checks.esNulo(exc.dameCelda(i, COL_VAL_MIN)) ? Double.parseDouble(exc.dameCelda(i, COL_VAL_MIN).replace(",", ".")) : null;
					
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
					logger.error(e.getMessage()+" in method: getLimitePreciosAprobadoMinimoIncorrectoRows()");
				}
			}
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IOException e) {
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
					logger.error(e.getMessage()+" in method: getFechaInicioAprobadoVentaIncorrectaRows()");
				}
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
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
					logger.error(e.getMessage()+" in method: getFechaInicioAprobadoRentaIncorrectaRows()");
				}
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}		
		return listaFilas;
	}

	private List<Integer> getFechaMINIncorrectaRows(MSVHojaExcel exc){
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
					logger.error(e.getMessage()+" in method: getFechaMINIncorrectaRows()");
				}
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
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
			
		} catch (NumberFormatException e) {
			logger.error(e.getMessage()+" in method: isPropuestaYaCargada()");
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}

}
