package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
public class MSVActualizadorFechaIngresoChequeExcelValidator extends MSVExcelValidatorAbstract {
	
	private static final String EXPEDIENTE_COMERCIAL_NO_EXISTE = "msg.error.masivo.ecomercial.no.existe";
	private static final String EXPEDIENTE_COMERCIAL_TIPO_VENTA = "msg.error.masivo.ecomercial.tipo.venta";
	private static final String EXPEDIENTE_COMERCIAL_CARTERA_ERRONEA = "msg.error.masivo.ecomercial.cartera.erronea";
	private static final String EXPEDIENTE_COMERCIAL_VENTA_ESTADO_CORRECTO = "msg.error.masivo.ecomercial.estado.no.correcto";
	private static final String EXPEDIENTE_COMERCIAL_OFERTA_NO_TRAMITADA = "msg.error.masivo.ecomercial.oferta.no.tramitada";
	private static final String EXPEDIENTE_COMERCIAL_CARTERA_ERRONEA_BANKIA = "msg.error.masivo.ecomercial.cartera.erronea.bankia";
	private static final String EXPEDIENTE_COMERCIAL_CARTERA_ERRONEA_LIBERBANK = "msg.error.masivo.ecomercial.cartera.erronea.liberbank";
	
	private static final String FECHA_INGRESO_CHEQUE = "msg.error.masivo.fecha.inicio.fin";
	private static final String FECHA_INGRESO_CHEQUE_MENOR_FECHA_ALTA_OFERTA = "msg.error.masivo.ecomercial.fecha.ingreso.menor.fecha.alta.oferta";
	private static final String FECHA_INGRESO_CHEQUE_MENOR_FECHA_SANCION = "msg.error.masivo.ecomercial.fecha.ingreso.menor.fecha.sancion";
	private static final String FECHA_INGRESO_CHEQUE_MENOR_FECHA_ACEPTACION = "msg.error.masivo.ecomercial.fecha.ingreso.menor.fecha.aceptacion";
	private static final String FECHA_INGRESO_CHEQUE_MENOR_FECHA_RESERVA = "msg.error.masivo.ecomercial.fecha.ingreso.menor.fecha.reserva";
	private static final String FECHA_INGRESO_CHEQUE_MENOR_FECHA_VENTA = "msg.error.masivo.ecomercial.fecha.ingreso.menor.fecha.venta";
	
	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		
		static final int COL_NUM_EXPDTE_COMERCIAL = 0;
		static final int COL_NUM_FECHA_INGRESO_CHEQUE = 1;		
	}

	
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
			mapaErrores.put(messageServices.getMessage(EXPEDIENTE_COMERCIAL_NO_EXISTE), isExpedienteNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(EXPEDIENTE_COMERCIAL_TIPO_VENTA), isExpedienteNotTipoVenta(exc));
			mapaErrores.put(messageServices.getMessage(EXPEDIENTE_COMERCIAL_VENTA_ESTADO_CORRECTO), isExpedienteVentaEstadoOK(exc));
			mapaErrores.put(messageServices.getMessage(EXPEDIENTE_COMERCIAL_OFERTA_NO_TRAMITADA), isExpedienteOfertaNOTramitada(exc));
			mapaErrores.put(messageServices.getMessage(EXPEDIENTE_COMERCIAL_CARTERA_ERRONEA_BANKIA), isExpedienteCarteraBankia(exc));
			mapaErrores.put(messageServices.getMessage(EXPEDIENTE_COMERCIAL_CARTERA_ERRONEA_LIBERBANK), isExpedienteCarteraLiberbank(exc));
			
			mapaErrores.put(messageServices.getMessage(FECHA_INGRESO_CHEQUE), isColumnNotDateByRows(exc, COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE));
			mapaErrores.put(messageServices.getMessage(FECHA_INGRESO_CHEQUE_MENOR_FECHA_ALTA_OFERTA), isFechaAltaOfertaMenorFechaIngreso(exc, COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE));
			mapaErrores.put(messageServices.getMessage(FECHA_INGRESO_CHEQUE_MENOR_FECHA_SANCION), isFechaSancionMenorFechaIngreso(exc, COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE));
			mapaErrores.put(messageServices.getMessage(FECHA_INGRESO_CHEQUE_MENOR_FECHA_ACEPTACION), isFechaAltaMenorFechaIngreso(exc, COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE));
			mapaErrores.put(messageServices.getMessage(FECHA_INGRESO_CHEQUE_MENOR_FECHA_RESERVA), isFechaFirmaMenorFechaIngreso(exc, COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE));
			mapaErrores.put(messageServices.getMessage(FECHA_INGRESO_CHEQUE_MENOR_FECHA_VENTA), isFechaVentaMenorFechaIngreso(exc, COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE));
			
			
			if (!mapaErrores.get(messageServices.getMessage(EXPEDIENTE_COMERCIAL_NO_EXISTE)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(EXPEDIENTE_COMERCIAL_TIPO_VENTA)).isEmpty() || !mapaErrores.get(messageServices.getMessage(EXPEDIENTE_COMERCIAL_CARTERA_ERRONEA)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(EXPEDIENTE_COMERCIAL_VENTA_ESTADO_CORRECTO)).isEmpty() || !mapaErrores.get(messageServices.getMessage(EXPEDIENTE_COMERCIAL_OFERTA_NO_TRAMITADA)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(EXPEDIENTE_COMERCIAL_CARTERA_ERRONEA_BANKIA)).isEmpty() || !mapaErrores.get(messageServices.getMessage(EXPEDIENTE_COMERCIAL_CARTERA_ERRONEA_LIBERBANK)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(FECHA_INGRESO_CHEQUE)).isEmpty() || !mapaErrores.get(messageServices.getMessage(FECHA_INGRESO_CHEQUE_MENOR_FECHA_ALTA_OFERTA)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(FECHA_INGRESO_CHEQUE_MENOR_FECHA_SANCION)).isEmpty() || !mapaErrores.get(messageServices.getMessage(FECHA_INGRESO_CHEQUE_MENOR_FECHA_ACEPTACION)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(FECHA_INGRESO_CHEQUE_MENOR_FECHA_RESERVA)).isEmpty() || !mapaErrores.get(messageServices.getMessage(FECHA_INGRESO_CHEQUE_MENOR_FECHA_VENTA)).isEmpty()){
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
	/**
	 * Funcion para comprobar si existe el Expediente Comercial 		
	 * @param exc
	 * @return
	 */
	private List<Integer> isExpedienteNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)) && !particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
			} catch (IllegalArgumentException e) {
				listaFilas.add(0);
				e.printStackTrace();
			} catch (IOException e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		return listaFilas;
	}
	/**
	 * Funcion para comprobar si el Expediente Comercial es de tipo Venta
	 * @param exc
	 * @return
	 */ 
	private List<Integer> isExpedienteNotTipoVenta(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
						if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
							if(particularValidator.validadorTipoOferta(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)))) {
								listaFilas.add(i);							
							}
						}						
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
			} catch (IllegalArgumentException e) {
				listaFilas.add(0);
				e.printStackTrace();
			} catch (IOException e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		return listaFilas;
	}
	/**
	 * Funcion para comprobar la cartera a la que pertenece el Expediente Comercial
	 * @param exc
	 * return
	 */
	private List<Integer> isExpedienteCarteraBankia(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
						if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
							if(particularValidator.validadorCarteraBankia(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)))) {
								listaFilas.add(i);							
							}
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
			} catch (IllegalArgumentException e) {
				listaFilas.add(0);
				e.printStackTrace();
			} catch (IOException e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		return listaFilas;
	}
	private List<Integer> isExpedienteCarteraLiberbank(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
						if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
							if(particularValidator.validadorCarteraLiberbank(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)))) {
								listaFilas.add(i);							
							}
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
			} catch (IllegalArgumentException e) {
				listaFilas.add(0);
				e.printStackTrace();
			} catch (IOException e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		return listaFilas;
	}
	/**
	 * Funcion para comprobar si el Expediente Comercial se encuentra entre el listado de estados correctos
	 * @param exc
	 * return
	 */
	private List<Integer> isExpedienteVentaEstadoOK(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
						if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
							if(particularValidator.validadorEstadoExpedienteSolicitado(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)))) {
								listaFilas.add(i);							
							}
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
			} catch (IllegalArgumentException e) {
				listaFilas.add(0);
				e.printStackTrace();
			} catch (IOException e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		return listaFilas;
	}
	/**
	 * Funcion para comprobar si el estado de la oferta del Expediente Comercial esta Tramitada
	 * @param exc
	 * return
	 */
	private List<Integer> isExpedienteOfertaNOTramitada(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
						if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
							if(particularValidator.validadorEstadoOfertaTramitada(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)))) {
								listaFilas.add(i);							
							}
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
			} catch (IllegalArgumentException e) {
				listaFilas.add(0);
				e.printStackTrace();
			} catch (IOException e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		return listaFilas;
	}
	/**
	 * Funcion para comprobar el formato de la Fecha
	 * @param exc
	 * @param columnNumber
	 * @return
	 */
	private List<Integer> isColumnNotDateByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yy");
		String valorDate = null;

		for (int i = COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE; i < numFilasHoja; i++) {
			try {
				valorDate = exc.dameCelda(i, columnNumber);

				// Si el valor Date no se puede obtener adecuadamente se lanza
				// error para esa línea.
				if (!Checks.esNulo(valorDate)) {
					ft.parse(valorDate);
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}
		return listaFilas;
	}
	/**
	 * Funcion para comprobar si la Fecha de Ingreso es mayor que la Fecha de Alta de la Oferta 
	 * @param exc
	 * @param columnNumber
	 * @return
	 */
	private List<Integer> isFechaAltaOfertaMenorFechaIngreso(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yy");
		String valorDate = null;

		for (int i = COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE; i < numFilasHoja; i++) {
			try {
				valorDate = exc.dameCelda(i, columnNumber);
				if(particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
						if(particularValidator.validadorFechaMayorIgualFechaAltaOferta(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)), valorDate)) {
							listaFilas.add(i);
						}
					}
				}
				// Si el valor Date no se puede obtener adecuadamente se lanza
				// error para esa línea.
				else if (!Checks.esNulo(valorDate)) {
					ft.parse(valorDate);
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}
		return listaFilas;
	}
	/**
	 * Funcion para comprobar si la Fecha de Ingreso es mayor que la Fecha de Sancion 
	 * @param exc
	 * @param columnNumber
	 * @return
	 */
	private List<Integer> isFechaSancionMenorFechaIngreso(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yy");
		String valorDate = null;

		for (int i = COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE; i < numFilasHoja; i++) {
			try {
				valorDate = exc.dameCelda(i, columnNumber);
				if(particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
						if(particularValidator.validadorFechaMayorIgualFechaSancion(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)), valorDate)) {
							listaFilas.add(i);
						}
					}
				}
				// Si el valor Date no se puede obtener adecuadamente se lanza
				// error para esa línea.
				else if (!Checks.esNulo(valorDate)) {
					ft.parse(valorDate);
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}
		return listaFilas;
	}
	/**
	 * Funcion para comprobar si la Fecha de Ingreso es mayor que la Fecha de Aceptacion(Alta) 
	 * @param exc
	 * @param columnNumber
	 * @return
	 */
	private List<Integer> isFechaAltaMenorFechaIngreso(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yy");
		String valorDate = null;

		for (int i = COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE; i < numFilasHoja; i++) {
			try {
				valorDate = exc.dameCelda(i, columnNumber);
				if(particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
						if(particularValidator.validadorFechaMayorIgualFechaAceptacion(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)), valorDate)) {
							listaFilas.add(i);
						}
					}
				}
				// Si el valor Date no se puede obtener adecuadamente se lanza
				// error para esa línea.
				else if (!Checks.esNulo(valorDate)) {
					ft.parse(valorDate);
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}
		return listaFilas;
	}
	/**
	 * Funcion para comprobar si la Fecha de Ingreso es mayor que la Fecha de Reserva(Firma) 
	 * @param exc
	 * @param columnNumber
	 * @return
	 */
	private List<Integer> isFechaFirmaMenorFechaIngreso(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yy");
		String valorDate = null;

		for (int i = COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE; i < numFilasHoja; i++) {
			try {
				valorDate = exc.dameCelda(i, columnNumber);
				if(particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
						if(particularValidator.validadorFechaMayorIgualFechaReserva(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)), valorDate)) {
							listaFilas.add(i);
						}
					}
				}
				// Si el valor Date no se puede obtener adecuadamente se lanza
				// error para esa línea.
				else if (!Checks.esNulo(valorDate)) {
					ft.parse(valorDate);
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}
		return listaFilas;
	}
	/**
	 * Funcion para comprobar si la Fecha de Ingreso es mayor que la Fecha de Venta 
	 * @param exc
	 * @param columnNumber
	 * @return
	 */
	private List<Integer> isFechaVentaMenorFechaIngreso(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yy");
		String valorDate = null;

		for (int i = COL_NUM.COL_NUM_FECHA_INGRESO_CHEQUE; i < numFilasHoja; i++) {
			try {
				valorDate = exc.dameCelda(i, columnNumber);
				if(particularValidator.existeExpedienteComercial(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL))) {
						if(particularValidator.validadorFechaMayorIgualFechaVenta(Long.parseLong(exc.dameCelda(i, COL_NUM.COL_NUM_EXPDTE_COMERCIAL)), valorDate)) {
							listaFilas.add(i);
						}
					}
				}
				// Si el valor Date no se puede obtener adecuadamente se lanza
				// error para esa línea.
				else if (!Checks.esNulo(valorDate)) {
					ft.parse(valorDate);
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(),e);
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage(),e);
				listaFilas.add(i);
			}
		}
		return listaFilas;
	}	
	
	private File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}
}

