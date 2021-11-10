package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelRepoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.*;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVMultiColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.dto.ResultadoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

@Component
public class MSVActualizadorPublicadoVentaExcelValidator extends MSVExcelValidatorAbstract {
		
	private static final String ACTIVO_NOT_EXISTS = "El activo no existe.";
	private static final String ACTIVO_VENDIDO = "Este activo está vendido";
	private static final String ACTIVO_NO_COMERCIALIZABLE = "Este activo no es comercializable";
	private static final String ACTIVO_NO_PUBLICABLE = "Este activo no es publicable";
	private static final String ACTIVO_OCULTO = "Este activo está oculto";
	private static final String ACTIVO_PUBLICADO = "Este activo está publicado";
	private static final String DESTINO_COMERCIAL_NO_VENTA = "Este activo no incluye el destino comercial de venta";
	private static final String ACTIVO_SIN_INFORME_NI_PRECIO = "Este activo no tiene informe aprobado ni precio";
	private static final String CAMPO_OCULTAR_PRECIO_FORMATO_NO_VALIDO = "El campo ocultar precio contiene un valor no válido";
	private static final String CAMPO_PUBLICAR_SIN_PRECIO_FORMATO_NO_VALIDO = "El campo publicar sin precio contiene un valor no válido";
	private static final String AGRUPACION_ACTIVO_NO_AGRUPACION_RESTRINGIDA_PRINCIPAL = "El activo no es el activo principal de una agrupación restringida";
	private static final String AGRUPACION_ACTIVO_NO_COMERCIALIZABLE = "Existen activos no comercializables en la agrupación";
	private static final String AGRUPACION_ACTIVO_NO_PUBLICABLE = "Existen activos no publicables en la agrupación";
	private static final String AGRUPACION_DESTINO_COMERCIAL_NO_VENTA = "Existen activos que no incluyen destino comercial de venta en la agrupación";
	private static final String AGRUPACION_ACTIVO_SIN_INFORME_NI_PRECIO = "Existen activos que no tienen informe aprobado ni precio en la agrupación";
	private static final String CODIGO_TIPO_AGRUPACION_RESTRINGIDA = "02";
	private static final Integer NUMERO_HOJA_DATOS = 0;

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
		
