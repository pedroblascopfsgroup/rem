package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
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
public class MSVOcultacionAlquiler extends MSVExcelValidatorAbstract{

	private static final String ACTIVE_NOT_EXISTS = "El activo no existe";
	private static final String ACTIVO_VENDIDO = "El activo está vendido";
	private static final String ACTIVO_NO_PUBLICABLE = "El activo no es publicable";
	private static final String ACTIVO_NO_COMERCIALIZABLE = "El activo no es comercializable";
	private static final String DESTINO_FINAL_NO_ALQUILER = "El destino comercial no es alquiler";
	private static final String ACTIVO_NO_PUBLICADO = "El activo no está publicado en Alquiler";
	private static final String ACTIVO_OCULTO = "El activo esta oculto";
	private static final String MOTIVO_NOT_EXISTS = "El motivo de la ocultación no existe";
	private static final String MOTIVO_TEXTO_LIBRE_SUPERA_LIMITE = "El texto libre del motivo de ocultación supera el máximo permitido de 250 carácteres";
	private static final String MOTIVO_CODIGO_OCULTACION_NO_ESTA_DEFINIDO = "El código indicado para la ocultación no se encuentra entre los definidos";
	private static final String AGRUPACION_ACTIVO_NO_PUBLICABLE = "Hay activos no publicables";
	private static final String AGRUPACION_ACTIVO_NO_COMERCIALIZABLE = "Hay activos no comercializables";
	private static final String AGRUPACION_DESTINO_FINAL_NO_ALQUILER = "Hay activos cuyo destino comercial no es alquiler";
	private static final String AGRUPACION_ACTIVO_OCULTO = "Hay activos que están ocultos";
	private static final String NO_ES_ACTIVO_PRINCIPAL = "El activo no es el activo principal de la agrupación restringida";
	private static final String AGRUPACION_RESTRINGIDA = "02";
	

	private static final Integer MAX_CHAR_TEXTO_LIBRE = 250;

	public static final class COL_NUM {
		static final int NUM_ACTIVO_HAYA = 0;
		static final int MOTIVO_OCULTACION = 1;
		static final int DESCRIPCION_MOTIVO = 2;
	}

	@Autowired
	private MSVBusinessValidationRunner validationRunner;

	protected final Log logger = LogFactory.getLog(getClass());

	private Integer numFilasHoja;

	@Autowired
	private MSVExcelParser excelParser;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private MSVBusinessValidationFactory validationFactory;

	@Autowired
	private MSVProcesoApi msvProcesoApi;

