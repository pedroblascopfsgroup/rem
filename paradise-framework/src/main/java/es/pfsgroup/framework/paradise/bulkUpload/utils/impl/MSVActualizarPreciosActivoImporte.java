package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.math.BigDecimal;
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
public class MSVActualizarPreciosActivoImporte extends MSVExcelValidatorAbstract {

	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_PRIZE_NAN = "Uno de los importes indicados no es un valor numérico correcto";
	public static final String ACTIVE_PRIZES_DESCUENTOS_LIMIT_EXCEEDED = "El precio de descuento aprobado no puede ser mayor al precio de descuento publicado (P.Descuento <= P.Descuento Pub.) o uno de estos precios no tiene un formato correcto";
	public static final String ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED = "El precio aprobado de venta no puede ser menor al precio mínimo autorizado (P.Minimo <= P.Aprobado Venta) o uno de estos precios no tiene un formato correcto";
	//public static final String ACTIVE_PRIZES_VENTA_DESCUENTOWEB_LIMIT_EXCEEDED = "El precio de descuento publicado no puede ser mayor al precio aprobado de venta (P.Descuento Pub. <= P.Aprobado Venta) o uno de estos precios no tiene un formato correcto";
	public static final String ACTIVE_PRIZES_NOT_GREATER_ZERO = "msg.error.masivo.comunes.importe.no.mayor.cero";
	public static final String ACTIVE_PAV_DATE_INIT_EXCEEDED = "La fecha de inicio del precio aprobado de venta no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_PMA_DATE_INIT_EXCEEDED = "La fecha de inicio del precio mínimo autorizado no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_PAR_DATE_INIT_EXCEEDED = "La fecha de inicio del precio aprobado de renta no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_PDA_DATE_INIT_EXCEEDED = "La fecha de inicio del precio de descuento aprobado no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_PDP_DATE_INIT_EXCEEDED = "La fecha de inicio del precio de descuento publicado no puede ser posterior a la fecha de fin (F.inicio <= F.Fin) o una de estas fechas no tiene un formato correcto (DD/MM/AAAA)";
	public static final String ACTIVE_PAV_END_DATE_LESS_PMA_END_DATE = "La fecha fin del precio aprobado de venta ha de ser menor o igual a la fecha fin del precio mínimo autorizado";
	public static final String ACTIVE_PAV_BEGIN_DATE_GREATER_PMA_BEGIN_DATE = "La fecha inicio del precio aprobado de venta ha de ser mayor o igual a la fecha inicio del precio mínimo autorizado";
	public static final String ACTIVE_PMA_BEGIN_DATE_TODAY = "La fecha de inicio del precio mínimo debe ser menor o igual a hoy";
	public static final String ACTIVE_PMA_END_DATE_TODAY = "La fecha de fin del precio mínimo debe ser mayor o igual a hoy";
	public static final String ACTIVE_PDA_BEGIN_DATE_NOT_EXISTS = "La fecha de inicio del precio de descuento aprobado no puede dejarse en blanco";
	public static final String ACTIVE_PDA_END_DATE_NOT_EXISTS = "La fecha de fin del precio de descuento aprobado no puede dejarse en blanco";
	public static final String ACTIVE_PDP_BEGIN_DATE_NOT_EXISTS = "La fecha de inicio del precio de descuento publicado no puede dejarse en blanco";
	public static final String ACTIVE_PDP_END_DATE_NOT_EXISTS = "La fecha de fin del precio de descuento publicado no puede dejarse en blanco";
	public static final String ACTIVE_NOT_ACTUALIZABLE = "El estado del activo no puede actualizarse al indicado.";
	public static final String ACTIVE_PRECIOS_BLOQUEO = "El activo tiene habilitado el bloqueo de precios. No se pueden actualizar precios";
	public static final String ACTIVE_OFERTA_APROBADA = "El activo tiene ofertas aprobadas. No se pueden actualizar precios";
	//public static final String ACTIVE_PDA_END_DATE_GREATER_PMA_END_DATE = "La fecha de fin del precio de descuento aprobado no puede ser posterior a la fecha fin del precio mínimo";
	//public static final String ACTIVE_PDA_BEGIN_DATE_LESS_PMA_BEGIN_DATE = "La fecha de inicio del precio de descuento aprobado no puede ser anterior a la fecha inicio del precio mínimo";
	public static final String ACTIVE_PDW_BEGIN_DATE_LESS_PDA_BEGIN_DATE = "La fecha de inicio del precio descuento publicado no puede ser anterior a la fecha inicio del precio descuento aprovado";
	//public static final String ACTIVE_PDW_BEGIN_DATE_LESS_PAV_BEGIN_DATE = "La fecha de inicio del precio descuento publicado no puede ser anterior a la fecha inicio del precio aprobado venta";
	public static final String ACTIVE_PDW_END_DATE_MORE_PDA_END_DATE = "La fecha de fin del precio descuento publicado no puede ser posterior a la fecha fin del precio descuento aprobado";
	//public static final String ACTIVE_PDW_END_DATE_MORE_PAV_END_DATE = "La fecha de fin del precio descuento publicado no puede ser posterior a la fecha fin del precio aprobado venta";
	public static final String ACTIVE_COMPARE_PRICES_EXCEL_TO_DDBB = "Los precios especificados no cumplen las reglas al ser introducidos junto con los actuales precios";
	public static final String ACTIVE_COMPARE_DATES_EXCEL_TO_DDBB = "Las fechas especificadas no cumplen las reglas al ser introducidas junto con las actuales fechas";
	public static final String ACTIVE_APROBACION_DATES_REQUIRED = "Es obligatorio rellenar la fecha de aprobación de venta para informar el precio de venta de un activo de BBVA";

