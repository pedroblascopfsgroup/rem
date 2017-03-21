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
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;


@Component
public class MSVAltaActivosExcelValidator extends MSVExcelValidatorAbstract {
		
	//Textos con errores de validacion
	public static final String ACTIVE_EXISTS = "El activo existe.";
	
	//Posicion fija de Columnas excel, para cualquier referencia por posicion
	public static final class COL_NUM {
		static final int DATOS_PRIMERA_FILA				= 4;
		
		static final int NUM_ACTIVO_HAYA 				= 0;
		static final int COD_CARTERA 					= 1;
		static final int NUM_ACTIVO_CARTERA				= 2;  //(UVEM, PRINEX, SAREB)
		static final int NUM_BIEN_RECOVERY				= 3;
		static final int ID_ASUNTO_RECOVERY				= 4;
		static final int TIPO_ACTIVO					= 5;
		static final int SUBTIPO_ACTIVO					= 6;
		static final int ESTADO_FISICO					= 7;
		static final int USO_DOMINANTE					= 8;
		static final int DESC_ACTIVO					= 9;

		static final int TIPO_VIA						= 10;
		static final int NOMBRE_VIA						= 11;
		static final int NUM_VIA 						= 12;
		static final int ESCALERA 						= 13;
		static final int PLANTA 						= 14;
		static final int PUERTA 						= 15;
		static final int PROVINCIA 						= 16;
		static final int MUNICIPIO 						= 17;
		static final int UNIDAD_MUNICIPIO 				= 18;
		static final int CODPOSTAL 						= 19;

 		static final int TIPO_COMER 					= 20;
 		static final int DESTINO_COMER 					= 21;
 		static final int TIPO_ALQUILER 					= 22;

 		static final int NUM_EXP_RIESGO_ASOCIADO		= 23;
 		static final int ESTADO_EXP_RIESGO 				= 24;
 		static final int TIPO_PRODUCTO					= 25;
 		static final int NIF_SOCIEDAD_ACREEDORA			= 26;
 		static final int NOMBRE_SOCIEDAD_ACREEDORA		= 27;
 		static final int NUM_SOCIEDAD_ACREEDORA			= 28;
 		static final int IMPORTE_DEUDA 					= 29;

 		static final int PROV_REGISTRO 					= 30;
 		static final int POBL_REGISTRO 					= 31;
 		static final int NUM_REGISTRO 					= 32;
 		static final int TOMO 							= 33;
 		static final int LIBRO 							= 34;
 		static final int FOLIO 							= 35;
 		static final int FINCA 							= 36;
 		static final int IDUFIR_CRU 					= 37;
 		static final int SUPERFICIE_CONSTRUIDA_M2 		= 38;
 		static final int SUPERFICIE_UTIL_M2 			= 39;
 		static final int SUPERFICIE_REPERCUSION_EE_CC 	= 40;
 		static final int PARCELA 						= 41; // (INCLUIDA OCUPADA EDIFICACI�N)
 		static final int ES_INTEGRADO_DIV_HORIZONTAL	= 42;

 		static final int NIF_PROPIETARIO 				= 43;
 		static final int NOMBRE_PROPIETARIO 			= 44;
 		static final int GRADO_PROPIEDAD 				= 45;
 		static final int PERCENT_PROPIEDAD 				= 46;

 		static final int REF_CATASTRAL 					= 47;
 		static final int VPO 							= 48;

 		static final int VIVIENDA_NUM_PLANTAS 			= 49;
 		static final int VIVIENDA_NUM_BANYOS 			= 50;
 		static final int VIVIENDA_NUM_ASEOS 			= 51;
 		static final int VIVIENDA_NUM_DORMITORIOS 		= 52;
		static final int ES_LOCAL_CON_GARAJE_TRASTERO 	= 53;
	};

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
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Resource
    MessageService messageServices;
	

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
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
			mapaErrores.put(ACTIVE_EXISTS, isActiveExistsRows(exc));
			
			try{
				if(!mapaErrores.get(ACTIVE_EXISTS).isEmpty() ){
					
					dtoValidacionContenido.setFicheroTieneErrores(true);
					exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
					String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
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
	
	private File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return null;
	}
	
	private List<Integer> isActiveExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try{
			for(i=COL_NUM.DATOS_PRIMERA_FILA; i<exc.getNumeroFilas();i++){
				if(particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)))
					listaFilas.add(i);
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error(e.getMessage());
			listaFilas.add(i);
		}
		return listaFilas;
	}
	
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try{
			for(i=COL_NUM.DATOS_PRIMERA_FILA; i<exc.getNumeroFilas();i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA)))
					listaFilas.add(i);
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error(e.getMessage());
			listaFilas.add(i);
		}
		return listaFilas;
	}
	
}