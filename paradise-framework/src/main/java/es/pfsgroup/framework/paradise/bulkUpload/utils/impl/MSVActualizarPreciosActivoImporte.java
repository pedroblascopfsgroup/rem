package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
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
	public static final String ACTIVE_PRIZES_DESCUENTOS_LIMIT_EXCEEDED = "El precio de descuento aprobado no puede ser mayor al precio de descuento publicado (P.Descuento <= P.Descuento Pub.)";
	public static final String ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED = "El precio aprobado de venta no puede ser menor al precio mínimo autorizado (P.Minimo <= P.Aprobado Venta)";
	public static final String ACTIVE_PRIZES_VENTA_DESCUENTOWEB_LIMIT_EXCEEDED = "El precio de descuento publicado no puede ser mayor al precio aprobado de venta (P.Descuento Pub. <= P.Aprobado Venta)";
	public static final String ACTIVE_PAV_DATE_INIT_EXCEEDED = "La fecha de inicio del precio aprobado de venta no puede ser posterior a la fecha de fin (F.inicio <= F.Fin)";
	public static final String ACTIVE_PMA_DATE_INIT_EXCEEDED = "La fecha de inicio del precio mínimo autorizado no puede ser posterior a la fecha de fin (F.inicio <= F.Fin)";
	public static final String ACTIVE_PAR_DATE_INIT_EXCEEDED = "La fecha de inicio del precio aprobado de renta no puede ser posterior a la fecha de fin (F.inicio <= F.Fin)";
	public static final String ACTIVE_PDA_DATE_INIT_EXCEEDED = "La fecha de inicio del precio de descuento aprobado no puede ser posterior a la fecha de fin (F.inicio <= F.Fin)";
	public static final String ACTIVE_PDP_DATE_INIT_EXCEEDED = "La fecha de inicio del precio de descuento publicado no puede ser posterior a la fecha de fin (F.inicio <= F.Fin)";
	
	public static final String ACTIVE_NOT_ACTUALIZABLE = "El estado del activo no puede actualizarse al indicado.";
	public static final String ACTIVE_PRECIOS_BLOQUEO = "El activo tiene habilitado el bloqueo de precios. No se pueden actualizar precios";
	public static final String ACTIVE_OFERTA_APROBADA = "El activo tiene ofertas aprobadas. No se pueden actualizar precios";

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

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) {
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion()));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
//			if (!isActiveExists(exc)){
				Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
				mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
				mapaErrores.put(ACTIVE_PRIZE_NAN, getNANPrecioIncorrectoRows(exc));
				mapaErrores.put(ACTIVE_PRIZES_DESCUENTOS_LIMIT_EXCEEDED, getLimitePreciosDescAprobDescWebIncorrectoRows(exc));
				mapaErrores.put(ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED, getLimitePreciosAprobadoMinimoIncorrectoRows(exc));
				mapaErrores.put(ACTIVE_PRIZES_VENTA_DESCUENTOWEB_LIMIT_EXCEEDED, getLimitePreciosAprobadoDescWebIncorrectoRows(exc));
				mapaErrores.put(ACTIVE_PAV_DATE_INIT_EXCEEDED, getFechaInicioAprobadoVentaIncorrectaRows(exc));
				mapaErrores.put(ACTIVE_PMA_DATE_INIT_EXCEEDED, getFechaInicioAprobadoRentaIncorrectaRows(exc));
				mapaErrores.put(ACTIVE_PAR_DATE_INIT_EXCEEDED, getFechaInicioMinimoAuthIncorrectaRows(exc));
				mapaErrores.put(ACTIVE_PDA_DATE_INIT_EXCEEDED, getFechaInicioDescuentoAprobIncorrectaRows(exc));
				mapaErrores.put(ACTIVE_PDP_DATE_INIT_EXCEEDED, getFechaInicioDescuentoPubIncorrectaRows(exc));
				
				try{
					if(!mapaErrores.get(ACTIVE_NOT_EXISTS).isEmpty() ||
							!mapaErrores.get(ACTIVE_PRIZE_NAN).isEmpty() ||
							!mapaErrores.get(ACTIVE_PRIZES_DESCUENTOS_LIMIT_EXCEEDED).isEmpty() ||
							!mapaErrores.get(ACTIVE_PRIZES_VENTA_MINIMO_LIMIT_EXCEEDED).isEmpty() ||
							!mapaErrores.get(ACTIVE_PRIZES_VENTA_DESCUENTOWEB_LIMIT_EXCEEDED).isEmpty() || 
							!mapaErrores.get(ACTIVE_PAV_DATE_INIT_EXCEEDED).isEmpty() ||
							!mapaErrores.get(ACTIVE_PMA_DATE_INIT_EXCEEDED).isEmpty() ||
							!mapaErrores.get(ACTIVE_PAR_DATE_INIT_EXCEEDED).isEmpty() ||
							!mapaErrores.get(ACTIVE_PDA_DATE_INIT_EXCEEDED).isEmpty() || 
							!mapaErrores.get(ACTIVE_PDP_DATE_INIT_EXCEEDED).isEmpty() ){
						dtoValidacionContenido.setFicheroTieneErrores(true);
						exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
						String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
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
			for(int i=1; i<exc.getNumeroFilas();i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, 0)))
					return false;
			}
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return true;
	}
	
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		return listaFilas;
	}
	
	private List<Integer> getPreciosBloqueadoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el activo tiene activo el bloqueo de precios. No pueden actualizarse precios.
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){
				if(particularValidator.existeBloqueoPreciosActivo(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		return listaFilas;
	}
	
	private List<Integer> getOfertaAprobadaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		// Validacion que evalua si el activo tiene ofertas activas. No pueden actualizarse precios.
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){
				if(particularValidator.existeOfertaAprobadaActivo(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
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
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){

				precioVentaAprobado = Double.parseDouble(exc.dameCelda(i, 1));
				precioMinimoAuth = Double.parseDouble(exc.dameCelda(i, 4));
				precioRentaAprobado = Double.parseDouble(exc.dameCelda(i, 7));
				precioDescuentoAprobado = Double.parseDouble(exc.dameCelda(i, 10));
				precioDescuentoPublicado = Double.parseDouble(exc.dameCelda(i, 13));
				
				// Si alguno de los precios no es un numero
				if(precioVentaAprobado.isNaN() ||
						precioMinimoAuth.isNaN() ||
						precioRentaAprobado.isNaN() ||
						precioDescuentoAprobado.isNaN() ||
						precioDescuentoPublicado.isNaN())
					listaFilas.add(i);

			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> getLimitePreciosDescAprobDescWebIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioDescuentoAprobado = null;
		Double precioDescuentoPublicado = null;
		
		// Validacion que evalua si los precios estan dentro de los límites, comparandolos entre si
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){

				precioDescuentoAprobado = Double.parseDouble(exc.dameCelda(i, 10));
				precioDescuentoPublicado = Double.parseDouble(exc.dameCelda(i, 13));
				
				// Condiciones Limites: dto<=dto web<=aprobado
				
				// Limite: Precio Descuento Web >= Precio Descuento Aprobado
				if(!Checks.esNulo(precioDescuentoAprobado) && 
						!Checks.esNulo(precioDescuentoPublicado) &&
						(precioDescuentoAprobado > precioDescuentoPublicado)){
					if (!listaFilas.contains(i))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> getLimitePreciosAprobadoMinimoIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioVentaAprobado = null;
		Double precioMinimoAuth = null;
		
		// Validacion que evalua si los precios estan dentro de los límites, comparandolos entre si
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){

				precioVentaAprobado = Double.parseDouble(exc.dameCelda(i, 1));
				precioMinimoAuth = Double.parseDouble(exc.dameCelda(i, 4));
				
				// Condiciones Limites: dto<=dto web<=aprobado
				
				// Limite: Precio Aprobado Venta >= Precio Minimo Auth
				if(!Checks.esNulo(precioMinimoAuth) && 
						!Checks.esNulo(precioVentaAprobado) &&
						(precioMinimoAuth > precioVentaAprobado)){
					if (!listaFilas.contains(i))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> getLimitePreciosAprobadoDescWebIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double precioVentaAprobado = null;
		Double precioDescuentoPublicado = null;
		
		// Validacion que evalua si los precios estan dentro de los límites, comparandolos entre si
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){

				precioVentaAprobado = Double.parseDouble(exc.dameCelda(i, 1));
				precioDescuentoPublicado = Double.parseDouble(exc.dameCelda(i, 13));
				
				// Condiciones Limites: dto<=dto web<=aprobado y aprobado>=minimo
				
				// Limite: Precio Aprobado Venta >= Precio Descuento Web
				if(!Checks.esNulo(precioVentaAprobado) && 
						!Checks.esNulo(precioDescuentoPublicado) &&
						(precioDescuentoPublicado > precioVentaAprobado)){
					if (!listaFilas.contains(i))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> getFechaInicioAprobadoVentaIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
		Date fechaInicioPAV = null;
		Date fechaFinPAV = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){

				fechaInicioPAV = ft.parse(exc.dameCelda(i, 2));
				fechaFinPAV = ft.parse(exc.dameCelda(i, 3));
				
				//Fecha Inicio <= Fecha Fin
				if(!Checks.esNulo(fechaInicioPAV) && 
						!Checks.esNulo(fechaFinPAV) &&
						(fechaInicioPAV.after(fechaFinPAV))){
					if (!listaFilas.contains(i))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}

	private List<Integer> getFechaInicioAprobadoRentaIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
		Date fechaInicioPAR = null;
		Date fechaFinPAR = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){

				fechaInicioPAR = ft.parse(exc.dameCelda(i, 8));
				fechaFinPAR = ft.parse(exc.dameCelda(i, 9));
				
				//Fecha Inicio <= Fecha Fin
				if(!Checks.esNulo(fechaInicioPAR) && 
						!Checks.esNulo(fechaFinPAR) &&
						(fechaInicioPAR.after(fechaFinPAR))){
					if (!listaFilas.contains(i))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}

	private List<Integer> getFechaInicioMinimoAuthIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
		Date fechaInicioPMA = null;
		Date fechaFinPMA = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){

				fechaInicioPMA = ft.parse(exc.dameCelda(i, 5));
				fechaFinPMA = ft.parse(exc.dameCelda(i, 6));
				
				//Fecha Inicio <= Fecha Fin
				if(!Checks.esNulo(fechaInicioPMA) && 
						!Checks.esNulo(fechaFinPMA) &&
						(fechaInicioPMA.after(fechaFinPMA))){
					if (!listaFilas.contains(i))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}

	private List<Integer> getFechaInicioDescuentoAprobIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
		Date fechaInicioPDA = null;
		Date fechaFinPDA = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){

				fechaInicioPDA = ft.parse(exc.dameCelda(i, 2));
				fechaFinPDA = ft.parse(exc.dameCelda(i, 3));
				
				//Fecha Inicio <= Fecha Fin
				if(!Checks.esNulo(fechaInicioPDA) && 
						!Checks.esNulo(fechaFinPDA) &&
						(fechaInicioPDA.after(fechaFinPDA))){
					if (!listaFilas.contains(i))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}

	private List<Integer> getFechaInicioDescuentoPubIncorrectaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
		Date fechaInicioPDP = null;
		Date fechaFinPDP = null;
		
		// Validacion que evalua si las fechas de precios estan dentro de los límites
		try{
			for(int i=1; i<exc.getNumeroFilas();i++){

				fechaInicioPDP = ft.parse(exc.dameCelda(i, 2));
				fechaFinPDP = ft.parse(exc.dameCelda(i, 3));
				
				//Fecha Inicio <= Fecha Fin
				if(!Checks.esNulo(fechaInicioPDP) && 
						!Checks.esNulo(fechaFinPDP) &&
						(fechaInicioPDP.after(fechaFinPDP))){
					if (!listaFilas.contains(i))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
}