	@Autowired
	private ParticularValidatorApi particularValidator;

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
				}

		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
			
			mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
			mapaErrores.put(ACTIVO_VENDIDO, activosVendidosRows(exc));
			mapaErrores.put(MOTIVO_NOT_EXISTS, movitoNotExistsByRows(exc));
			mapaErrores.put(MOTIVO_TEXTO_LIBRE_SUPERA_LIMITE, isTextoLibreExcedeMaximoPermitido(exc));
			mapaErrores.put(MOTIVO_CODIGO_OCULTACION_NO_ESTA_DEFINIDO, isCodigoOcultacionEstaDefinido(exc));
			mapaErrores.put(ACTIVO_NO_PUBLICADO, activoNoPublicadoByRows(exc));
			mapaErrores.put(NO_ES_ACTIVO_PRINCIPAL, noEsActivoPrincipal(exc));
			mapaErrores.put(AGRUPACION_ACTIVO_NO_PUBLICABLE, agrupacionIsActivoNoPublicableByRows(exc));
			mapaErrores.put(AGRUPACION_ACTIVO_NO_COMERCIALIZABLE, agrupacionActivosNoComercializablesRows(exc));
			mapaErrores.put(AGRUPACION_DESTINO_FINAL_NO_ALQUILER, agrupacionDestinoFinalNoAlquilerByRows(exc));
			mapaErrores.put(AGRUPACION_ACTIVO_OCULTO, agrupacionActivoOcultoByRows(exc));
			mapaErrores.put(ACTIVO_NO_PUBLICABLE, isActivoNoPublicableByRows(exc));
			mapaErrores.put(ACTIVO_NO_COMERCIALIZABLE, activosNoComercializablesRows(exc));
			mapaErrores.put(DESTINO_FINAL_NO_ALQUILER, destinoFinalNoAlquilerByRows(exc));
			mapaErrores.put(ACTIVO_OCULTO, activoOcultoByRows(exc));

			Set<String> keySet = mapaErrores.keySet();			
			for (String key : keySet) {				
				if(!Checks.estaVacio(mapaErrores.get(key))) {
					dtoValidacionContenido.setFicheroTieneErrores(true);
					dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
					break;
				}
			}	
		}

		exc.cerrar();

		return dtoValidacionContenido;
	}

	@Override
	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda,
			MSVBusinessValidators contentValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);

		if ((contentValidators != null) && (contentValidators.getValidatorForColumn(nombreColumna.trim()) != null)) {
			MSVColumnValidator v = contentValidators.getValidatorForColumn(nombreColumna.trim());
			MSVValidationResult result = validationRunner.runValidation(v, contenidoCelda);
			resultado.setValido(result.isValid());
			resultado.setErroresFila(result.getErrorMessage());
		}

		return resultado;
	}


	/**
	 * Realiza validaciones multivalor con diferentes valores de la fila
	 *
	 * @param mapaDatos
	 * @param compositeValidators
	 * @return
	 */
	@Override
	protected ResultadoValidacion validaContenidoFila(Map<String, String> mapaDatos, List<String> listaCabeceras,
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

	private List<Integer> isCodigoOcultacionEstaDefinido(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				String codigoMotivo = exc.dameCelda(i, COL_NUM.MOTIVO_OCULTACION);
				if(!codigoMotivo.equalsIgnoreCase("09") && !codigoMotivo.equalsIgnoreCase("10") && !codigoMotivo.equalsIgnoreCase("11") &&
						!codigoMotivo.equalsIgnoreCase("12")) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
		}

		return listaFilas;
	}

	private List<Integer> isTextoLibreExcedeMaximoPermitido(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				String textoLibre = exc.dameCelda(i, COL_NUM.DESCRIPCION_MOTIVO);
				if(!textoLibre.isEmpty() && textoLibre.length() > MAX_CHAR_TEXTO_LIBRE) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
		}

		return listaFilas;
	}

	//metodos auxiliares

	 

	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)))
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

	private List<Integer> activosVendidosRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.esActivoVendido(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> activosNoComercializablesRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)), AGRUPACION_RESTRINGIDA)){
					if(particularValidator.isActivoNoComercializable(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA))){
						listaFilas.add(i);
					}
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> destinoFinalNoAlquilerByRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(!particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)), AGRUPACION_RESTRINGIDA)){
					if(particularValidator.destinoFinalNoAlquiler(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA))) listaFilas.add(i);
				}
			}
		}catch (Exception e){
			if (i!=0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> activoNoPublicadoByRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				if(particularValidator.isActivoNoPublicadoAlquiler(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA))) listaFilas.add(i);
			}
		}catch (Exception e){
			if(i!=0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> isActivoNoPublicableByRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja; i++){
				if(!particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)), AGRUPACION_RESTRINGIDA)){
					if(particularValidator.isActivoNoPublicable(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA))){
						listaFilas.add(i);
					}
				}
			}
		} catch (Exception e){
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> activoOcultoByRows(MSVHojaExcel exc){
		List <Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1;i<this.numFilasHoja;i++){
				if(!particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)), AGRUPACION_RESTRINGIDA)){
					if(particularValidator.activoOcultoAlquiler(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA))){
						listaFilas.add(i);
					}
				}
			}
		}catch (Exception e){
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> movitoNotExistsByRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1;i<this.numFilasHoja;i++){
				if(particularValidator.motivoNotExistsByCod(exc.dameCelda(i, COL_NUM.MOTIVO_OCULTACION))){
					listaFilas.add(i);
				}
			}
		} catch (Exception e){
			if (i !=0 ) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> agrupacionActivosNoComercializablesRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				String numAgrupacion = particularValidator.idAgrupacionDelActivoPrincipal(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA));
				if(particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)), AGRUPACION_RESTRINGIDA)){
					if(particularValidator.isActivoNoComercializableAgrupacion(numAgrupacion)){
						listaFilas.add(i);
					}
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> agrupacionDestinoFinalNoAlquilerByRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja;i++){
				String numAgrupacion = particularValidator.idAgrupacionDelActivoPrincipal(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA));
				if(particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)), AGRUPACION_RESTRINGIDA)){
					if(particularValidator.isActivoDestinoComercialNoAlquilerAgrupacion(numAgrupacion)) listaFilas.add(i);
				}
			}
		}catch (Exception e){
			if (i!=0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> agrupacionIsActivoNoPublicableByRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<this.numFilasHoja; i++){
				String numAgrupacion = particularValidator.idAgrupacionDelActivoPrincipal(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA));
				if(particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)), AGRUPACION_RESTRINGIDA)){
					if(particularValidator.isActivoNoPublicableAgrupacion(numAgrupacion)){
						listaFilas.add(i);
					}
				}
			}
		} catch (Exception e){
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}

	private List<Integer> agrupacionActivoOcultoByRows(MSVHojaExcel exc){
		List <Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1;i<this.numFilasHoja;i++){
				String numAgrupacion = particularValidator.idAgrupacionDelActivoPrincipal(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA));
				if(particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)), AGRUPACION_RESTRINGIDA)){
					if(!particularValidator.activosNoOcultosAlquilerAgrupacion(numAgrupacion)){
						listaFilas.add(i);
					}
				}
			}
		}catch (Exception e){
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}
	
	private List<Integer> noEsActivoPrincipal(MSVHojaExcel exc){
		List <Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1;i<this.numFilasHoja;i++){
				if((particularValidator.esActivoEnAgrupacionPorTipo(Long.parseLong(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)), AGRUPACION_RESTRINGIDA))
						&& !particularValidator.esActivoPrincipalEnAgrupacion(Long.parseLong(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)))){
						listaFilas.add(i);
					}
				}
			
		}catch (Exception e){
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	@Override
	public Integer getNumFilasHoja() {
		return this.numFilasHoja;
	}
	
}