	//Indicar las posiciones de las columnas en el excel CARGA_DIRECTA_PRECIOS_ACTIVOS.xls
	public static final Integer COLUMNA_ACTIVO 						= 0;
	public static final Integer COLUMNA_P_APROBADO_VENTA 			= 1; 		//precioVentaAprobado
	public static final Integer COLUMNA_F_APROB_P_APROBADO_VENTA 	= 2;
	public static final Integer COLUMNA_F_INI_PRECIO_APROB_VENTA 	= 3; 		//fechaInicioPAV
	public static final Integer COLUMNA_F_FIN_PRECIO_APROB_VENTA 	= 4; 		//fechaFinPAV
	public static final Integer COLUMNA_P_MIN_AUTORIZADO 			= 5; 		//precioMinimoAuth
	public static final Integer COLUMNA_F_APROB_P_MIN_AUTORIZADO 	= 6;
	public static final Integer COLUMNA_F_INI_P_MIN_AUTORIZADO 		= 7; 		//fechaInicioPMA
	public static final Integer COLUMNA_F_FIN_P_MIN_AUTORIZADO 		= 8; 		//fechaFinPMA
	public static final Integer COLUMNA_P_APROB_RENTA 				= 9; 		//precioRentaAprobado
	public static final Integer COLUMNA_F_APROB_P_APROBADO_RENTA 	= 10;
	public static final Integer COLUMNA_F_INI_P_APROBADO_RENTA 		= 11; 		//fechaInicioPAR
	public static final Integer COLUMNA_F_FIN_P_APROBADO_RENTA 		= 12; 		//fechaFinPAR
	public static final Integer COLUMNA_P_DESCUENTO_APROBADO 		= 13; 		//precioDescuentoAprobado
	public static final Integer COLUMNA_F_APROB_P_DESCUENTO_APROB 	= 14;
	public static final Integer COLUMNA_F_INI_P_DESCUENTO_APROB 	= 15; 		//fechaInicioPDA
	public static final Integer COLUMNA_F_FIN_P_DESCUENTO_APROB 	= 16; 		//fechaFinPDA
	public static final Integer COLUMNA_P_DESCUENTO_PUBLICADO 		= 17; 		//precioDescuentoPublicado
	public static final Integer COLUMNA_F_APROB_P_DESCUENTO_PUB 	= 18;
	public static final Integer COLUMNA_F_INI_P_DESCUENTO_PUB 		= 19; 		//fechaInicioPDP
	public static final Integer COLUMNA_F_FIN_P_DESCUENTO_PUB 		= 20; 		//fechaFinPDW
	