		//Validaciones especificas no contenidas en el fichero Excel de validación
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(NUMERO_HOJA_DATOS, operacionMasiva);
		} catch (Exception e) {
			logger.error("Error al procesar el excel de actualizador publicado venta", e);
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
			mapaErrores.put(ACTIVO_NOT_EXISTS, isActiveNotExistsRows(exc));
			mapaErrores.put(CAMPO_OCULTAR_PRECIO_FORMATO_NO_VALIDO, isCampoOcultarPrecioFormatoValidoRows(exc));
			mapaErrores.put(CAMPO_PUBLICAR_SIN_PRECIO_FORMATO_NO_VALIDO, isCampoPublicarSinPrecioFormatoValidoRows(exc));
			mapaErrores.put(ACTIVO_VENDIDO, activosVendidosRows(exc));
			mapaErrores.put(ACTIVO_OCULTO, isActivoOcultoVentaRows(exc));
			mapaErrores.put(ACTIVO_PUBLICADO, activoPublicadoRows(exc));
			mapaErrores.put(ACTIVO_NO_PUBLICABLE, activosNoPublicablesRows(exc));
			mapaErrores.put(ACTIVO_NO_COMERCIALIZABLE, activosNoComercializablesRows(exc));
			mapaErrores.put(DESTINO_COMERCIAL_NO_VENTA, activosDestinoComercialNoVentaRows(exc));
			mapaErrores.put(ACTIVO_SIN_INFORME_NI_PRECIO, activosSinInformeAprobadoNiPrecioOSinPublicarSinPrecioRows(exc));
			mapaErrores.put(AGRUPACION_ACTIVO_NO_AGRUPACION_RESTRINGIDA_PRINCIPAL, esActivoPrincipalEnAgrupacionRestringida(exc));
			mapaErrores.put(AGRUPACION_ACTIVO_NO_PUBLICABLE, activosAgrupacionNoPublicablesRows(exc));
			mapaErrores.put(AGRUPACION_ACTIVO_NO_COMERCIALIZABLE, activosAgrupacionNoComercializablesRows(exc));
			mapaErrores.put(AGRUPACION_DESTINO_COMERCIAL_NO_VENTA, activosAgrupacionDestinoComercialNoVentaRows(exc));
			mapaErrores.put(AGRUPACION_ACTIVO_SIN_INFORME_NI_PRECIO, activosAgrupacionSinInformeAprobadoNiPrecioOSinPublicarSinPrecioRows(exc));
			
			for (Entry<String, List<Integer>> registro : mapaErrores.entrySet()) {
			    if (!registro.getValue().isEmpty()) {
			        dtoValidacionContenido.setFicheroTieneErrores(true);
                    dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
                    break;
                }
		  }
		}		
		exc.cerrar();
		return dtoValidacionContenido;
	}

	private List<Integer> isCampoPublicarSinPrecioFormatoValidoRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!Checks.esNulo(exc.dameCelda(i, 2)) && !"s".equalsIgnoreCase(exc.dameCelda(i, 2)) && !"si".equalsIgnoreCase(exc.dameCelda(i, 2)) &&
						!"n".equalsIgnoreCase(exc.dameCelda(i, 2)) && !"no".equalsIgnoreCase(exc.dameCelda(i, 2))) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
		}

		return listaFilas;
	}

	private List<Integer> isCampoOcultarPrecioFormatoValidoRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!Checks.esNulo(exc.dameCelda(i, 1)) && !"s".equalsIgnoreCase(exc.dameCelda(i, 1)) && !"si".equalsIgnoreCase(exc.dameCelda(i, 1)) &&
						!"n".equalsIgnoreCase(exc.dameCelda(i, 1)) && !"no".equalsIgnoreCase(exc.dameCelda(i, 1))) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
			
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
			} catch (IllegalArgumentException e) {
				listaFilas.add(0);
				
			} catch (IOException e) {
				listaFilas.add(0);
				
			}
		return listaFilas;
	}
	
	private List<Integer> activosVendidosRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.esActivoVendido(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
			
		}
		
		return listaFilas;
	}

	private List<Integer> activosNoPublicablesRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if (!particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, 0)), CODIGO_TIPO_AGRUPACION_RESTRINGIDA)) {
					if(particularValidator.isActivoNoPublicable(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
			
		}

		return listaFilas;
	}
	
	private List<Integer> isActivoOcultoVentaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.isActivoOcultoVenta(exc.dameCelda(i, 0))){
					listaFilas.add(i);
				}
			}
		}catch (Exception e){
			if(i!=0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
		}
		return listaFilas;
	}
	
	private List<Integer> activoPublicadoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.isActivoDestinoComercialNoAlquiler(exc.dameCelda(i, 0))) {
					if(particularValidator.isActivoPublicadoVenta(exc.dameCelda(i, 0))) {
						listaFilas.add(i);
					}
				}
				
			}
		}catch (Exception e){
			if(i!=0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
			
		}
		return listaFilas;
	}

	private List<Integer> activosDestinoComercialNoVentaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if (!particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, 0)), CODIGO_TIPO_AGRUPACION_RESTRINGIDA)) {
					if(particularValidator.isActivoDestinoComercialNoVenta(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
			
		}

		return listaFilas;
	}

	private List<Integer> activosSinInformeAprobadoNiPrecioOSinPublicarSinPrecioRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if (!particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, 0)), CODIGO_TIPO_AGRUPACION_RESTRINGIDA)) {
					if(particularValidator.isActivoSinInformeAprobado(exc.dameCelda(i, 0)) &&
							!this.obtenerBooleanExcel(exc.dameCelda(i, 2)) && particularValidator.isActivoSinPrecioVentaWeb(exc.dameCelda(i, 0))) {
						listaFilas.add(i);
					}
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
		}

		return listaFilas;
	}

	/**
	 * Este método devuelve un objeto Boolean regulado de la celda excel.
	 *
	 * @param celdaExcel : valor Boolean de la celda excel a analizar.
	 * @return Devuelve False si la celda está vacía, True si el String es S/SI o False en cualquier otro caso.
	 */
	private Boolean obtenerBooleanExcel(String celdaExcel) {
		return !Checks.esNulo(celdaExcel) && (celdaExcel.equalsIgnoreCase("s") || celdaExcel.equalsIgnoreCase("si"));
	}

	private List<Integer> activosNoComercializablesRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if (!particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, 0)), CODIGO_TIPO_AGRUPACION_RESTRINGIDA)) {
					if(particularValidator.isActivoNoComercializable(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
			
		}
		
		return listaFilas;
	}
	
	private List<Integer> esActivoPrincipalEnAgrupacionRestringida(MSVHojaExcel exc){
		List<Integer> listFilas = new ArrayList<Integer>();
		int i = 0;

		try {
			for(i = 1; i < this.numFilasHoja; i++) {
				if ((particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, 0)), CODIGO_TIPO_AGRUPACION_RESTRINGIDA)) 
					&&!particularValidator.esActivoPrincipalEnAgrupacion(Long.parseLong(exc.dameCelda(i, 0)))){
						listFilas.add(i);
					}
				}
			
		} catch (Exception e) {
			throw new RuntimeException("No se ha podido comprobar si los activos están en otras agrupaciones restringidas", e);
		}
		
		return listFilas;
	}

	private List<Integer> activosAgrupacionNoPublicablesRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if (particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, 0)), CODIGO_TIPO_AGRUPACION_RESTRINGIDA)) {
					String idAgrupacion = particularValidator.idAgrupacionDelActivoPrincipal(exc.dameCelda(i, 0));
					if(particularValidator.isActivoNoPublicableAgrupacion(idAgrupacion))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
			
		}

		return listaFilas;
	}
	
	private List<Integer> activosAgrupacionDestinoComercialNoVentaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if (particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, 0)), CODIGO_TIPO_AGRUPACION_RESTRINGIDA)) {
					String idAgrupacion = particularValidator.idAgrupacionDelActivoPrincipal(exc.dameCelda(i, 0));
					if(particularValidator.isActivoDestinoComercialNoVentaAgrupacion(idAgrupacion))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
			
		}

		return listaFilas;
	}

	private List<Integer> activosAgrupacionSinInformeAprobadoNiPrecioOSinPublicarSinPrecioRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if (particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, 0)), CODIGO_TIPO_AGRUPACION_RESTRINGIDA)) {
					String idAgrupacion = particularValidator.idAgrupacionDelActivoPrincipal(exc.dameCelda(i, 0));
					if(particularValidator.isActivoSinInformeAprobadoAgrupacion(idAgrupacion) &&
							!this.obtenerBooleanExcel(exc.dameCelda(i, 2)) && particularValidator.isActivoSinPrecioVentaWebAgrupacion(idAgrupacion)) {
						listaFilas.add(i);
					}
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
		}

		return listaFilas;
	}
	
	private List<Integer> activosAgrupacionNoComercializablesRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if (particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, 0)), CODIGO_TIPO_AGRUPACION_RESTRINGIDA)) {
					String idAgrupacion = particularValidator.idAgrupacionDelActivoPrincipal(exc.dameCelda(i, 0));
					if(particularValidator.isActivoNoComercializableAgrupacion(idAgrupacion))
						listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error("error en MSVActualizadorPublicadoVentaExcelValidator", e);
			
		}
		
		return listaFilas;
	}

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
	
}
