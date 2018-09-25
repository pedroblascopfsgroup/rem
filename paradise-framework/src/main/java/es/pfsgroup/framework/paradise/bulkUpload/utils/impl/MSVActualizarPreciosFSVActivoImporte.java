package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
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
public class MSVActualizarPreciosFSVActivoImporte extends MSVExcelValidatorAbstract {
		
	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String ACTIVE_PRIZE_NAN = "msg.error.masivo.actualizar.precios.fsv.activo.importe.formato.incorrecto";
	public static final String ACTIVE_PRIZES_VENTA_RENTA_LIMIT_EXCEEDED = "El valor FSV de Renta no puede ser mayor al valor FSV de Renta (FSV Venta >= FSV Renta) o uno de estos valores no tiene un formato correcto";
	public static final String ACTIVE_PRIZES_VENTA_NOT_GREATER_ZERO = "msg.error.masivo.actualizar.precios.FSV.Venta.importe.no.mayor.cero";
	public static final String ACTIVE_PRIZES_RENTA_NOT_GREATER_ZERO = "msg.error.masivo.actualizar.precios.FSV.Renta.importe.no.mayor.cero";
	
	public static final String ACTIVE_NOT_ACTUALIZABLE = "El estado del activo no puede actualizarse al indicado.";
	public static final String ACTIVE_PRECIOS_BLOQUEO = "El activo tiene habilitado el bloqueo de precios. No se pueden actualizar precios";
	public static final String ACTIVE_OFERTA_APROBADA = "El activo tiene ofertas aprobadas. No se pueden actualizar precios";
	public static final String LIQUIDEZ_A_E = "El campo liquidez debe ser una letra entre la A y la E";

	//Definimos constantes para comparar las letras del campo "Liquidez"
	public static final String A = "A";
	public static final String B = "B";
	public static final String C = "C";
	public static final String D = "D";
	public static final String E = "E";
	
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
			mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZE_NAN), getNANPrecioIncorrectoRows(exc));
			mapaErrores.put(ACTIVE_PRIZES_VENTA_RENTA_LIMIT_EXCEEDED, getLimitePreciosVentaRentaIncorrectoRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZES_VENTA_NOT_GREATER_ZERO), isPrecioVentaMayorCero(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVE_PRIZES_RENTA_NOT_GREATER_ZERO), isPrecioRentaMayorCero(exc));
			mapaErrores.put(LIQUIDEZ_A_E, isLetraEntreAE(exc));

			if (!mapaErrores.get(ACTIVE_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZE_NAN)).isEmpty()
					|| !mapaErrores.get(ACTIVE_PRIZES_VENTA_RENTA_LIMIT_EXCEEDED).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZES_VENTA_NOT_GREATER_ZERO)).isEmpty()
					|| !mapaErrores.get(messageServices.getMessage(ACTIVE_PRIZES_RENTA_NOT_GREATER_ZERO)).isEmpty()
					|| !mapaErrores.get(LIQUIDEZ_A_E).isEmpty()){
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
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private boolean isActiveExists(MSVHojaExcel exc){
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, 0)))
					return false;
			}
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return true;
	}
	
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.existeActivo(exc.dameCelda(i, 0)))
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
	
	private List<Integer> getPreciosBloqueadoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el activo tiene activo el bloqueo de precios. No pueden actualizarse precios.
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.existeBloqueoPreciosActivo(exc.dameCelda(i, 0)))
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
	
	private List<Integer> getOfertaAprobadaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el activo tiene ofertas activas. No pueden actualizarse precios.
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.existeOfertaAprobadaActivo(exc.dameCelda(i, 0)))
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
	
	private List<Integer> getNANPrecioIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioFSVVenta = null;
		Double precioFSVRenta = null;

		
		// Validacion que evalua si los precios son numeros correctos
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					precioFSVVenta = !Checks.esNulo(exc.dameCelda(i, 1)) ? Double.parseDouble(exc.dameCelda(i, 1)) : null;
					precioFSVRenta = !Checks.esNulo(exc.dameCelda(i, 2)) ? Double.parseDouble(exc.dameCelda(i, 2)) : null;
					
					// Si alguno de los precios no es un numero
					if((!Checks.esNulo(precioFSVVenta) && precioFSVVenta.isNaN()) ||
							(!Checks.esNulo(precioFSVRenta) && precioFSVRenta.isNaN()) )
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
	
	private List<Integer> getLimitePreciosVentaRentaIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double valorFSVVenta = null;
		Double valorFSVRenta = null;
		
		// Validacion que evalua si los precios estan dentro de los l�mites, comparandolos entre si
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					valorFSVVenta = !Checks.esNulo(exc.dameCelda(i, 1)) ? Double.parseDouble(exc.dameCelda(i, 1)) : null;
					valorFSVRenta = !Checks.esNulo(exc.dameCelda(i, 2)) ? Double.parseDouble(exc.dameCelda(i, 2)) : null;
					
					// Condiciones Limites: dto<=dto web<=aprobado
					
					// Limite: Precio Descuento Web >= Precio Descuento Aprobado
					if(!Checks.esNulo(valorFSVVenta) && 
							!Checks.esNulo(valorFSVRenta) &&
							(valorFSVRenta > valorFSVVenta)){
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
	
	private List<Integer> isPrecioVentaMayorCero(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double valorFSVVenta = null;
		
		// Validacion que evalua si el precio FSV Venta es > 0
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					valorFSVVenta = !Checks.esNulo(exc.dameCelda(i, 1)) ? Double.parseDouble(exc.dameCelda(i, 1)) : null;

					if(!Checks.esNulo(valorFSVVenta) && 
							(valorFSVVenta.compareTo(0.0D) <= 0)){
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
	
	private List<Integer> isPrecioRentaMayorCero(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double valorFSVRenta = null;
		
		// Validacion que evalua si el precio FSV Renta es > 0
		try {
			for(int i=1; i<this.numFilasHoja;i++){
				try{
					valorFSVRenta = !Checks.esNulo(exc.dameCelda(i, 2)) ? Double.parseDouble(exc.dameCelda(i, 2)) : null;
					
					if(!Checks.esNulo(valorFSVRenta) &&
							(valorFSVRenta.compareTo(0.0D) <= 0)){
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
	
	private List<Integer> isLetraEntreAE(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for(int i=1; i<this.numFilasHoja;i++){
			
			try {
				if(!A.equals(exc.dameCelda(i, 4).toUpperCase()) && !B.equals(exc.dameCelda(i, 4).toUpperCase())
						&& !C.equals(exc.dameCelda(i, 4).toUpperCase()) && !D.equals(exc.dameCelda(i, 4).toUpperCase())
						&& !E.equals(exc.dameCelda(i, 4).toUpperCase())) {
					listaFilas.add(i);
				}
			} catch (IllegalArgumentException e) {
				listaFilas.add(i);
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (ParseException e) {
				e.printStackTrace();
			}
			
		}
		
		return listaFilas;
	}
	
}