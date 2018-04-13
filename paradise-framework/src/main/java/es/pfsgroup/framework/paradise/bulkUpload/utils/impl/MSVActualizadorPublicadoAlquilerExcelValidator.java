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

@Component
public class MSVActualizadorPublicadoAlquilerExcelValidator extends MSVExcelValidatorAbstract {
		
	private static final String ACTIVO_NOT_EXISTS = "El activo no existe.";
	private static final String ACTIVO_VENDIDO = "Este activo está vendido";
	private static final String ACTIVO_NO_COMERCIALIZABLE = "Este activo no es comercializable";
	private static final String ACTIVO_NO_PUBLICABLE = "Este activo no es publicable";
	private static final String DESTINO_COMERCIAL_NO_ALQUILER = "Este activo no incluye el destino comercial de alquiler";
	private static final String ACTIVO_SIN_PRECIO_ALQUILER = "Este activo no tiene asignado un precio de renta web";
	private static final String ACTIVO_SIN_INFORME_APROBADO = "Este activo no tiene el informe aprobado";
	private static final String CAMPO_OCULTAR_PRECIO_FORMATO_NO_VALIDO = "El campo ocultar precio contiene un valor no válido";
	private static final String CAMPO_PUBLICAR_SIN_PRECIO_FORMATO_NO_VALIDO = "El campo publicar sin precio contiene un valor no válido";

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
			logger.error("Error al procesar el excel de actualizador publicado alquiler", e);
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
			mapaErrores.put(CAMPO_OCULTAR_PRECIO_FORMATO_NO_VALIDO, isCampoOcultarPrecioFormatoValidoRows(exc));
			mapaErrores.put(CAMPO_PUBLICAR_SIN_PRECIO_FORMATO_NO_VALIDO, isCampoPublicarSinPrecioFormatoValidoRows(exc));
			mapaErrores.put(ACTIVO_NOT_EXISTS, isActiveNotExistsRows(exc));
			mapaErrores.put(ACTIVO_VENDIDO, activosVendidosRows(exc));
			mapaErrores.put(ACTIVO_NO_PUBLICABLE, activosNoPublicablesRows(exc));
			mapaErrores.put(ACTIVO_NO_COMERCIALIZABLE, activosNoComercializablesRows(exc));
			mapaErrores.put(DESTINO_COMERCIAL_NO_ALQUILER, activosDestinoComercialNoAlquilerRows(exc));
			mapaErrores.put(ACTIVO_SIN_INFORME_APROBADO, activosSinInformeAprobadoRows(exc));
			mapaErrores.put(ACTIVO_SIN_PRECIO_ALQUILER, activosSinPrecioRentaOSinPublicarSinPrecioRows(exc));

			if (!mapaErrores.get(CAMPO_OCULTAR_PRECIO_FORMATO_NO_VALIDO).isEmpty() || !mapaErrores.get(CAMPO_PUBLICAR_SIN_PRECIO_FORMATO_NO_VALIDO).isEmpty()
					|| !mapaErrores.get(ACTIVO_NOT_EXISTS).isEmpty() || !mapaErrores.get(ACTIVO_SIN_INFORME_APROBADO).isEmpty()
					|| !mapaErrores.get(ACTIVO_VENDIDO).isEmpty() || !mapaErrores.get(ACTIVO_NO_COMERCIALIZABLE).isEmpty()
					|| !mapaErrores.get(ACTIVO_NO_PUBLICABLE).isEmpty() || !mapaErrores.get(DESTINO_COMERCIAL_NO_ALQUILER).isEmpty()
					|| !mapaErrores.get(ACTIVO_SIN_PRECIO_ALQUILER).isEmpty()){
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

	private List<Integer> isCampoPublicarSinPrecioFormatoValidoRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!Checks.esNulo(exc.dameCelda(i, 2)) && (!"s".equalsIgnoreCase(exc.dameCelda(i, 2)) || !"si".equalsIgnoreCase(exc.dameCelda(i, 2)) ||
						!"n".equalsIgnoreCase(exc.dameCelda(i, 2)) || !"no".equalsIgnoreCase(exc.dameCelda(i, 2)))) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> isCampoOcultarPrecioFormatoValidoRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!Checks.esNulo(exc.dameCelda(i, 1)) && (!"s".equalsIgnoreCase(exc.dameCelda(i, 1)) || !"si".equalsIgnoreCase(exc.dameCelda(i, 1)) ||
						!"n".equalsIgnoreCase(exc.dameCelda(i, 1)) || !"no".equalsIgnoreCase(exc.dameCelda(i, 1)))) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
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
				e.printStackTrace();
			} catch (IOException e) {
				listaFilas.add(0);
				e.printStackTrace();
			}
		return listaFilas;
	}
	
	private List<Integer> isActiveSinCondicionesPublicableRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.isActivoPrePublicable(exc.dameCelda(i, 0))){
						listaFilas.add(i);
					}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			e.printStackTrace();
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
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}

	private List<Integer> activosNoPublicablesRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.isActivoNoPublicable(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> activosDestinoComercialNoAlquilerRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.isActivoDestinoComercialNoAlquiler(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> activosSinInformeAprobadoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.isActivoSinInformeAprobado(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> activosSinPrecioRentaOSinPublicarSinPrecioRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!this.obtenerBooleanExcel(exc.dameCelda(i, 2)) && particularValidator.isActivoSinPrecioRentaWeb(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
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
				if(particularValidator.isActivoNoComercializable(exc.dameCelda(i, 0)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
}