	public static final String CARTERA_BBVA = "BBVA";

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
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
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion()));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		
		// Validaciones especificas no contenidas en el fichero Excel de validacion.
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0,operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
		// Comprobaciones para contrastar los datos contenidos en el propio excel.
			mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
			mapaErrores.put(ACTIVE_PRIZE_NAN, getNANPrecioIncorrectoRows(exc));
			mapaErrores.put(ACTIVE_PRIZES_DESCUENTOS_LIMIT_EXCEEDED, getLimitePreciosDescAprobDescWebIncorrectoRows(exc));
			mapaErrores.put(ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED, getLimitePreciosAprobadoMinimoIncorrectoRows(exc));
			//mapaErrores.put(ACTIVE_PRIZES_VENTA_DESCUENTOWEB_LIMIT_EXCEEDED, getLimitePreciosAprobadoDescWebIncorrectoRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZES_NOT_GREATER_ZERO), isPreciosMayorCeroRows(exc));
			mapaErrores.put(ACTIVE_PAV_DATE_INIT_EXCEEDED, getFechaInicioAprobadoVentaIncorrectaRows(exc));
			mapaErrores.put(ACTIVE_PAR_DATE_INIT_EXCEEDED, getFechaInicioAprobadoRentaIncorrectaRows(exc));
			mapaErrores.put(ACTIVE_PMA_DATE_INIT_EXCEEDED, getFechaInicioMinimoAuthIncorrectaRows(exc));
			mapaErrores.put(ACTIVE_PMA_BEGIN_DATE_TODAY, getFechaInicioMinimoPosteriorHoy(exc));
			
			//HREOS-2933
			//mapaErrores.put(ACTIVE_PMA_END_DATE_TODAY, getFechaFinMinimoInferiorHoy(exc));
			mapaErrores.put(ACTIVE_PDA_DATE_INIT_EXCEEDED, getFechaInicioDescuentoAprobIncorrectaRows(exc));
			mapaErrores.put(ACTIVE_PDP_DATE_INIT_EXCEEDED, getFechaInicioDescuentoPubIncorrectaRows(exc));
			mapaErrores.put(ACTIVE_PDA_BEGIN_DATE_NOT_EXISTS, getFechaInicioDescuentoAprobNoEstablecida(exc));
			mapaErrores.put(ACTIVE_PDP_BEGIN_DATE_NOT_EXISTS, getFechaInicioDescuentoPubNoEstablecida(exc));
			mapaErrores.put(ACTIVE_PDA_END_DATE_NOT_EXISTS, getFechaFinDescuentoAprobNoEstablecida(exc));
			mapaErrores.put(ACTIVE_PDP_END_DATE_NOT_EXISTS, getFechaFinDescuentoPubNoEstablecida(exc));
			mapaErrores.put(ACTIVE_PAV_END_DATE_LESS_PMA_END_DATE, getFechaFinAprovadoVentaMenorFechaFinMinimoAutorizado(exc));
			mapaErrores.put(ACTIVE_PAV_BEGIN_DATE_GREATER_PMA_BEGIN_DATE, getFechaInicioAprovadoVentaMayorFechaInicioMinimoAutorizado(exc));
			//mapaErrores.put(ACTIVE_PDA_END_DATE_GREATER_PMA_END_DATE, getFechaFinDescuentoAprobadoMayorFechaFinMinimoAutorizado(exc));
			//mapaErrores.put(ACTIVE_PDA_BEGIN_DATE_LESS_PMA_BEGIN_DATE, getFechaInicioDescuentoAprobadoMenorFechaInicioMinimoAutorizado(exc));
			mapaErrores.put(ACTIVE_PDW_BEGIN_DATE_LESS_PDA_BEGIN_DATE, getFechaInicioDescuentoWebMenorFechaInicioDescuentoAprobado(exc));
			//mapaErrores.put(ACTIVE_PDW_BEGIN_DATE_LESS_PAV_BEGIN_DATE, getFechaInicioDescuentoWebMenorFechaInicioAprovadoVenta(exc));
			mapaErrores.put(ACTIVE_PDW_END_DATE_MORE_PDA_END_DATE, getFechaFinDescuentoWebMayorFechaFinDescuentoAprobado(exc));
			//mapaErrores.put(ACTIVE_PDW_END_DATE_MORE_PAV_END_DATE, getFechaFinDescuentoWebMayorFechaFinAprovadoVenta(exc));
		// Comprobaciones para contrastar datos del excel con los datos actuales en la DB.
			mapaErrores.put(ACTIVE_COMPARE_PRICES_EXCEL_TO_DDBB, getComparacionDePreciosExcelDDBB(exc));
			mapaErrores.put(ACTIVE_COMPARE_DATES_EXCEL_TO_DDBB, getComparacionDeFechasExcelDDBB(exc));
			mapaErrores.put(ACTIVE_APROBACION_DATES_REQUIRED, getFechasAprobacionRellenadas(exc));

			if (!mapaErrores.get(ACTIVE_NOT_EXISTS).isEmpty() || !mapaErrores.get(ACTIVE_PRIZE_NAN).isEmpty()
					|| !mapaErrores.get(ACTIVE_PRIZES_DESCUENTOS_LIMIT_EXCEEDED).isEmpty()
					|| !mapaErrores.get(ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED).isEmpty() ||
					// !mapaErrores.get(ACTIVE_PRIZES_VENTA_DESCUENTOWEB_LIMIT_EXCEEDED).isEmpty()
					// ||
					!mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZES_NOT_GREATER_ZERO)).isEmpty()
					|| !mapaErrores.get(ACTIVE_PAV_DATE_INIT_EXCEEDED).isEmpty()
					|| !mapaErrores.get(ACTIVE_PMA_DATE_INIT_EXCEEDED).isEmpty()
					|| !mapaErrores.get(ACTIVE_PAR_DATE_INIT_EXCEEDED).isEmpty()
					|| !mapaErrores.get(ACTIVE_PDA_DATE_INIT_EXCEEDED).isEmpty()
					|| !mapaErrores.get(ACTIVE_PDP_DATE_INIT_EXCEEDED).isEmpty()
					|| !mapaErrores.get(ACTIVE_PDA_BEGIN_DATE_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(ACTIVE_PDP_BEGIN_DATE_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(ACTIVE_PDA_END_DATE_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(ACTIVE_PDP_END_DATE_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(ACTIVE_PAV_END_DATE_LESS_PMA_END_DATE).isEmpty()
					|| !mapaErrores.get(ACTIVE_PAV_BEGIN_DATE_GREATER_PMA_BEGIN_DATE).isEmpty()
					//|| !mapaErrores.get(ACTIVE_PDA_END_DATE_GREATER_PMA_END_DATE).isEmpty()
					//|| !mapaErrores.get(ACTIVE_PDA_BEGIN_DATE_LESS_PMA_BEGIN_DATE).isEmpty()
					|| !mapaErrores.get(ACTIVE_PDW_BEGIN_DATE_LESS_PDA_BEGIN_DATE).isEmpty()
					//|| !mapaErrores.get(ACTIVE_PDW_BEGIN_DATE_LESS_PAV_BEGIN_DATE).isEmpty()
					|| !mapaErrores.get(ACTIVE_PDW_END_DATE_MORE_PDA_END_DATE).isEmpty()
					//|| !mapaErrores.get(ACTIVE_PDW_END_DATE_MORE_PAV_END_DATE).isEmpty()
					|| !mapaErrores.get(ACTIVE_COMPARE_PRICES_EXCEL_TO_DDBB).isEmpty()
					|| !mapaErrores.get(ACTIVE_COMPARE_DATES_EXCEL_TO_DDBB).isEmpty()
					|| !mapaErrores.get(ACTIVE_APROBACION_DATES_REQUIRED).isEmpty()
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

	private List<Integer> getComparacionDeFechasExcelDDBB(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaAprobPAV = null;// Actualmente no tiene reglas que la utilicen.
		Date fechaInicioPAV = null;
		Date fechaFinPAV = null;
		Date fechaAprobPMA = null;// Actualmente no tiene reglas que la utilicen.
		Date fechaInicioPMA = null;
		Date fechaFinPMA = null;
		Date fechaAprobPAR = null;// Actualmente no tiene reglas que la utilicen.
		Date fechaInicioPAR = null; // Actualmente no tiene reglas que la utilicen.
		Date fechaFinPAR = null; // Actualmente no tiene reglas que la utilicen.
		Date fechaAprobPDA = null;// Actualmente no tiene reglas que la utilicen.
		Date fechaInicioPDA = null;
		Date fechaFinPDA = null;
		Date fechaAprobPDP = null;// Actualmente no tiene reglas que la utilicen.
		Date fechaInicioPDP = null;
		Date fechaFinPDP = null;

		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try{
					// Obtener las fechas actuales del activo.
					List<Date> fechas = particularValidator.getFechasImportesActualesActivo(exc.dameCelda(i, COLUMNA_ACTIVO));
					fechaAprobPAV = fechas.get(0);
					fechaInicioPAV = fechas.get(1);
					fechaFinPAV = fechas.get(2);
					
					fechaAprobPMA = fechas.get(3);
					fechaInicioPMA = fechas.get(4);
					fechaFinPMA = fechas.get(5);
					
					fechaAprobPAR = fechas.get(6);
					fechaInicioPAR = fechas.get(7);
					fechaFinPAR = fechas.get(8);
					
					fechaAprobPDA = fechas.get(9);
					fechaInicioPDA = fechas.get(10);
					fechaFinPDA = fechas.get(11);
					
					fechaAprobPDP = fechas.get(12);
					fechaInicioPDP = fechas.get(13);
					fechaFinPDP = fechas.get(14);
	
					//Obtener fechas de importes de la excel y machacar las actuales fechas del activo si est�n definidas.
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_APROB_P_APROBADO_VENTA))) {
						fechaAprobPAV = ft.parse(exc.dameCelda(i, COLUMNA_F_APROB_P_APROBADO_VENTA));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_PRECIO_APROB_VENTA))) {
						fechaInicioPAV = ft.parse(exc.dameCelda(i, COLUMNA_F_INI_PRECIO_APROB_VENTA));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_PRECIO_APROB_VENTA))) {
						fechaFinPAV = ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_PRECIO_APROB_VENTA));
					}
					
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_APROB_P_MIN_AUTORIZADO))) {
						fechaAprobPMA = ft.parse(exc.dameCelda(i, COLUMNA_F_APROB_P_MIN_AUTORIZADO));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_MIN_AUTORIZADO))) {
						fechaInicioPMA = ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_MIN_AUTORIZADO));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_MIN_AUTORIZADO))) {
						fechaFinPMA = ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_MIN_AUTORIZADO));
					}
					
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_APROB_P_APROBADO_RENTA))) {
						fechaAprobPAR = ft.parse(exc.dameCelda(i, COLUMNA_F_APROB_P_APROBADO_RENTA));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_APROBADO_RENTA))) {
						fechaInicioPAR = ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_APROBADO_RENTA));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_APROBADO_RENTA))) {
						fechaFinPAR = ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_APROBADO_RENTA));
					}
					
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_APROB_P_DESCUENTO_APROB))) {
						fechaAprobPDA = ft.parse(exc.dameCelda(i, COLUMNA_F_APROB_P_DESCUENTO_APROB));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_APROB))) {
						fechaInicioPDA = ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_APROB));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_APROB))) {
						fechaFinPDA = ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_APROB));
					}
					
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_APROB_P_DESCUENTO_PUB))) {
						fechaAprobPDP = ft.parse(exc.dameCelda(i, COLUMNA_F_APROB_P_DESCUENTO_PUB));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_PUB))) {
						fechaInicioPDP = ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_PUB));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_PUB))) {
						fechaFinPDP = ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_PUB));
					}
	
					// Comprobaciones de las reglas en base a las fechas temporales.
					//TODO Añadir comprobaciones para las fechas de aprobación.
					// Fecha fechaFinPMA < fechaFinPAV.
					if(!Checks.esNulo(fechaFinPAV) && !Checks.esNulo(fechaFinPMA) && (fechaFinPAV.after(fechaFinPMA))){
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
					// Fecha fechaInicioPAV < fechaInicioPMA.
					if(!Checks.esNulo(fechaInicioPAV) && !Checks.esNulo(fechaInicioPMA) && (fechaInicioPMA.after(fechaInicioPAV))){
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
					// Fecha fechaFinPMA < fechaFinPDA.
//					if(!Checks.esNulo(fechaFinPDA) && !Checks.esNulo(fechaFinPMA) && (fechaFinPDA.after(fechaFinPMA))){
//						if(!listaFilas.contains(i)) {
//							listaFilas.add(i);
//						}
//					}
					// Fecha fechaInicioPDA < fechaInicioPMA.
//					if(!Checks.esNulo(fechaInicioPDA) && !Checks.esNulo(fechaInicioPMA) && (fechaInicioPMA.after(fechaInicioPDA))){
//						if(!listaFilas.contains(i)) {
//							listaFilas.add(i);
//						}
//					}
					// Fecha fechaInicioPDP < fechaInicioPDA.
					if(!Checks.esNulo(fechaInicioPDP) && !Checks.esNulo(fechaInicioPDA) && (fechaInicioPDA.after(fechaInicioPDP))){
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
					// Fecha fechaInicioPDP < fechaInicioPAV.
//					if(!Checks.esNulo(fechaInicioPDP) && !Checks.esNulo(fechaInicioPAV) && (fechaInicioPAV.after(fechaInicioPDP))){
//						if(!listaFilas.contains(i)) {
//							listaFilas.add(i);
//						}
//					}
					// Fecha fechaFinPDA < fechaFinPDP.
					if(!Checks.esNulo(fechaFinPDP) && !Checks.esNulo(fechaFinPDA) && (fechaFinPDP.after(fechaFinPDA))){
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
					// Fecha fechaFinPAV < fechaFinPDP.
//					if(!Checks.esNulo(fechaFinPDP) && !Checks.esNulo(fechaFinPAV) && (fechaFinPDP.after(fechaFinPAV))){
//						if(!listaFilas.contains(i)) {
//							listaFilas.add(i);
//						}
//					}
					// Fecha fechaFinPAV < fechaFinPAV.
//					if(!Checks.esNulo(fechaFinPDA) && !Checks.esNulo(fechaFinPAV) && (fechaFinPDA.after(fechaFinPAV))){
//						if(!listaFilas.contains(i)) {
//							listaFilas.add(i);
//						}
//					}
					// Fecha fechaInicioPDA < fechaInicioPAV.
//					if(!Checks.esNulo(fechaInicioPDA) && !Checks.esNulo(fechaInicioPAV) && (fechaInicioPAV.after(fechaInicioPDA))){
//						if(!listaFilas.contains(i)) {
//							listaFilas.add(i);
//						}
//					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	/**
	 * Este metodo comprueba los precios indicados en la excel con los precios actuales
	 * para determinar si se van a seguir cumpliendo las normas de precios del activo.
	 * 
	 * @param exc : archivo excel.
	 * @return
	 */
	private List<Integer> getComparacionDePreciosExcelDDBB(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		BigDecimal importePAV = null;
		BigDecimal importePMA = null;
		BigDecimal importePAR = null; // Actualmente no tiene reglas que lo utilicen.
		BigDecimal importePDA = null;
		BigDecimal importePDP = null;

		try {
			for(int i = 1; i < this.numFilasHoja; i++){

				try {
					// Obtener los importes actuales del activo.
					List<BigDecimal> importes = particularValidator.getImportesActualesActivo(exc.dameCelda(i, COLUMNA_ACTIVO));
					importePAV = importes.get(0);
					importePMA = importes.get(1);
					importePAR = importes.get(2);
					importePDA = importes.get(3);
					importePDP = importes.get(4);
	
					//Obtener importes de la excel y machacar los actuales importes del activo si est�n definidos.
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_P_APROBADO_VENTA))) {
						importePAV = BigDecimal.valueOf(Double.valueOf(exc.dameCelda(i, COLUMNA_P_APROBADO_VENTA)));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_P_MIN_AUTORIZADO))) {
						importePMA = BigDecimal.valueOf(Double.valueOf(exc.dameCelda(i, COLUMNA_P_MIN_AUTORIZADO)));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_P_APROB_RENTA))) {
						importePAR = BigDecimal.valueOf(Double.valueOf(exc.dameCelda(i, COLUMNA_P_APROB_RENTA)));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_APROBADO))) {
						importePDA = BigDecimal.valueOf(Double.valueOf(exc.dameCelda(i, COLUMNA_P_DESCUENTO_APROBADO)));
					}
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_PUBLICADO))) {
						importePDP = BigDecimal.valueOf(Double.valueOf(exc.dameCelda(i, COLUMNA_P_DESCUENTO_PUBLICADO)));
					}
	
					// Comprobaciones de las reglas en base a los precios temporales.
					if(!Checks.esNulo(importePAV) && !Checks.esNulo(importePMA) && (importePMA.compareTo(importePAV) == 1)) {
						// adjuntar linea, es erroneo.
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
	
					if(!Checks.esNulo(importePDA) && !Checks.esNulo(importePDP) && (importePDA.compareTo(importePDP) == 1)) {
						// adjuntar linea, es erroneo.
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
	
//					if(!Checks.esNulo(importePDA) && !Checks.esNulo(importePAV) && (importePDA.compareTo(importePAV) == 1)) {
//						// adjuntar linea, es erroneo.
//						if(!listaFilas.contains(i)) {
//							listaFilas.add(i);
//						}
//					}
	
//					if(!Checks.esNulo(importePDP) && !Checks.esNulo(importePAV) && (importePDP.compareTo(importePAV) == 1)) {
//						// adjuntar linea, es erroneo.
//						if(!listaFilas.contains(i)) {
//							listaFilas.add(i);
//						}
//					}
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
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

	 
	
	private boolean isActiveExists(MSVHojaExcel exc){
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, COLUMNA_ACTIVO)))
					return false;
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return true;
	}
	
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.existeActivo(exc.dameCelda(i, COLUMNA_ACTIVO)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getPreciosBloqueadoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el activo tiene activo el bloqueo de precios. No pueden actualizarse precios.
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.existeBloqueoPreciosActivo(exc.dameCelda(i, COLUMNA_ACTIVO)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getOfertaAprobadaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el activo tiene ofertas activas. No pueden actualizarse precios.
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.existeOfertaAprobadaActivo(exc.dameCelda(i, COLUMNA_ACTIVO)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getNANPrecioIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioVentaAprobado = null;
		Double precioMinimoAuth = null;
		Double precioRentaAprobado = null;
		Double precioDescuentoAprobado = null;
		Double precioDescuentoPublicado = null;
		
		// Validacion que evalua si los precios son numeros correctos
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					precioVentaAprobado 		= !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_APROBADO_VENTA)) 		? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_APROBADO_VENTA)) : null;
					precioMinimoAuth 			= !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_MIN_AUTORIZADO)) 		? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_MIN_AUTORIZADO)) : null;
					precioRentaAprobado 		= !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_APROB_RENTA)) 			? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_APROB_RENTA)) : null;
					precioDescuentoAprobado 	= !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_APROBADO)) 	? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_DESCUENTO_APROBADO)) : null;
					precioDescuentoPublicado 	= !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_PUBLICADO)) 	? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_DESCUENTO_PUBLICADO)) :null ;
					
					// Si alguno de los precios no es un numero
					if((!Checks.esNulo(precioVentaAprobado) && precioVentaAprobado.isNaN()) ||
							(!Checks.esNulo(precioMinimoAuth) && precioMinimoAuth.isNaN()) ||
							(!Checks.esNulo(precioRentaAprobado) && precioRentaAprobado.isNaN()) ||
							(!Checks.esNulo(precioDescuentoAprobado) && precioDescuentoAprobado.isNaN()) ||
							(!Checks.esNulo(precioDescuentoPublicado) && precioDescuentoPublicado.isNaN()) )
						listaFilas.add(i);	
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> getLimitePreciosDescAprobDescWebIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioDescuentoAprobado = null;
		Double precioDescuentoPublicado = null;
		
		// Validacion que evalua si los precios estan dentro de los l�mites, comparandolos entre si
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					precioDescuentoAprobado  = !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_APROBADO)) ? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_DESCUENTO_APROBADO)) : null;
					precioDescuentoPublicado = !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_PUBLICADO)) ? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_DESCUENTO_PUBLICADO)) : null;
					
					// Condiciones Limites: dto<=dto web<=aprobado
					
					// Limite: Precio Descuento Web >= Precio Descuento Aprobado
					if(!Checks.esNulo(precioDescuentoAprobado) && 
							!Checks.esNulo(precioDescuentoPublicado) &&
							(precioDescuentoAprobado > precioDescuentoPublicado)){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> getLimitePreciosAprobadoMinimoIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioVentaAprobado = null;
		Double precioMinimoAuth = null;

		// Validacion que evalua si los precios estan dentro de los l�mites, comparandolos entre si y con el precio minimo actual si existe.
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					precioVentaAprobado = !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_APROBADO_VENTA)) ? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_APROBADO_VENTA)) : null;
					precioMinimoAuth 	= !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_MIN_AUTORIZADO)) ? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_MIN_AUTORIZADO)) : null;

				
					
					// Condiciones Limites: dto<=dto web<=aprobado
					
					// Limite: Precio Aprobado Venta > Precio Minimo Auth o > Precio Minimo Auth actual
					if(!Checks.esNulo(precioMinimoAuth) && 
							!Checks.esNulo(precioVentaAprobado) &&
							(precioMinimoAuth > precioVentaAprobado))
							{
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> getLimitePreciosAprobadoDescWebIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioVentaAprobado = null;
		Double precioDescuentoPublicado = null;
		
		// Validacion que evalua si los precios estan dentro de los l�mites, comparandolos entre si
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					precioVentaAprobado 	 = !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_APROBADO_VENTA)) 		? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_APROBADO_VENTA)) : null;
					precioDescuentoPublicado = !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_PUBLICADO)) 	? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_DESCUENTO_PUBLICADO)) : null;
					
					// Condiciones Limites: dto<=dto web<=aprobado y aprobado>=minimo
					
					// Limite: Precio Aprobado Venta >= Precio Descuento Web
					if(!Checks.esNulo(precioVentaAprobado) && 
							!Checks.esNulo(precioDescuentoPublicado) &&
							(precioDescuentoPublicado > precioVentaAprobado)){
						if (!listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> isPreciosMayorCeroRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioVentaAprobado = null;
		Double precioMinimoAuth = null;
		Double precioRentaAprobado = null;
		Double precioDescuentoAprobado = null;
		Double precioDescuentoPublicado = null;
		
		// Validacion que evalua si los precios son mayores que cero
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					precioVentaAprobado 	 = !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_APROBADO_VENTA)) 		? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_APROBADO_VENTA)) : null;
					precioMinimoAuth 		 = !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_MIN_AUTORIZADO)) 		? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_MIN_AUTORIZADO)) : null;
					precioRentaAprobado 	 = !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_APROB_RENTA)) 			? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_APROB_RENTA)) : null;
					precioDescuentoAprobado  = !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_APROBADO)) 	? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_DESCUENTO_APROBADO)) : null;
					precioDescuentoPublicado = !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_PUBLICADO)) 	? Double.parseDouble(exc.dameCelda(i, COLUMNA_P_DESCUENTO_PUBLICADO)) :null ;
					
					if((!Checks.esNulo(precioVentaAprobado) && precioVentaAprobado.compareTo(0.0D) <= 0) ||
							(!Checks.esNulo(precioMinimoAuth) && precioMinimoAuth.compareTo(0.0D) <= 0) ||
							(!Checks.esNulo(precioRentaAprobado) && precioRentaAprobado.compareTo(0.0D) <= 0) ||
							(!Checks.esNulo(precioDescuentoAprobado) && precioDescuentoAprobado.compareTo(0.0D) <= 0) ||
							(!Checks.esNulo(precioDescuentoPublicado) && precioDescuentoPublicado.compareTo(0.0D) <= 0) )
						listaFilas.add(i);	
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
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
		
		// Validacion que evalua si las fechas de precios estan dentro de los l�mites
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					fechaInicioPAV 	= !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_PRECIO_APROB_VENTA)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_PRECIO_APROB_VENTA)) : null;
					fechaFinPAV 	= !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_PRECIO_APROB_VENTA)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_PRECIO_APROB_VENTA)) : null;
					
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
			listaFilas.add(0);
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
		
		// Validacion que evalua si las fechas de precios estan dentro de los l�mites
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					fechaInicioPAR 	= !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_APROBADO_RENTA)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_APROBADO_RENTA)) : null;
					fechaFinPAR 	= !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_APROBADO_RENTA)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_APROBADO_RENTA)) : null;
					
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
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> getFechaFinMinimoInferiorHoy(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaFinPMA = null;
		
		// Validaci�n que evalua si la fecha de inicio del precio m�nimo es superior al d�a de hoy.
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					fechaFinPMA = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_MIN_AUTORIZADO)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_MIN_AUTORIZADO)) : null;
					
					// Fecha Fin < hoy
					if(!Checks.esNulo(fechaFinPMA) && (new Date().after(fechaFinPMA))){
						if (!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> getFechaInicioMinimoPosteriorHoy(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioPMA = null;
		
		// Validaci�n que evalua si la fecha de inicio del precio m�nimo es superior al d�a de hoy.
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					fechaInicioPMA = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_MIN_AUTORIZADO)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_MIN_AUTORIZADO)) : null;
					
					// Fecha Inicio > hoy
					if(!Checks.esNulo(fechaInicioPMA) && (fechaInicioPMA.after(new Date()))){
						if (!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
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
		
		// Validacion que evalua si las fechas de precios estan dentro de los l�mites
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					fechaInicioPMA  = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_MIN_AUTORIZADO)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_MIN_AUTORIZADO)) : null;
					fechaFinPMA 	= !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_MIN_AUTORIZADO)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_MIN_AUTORIZADO)) : null;
					
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
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> getFechaInicioDescuentoAprobNoEstablecida(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		// Validacion que evalua si la fecha de inicio de descuento aprobado no se encuentra establecida.
		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_APROBADO))) { // Si el importe no est� vac�o.
						if(Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_APROB))) { // Comprobar que la fecha tampoco.
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}
	
	private List<Integer> getFechaFinDescuentoAprobNoEstablecida(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		// Validacion que evalua si la fecha de fin de descuento aprobado no se encuentra establecida.
		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_APROBADO))) { // Si el importe no est� vac�o.
						if(Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_APROB))) { // Comprobar que la fecha tampoco.
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}
	
	private List<Integer> getFechaInicioDescuentoPubNoEstablecida(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		// Validacion que evalua si la fecha de inicio de descuento publicado no se encuentra establecida.
		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_PUBLICADO))) { // Si el importe no est� vac�o.
						if(Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_PUB))) { // Comprobar que la fecha tampoco.
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> getFechaInicioAprovadoVentaMayorFechaInicioMinimoAutorizado(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioPAV = null;
		Date fechaInicioPMA = null;

		// Validacion que evalua si la fecha de fin del aprobado venta es menor o igual que la fecha fin del m�nimo autorizado.
		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try {
					 fechaInicioPAV = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_PRECIO_APROB_VENTA)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_PRECIO_APROB_VENTA)) : null;
					 fechaInicioPMA = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_MIN_AUTORIZADO)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_MIN_AUTORIZADO)) : null;

					// Fecha fechaInicioPAV >= fechaInicioPMA.
					if(!Checks.esNulo(fechaInicioPAV) && !Checks.esNulo(fechaInicioPMA) && (fechaInicioPMA.after(fechaInicioPAV))){
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}	
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> getFechaFinDescuentoWebMayorFechaFinAprovadoVenta(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaFinPDW = null;
		Date fechaFinPAV = null;

		// Validaci�n que evalua si la fecha de fin del descuento publicado es menor o igual que la fecha fin del aprobado venta.
		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try {
					fechaFinPAV = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_PRECIO_APROB_VENTA)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_PRECIO_APROB_VENTA)) : null;
					fechaFinPDW = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_PUB)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_PUB)) : null;

					// Fecha fechaInicioPDW <= fechaInicioPDA.
					if(!Checks.esNulo(fechaFinPDW) && !Checks.esNulo(fechaFinPAV) && (fechaFinPDW.after(fechaFinPAV))){
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}	
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> getFechaFinDescuentoWebMayorFechaFinDescuentoAprobado(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaFinPDW = null;
		Date fechaFinPDA = null;

		// Validaci�n que evalua si la fecha de fin del descuento publicado es menor o igual que la fecha fin del descuento aprobado.
		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try {
					fechaFinPDA = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_APROB)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_APROB)) : null;
					fechaFinPDW = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_PUB)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_PUB)) : null;

					// Fecha fechaInicioPDW <= fechaInicioPDA.
					if(!Checks.esNulo(fechaFinPDW) && !Checks.esNulo(fechaFinPDA) && (fechaFinPDW.after(fechaFinPDA))){
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}	
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> getFechaInicioDescuentoWebMenorFechaInicioAprovadoVenta(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioPDW = null;
		Date fechaInicioPAV = null;

		// Validaci�n que evalua si la fecha de inicio del descuento publicado es mayor o igual que la fecha inicio del aprobado venta.
		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try {
					fechaInicioPAV = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_PRECIO_APROB_VENTA)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_PRECIO_APROB_VENTA)) : null;
					fechaInicioPDW = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_PUB)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_PUB)) : null;

					// Fecha fechaInicioPDW <= fechaInicioPDA.
					if(!Checks.esNulo(fechaInicioPDW) && !Checks.esNulo(fechaInicioPAV) && (fechaInicioPAV.after(fechaInicioPDW))){
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}	
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> getFechaInicioDescuentoWebMenorFechaInicioDescuentoAprobado(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioPDW = null;
		Date fechaInicioPDA = null;

		// Validaci�n que evalua si la fecha de inicio del descuento publicado es mayor o igual que la fecha inicio del descuento aprobado.
		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try {
					fechaInicioPDA = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_APROB)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_APROB)) : null;
					fechaInicioPDW = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_PUB)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_PUB)) : null;

					// Fecha fechaInicioPDW <= fechaInicioPDA.
					if(!Checks.esNulo(fechaInicioPDW) && !Checks.esNulo(fechaInicioPDA) && (fechaInicioPDA.after(fechaInicioPDW))){
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}	
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> getFechaInicioDescuentoAprobadoMenorFechaInicioMinimoAutorizado(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaInicioPDA = null;
		Date fechaInicioPMA = null;

		// Validaci�n que evalua si la fecha de inicio del descuento aprobado es mayor o igual que la fecha inicio del m�nimo autorizado.
		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try {
					fechaInicioPMA = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_MIN_AUTORIZADO)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_MIN_AUTORIZADO)) : null;
					fechaInicioPDA = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_APROB)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_APROB)) : null;

					// Fecha fechaFinPAV <= fechaFinPMA.
					if(!Checks.esNulo(fechaInicioPDA) && !Checks.esNulo(fechaInicioPMA) && (fechaInicioPMA.after(fechaInicioPDA))){
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}	
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> getFechaFinDescuentoAprobadoMayorFechaFinMinimoAutorizado(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaFinPDA = null;
		Date fechaFinPMA = null;

		// Validaci�n que evalua si la fecha de fin del descuento aprobado es menor o igual que la fecha fin del m�nimo autorizado.
		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try {
					fechaFinPMA = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_MIN_AUTORIZADO)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_MIN_AUTORIZADO)) : null;
					fechaFinPDA = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_APROB)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_APROB)) : null;

					// Fecha fechaFinPAV <= fechaFinPMA.
					if(!Checks.esNulo(fechaFinPDA) && !Checks.esNulo(fechaFinPMA) && (fechaFinPDA.after(fechaFinPMA))){
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}	
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> getFechaFinAprovadoVentaMenorFechaFinMinimoAutorizado(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaFinPAV = null;
		Date fechaFinPMA = null;

		// Validacion que evalua si la fecha de fin del aprobado venta es menor o igual que la fecha fin del m�nimo autorizado.
		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try {
					fechaFinPAV = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_PRECIO_APROB_VENTA)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_PRECIO_APROB_VENTA)) : null;
					fechaFinPMA = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_MIN_AUTORIZADO)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_MIN_AUTORIZADO)) : null;

					// Fecha fechaFinPAV <= fechaFinPMA.
					if(!Checks.esNulo(fechaFinPAV) && !Checks.esNulo(fechaFinPMA) && (fechaFinPAV.after(fechaFinPMA))){
						if(!listaFilas.contains(i)) {
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}	
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> getFechaFinDescuentoPubNoEstablecida(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		// Validacion que evalua si la fecha de fin de descuento publicado no se encuentra establecida.
		try {
			for(int i = 1; i < this.numFilasHoja; i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COLUMNA_P_DESCUENTO_PUBLICADO))) { // Si el importe no est� vac�o.
						if(Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_PUB))) { // Comprobar que la fecha tampoco.
							listaFilas.add(i);
						}
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}	
			}
		} catch (Exception e) {
			listaFilas.add(0);
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
		
		// Validacion que evalua si las fechas de precios estan dentro de los l�mites
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					fechaInicioPDA = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_APROB)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_APROB)) : null;
					fechaFinPDA = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_APROB)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_APROB)) : null;
					
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
			listaFilas.add(0);
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
		
		// Validacion que evalua si las fechas de precios estan dentro de los l�mites
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					fechaInicioPDP = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_PUB)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_INI_P_DESCUENTO_PUB)) : null;
					fechaFinPDP = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_PUB)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_FIN_P_DESCUENTO_PUB)) : null;
					
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
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> getFechasAprobacionRellenadas(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fechaAprobPAV = null;
		Boolean esBBVA = null;
		
		// Validacion que evalua si las fechas de aprobación están rellenadas:
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					if(particularValidator.esActivoBBVA(exc.dameCelda(i, COLUMNA_ACTIVO))
							&& !Checks.esNulo(exc.dameCelda(i, COLUMNA_P_APROBADO_VENTA))) {
						fechaAprobPAV = !Checks.esNulo(exc.dameCelda(i, COLUMNA_F_APROB_P_APROBADO_VENTA)) ? ft.parse(exc.dameCelda(i, COLUMNA_F_APROB_P_APROBADO_VENTA)) : null;
						
						if(Checks.esNulo(fechaAprobPAV) && !listaFilas.contains(i))
							listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
					logger.error(e.getMessage());
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
}