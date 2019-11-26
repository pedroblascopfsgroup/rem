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
public class MSVActualizacionFasesPublicacionValidator extends MSVExcelValidatorAbstract {
	
	public static final class INDICES {
		private INDICES() {}
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		static final int ACT_NUM_ACTIVO = 0;
		static final int FASE_PUBLICACION = 1;
		static final int SUBFASE_PUBLICACION = 2;
	};
	
	public static final String ACTIVO_NO_EXISTE = "El activo debe existir.";
	public static final String FASE_PUBLICACION_NO_EXISTE = "La fase de publicación no existe.";
	public static final String SUBFASE_PUBLICACION_NO_EXISTE = "La subfase de publicación no existe.";
	public static final String SUBFASE_PUBLICACION_ERRONEA = "La subfase de publicación no pertenece a la fase de publicación propuesta";
	public static final String CODIGO_FASES_PUBLICACION = "CMFP";
	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
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
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
		}
		
		if (Boolean.FALSE.equals(dtoValidacionContenido.getFicheroTieneErrores())) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(ACTIVO_NO_EXISTE, isActivoNotExistsRows(exc));
			mapaErrores.put(FASE_PUBLICACION_NO_EXISTE, isFasePublicacionNotExistsRows(exc));
			mapaErrores.put(SUBFASE_PUBLICACION_NO_EXISTE, isSubfasePublicacionNotExistsRows(exc));
			mapaErrores.put(SUBFASE_PUBLICACION_ERRONEA, perteneceFaseASubFasePublicacion(exc));

			if (Boolean.FALSE.equals(mapaErrores.get(ACTIVO_NO_EXISTE).isEmpty()) 
					|| Boolean.FALSE.equals(mapaErrores.get(FASE_PUBLICACION_NO_EXISTE).isEmpty())
					|| Boolean.FALSE.equals(mapaErrores.get(SUBFASE_PUBLICACION_NO_EXISTE).isEmpty())
					|| Boolean.FALSE.equals(mapaErrores.get(SUBFASE_PUBLICACION_ERRONEA).isEmpty())
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
			logger.error(e);
		}
		return null;
	}
		          
	private List<Integer> isActivoNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, INDICES.ACT_NUM_ACTIVO)) && !particularValidator.existeActivo(exc.dameCelda(i, INDICES.ACT_NUM_ACTIVO)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
			} catch (IllegalArgumentException e) {
				listaFilas.add(0);
				logger.error(e);
			} catch (IOException e) {
				listaFilas.add(0);
				logger.error(e);
			}
		return listaFilas;
	}
	
	private List<Integer> isFasePublicacionNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, INDICES.FASE_PUBLICACION)) && !particularValidator.existeFasePublicacion(exc.dameCelda(i, INDICES.FASE_PUBLICACION)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
			} catch (IllegalArgumentException e) {
				listaFilas.add(0);
				logger.error(e);
				
			} catch (IOException e) {
				listaFilas.add(0);
				logger.error(e);			
			}
		return listaFilas;
	}
	
	private List<Integer> isSubfasePublicacionNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
	
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, INDICES.SUBFASE_PUBLICACION)) && !particularValidator.existeSubfasePublicacion(exc.dameCelda(i, INDICES.SUBFASE_PUBLICACION)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
			} catch (IllegalArgumentException e) {
				listaFilas.add(0);
				logger.error(e);
			} catch (IOException e) {
				listaFilas.add(0);
				logger.error(e);
			}
		return listaFilas;
	}
	private List<Integer> perteneceFaseASubFasePublicacion(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(Boolean.FALSE.equals(Checks.esNulo(exc.dameCelda(i, INDICES.SUBFASE_PUBLICACION)))
							&& Boolean.FALSE.equals(particularValidator.existeSubfasePublicacion(exc.dameCelda(i, INDICES.SUBFASE_PUBLICACION)))
							&& Boolean.FALSE.equals(particularValidator.existeFasePublicacion(exc.dameCelda(i, INDICES.FASE_PUBLICACION)))
							&& Boolean.FALSE.equals(particularValidator.perteneceSubfaseAFasePublicacion(exc.dameCelda(i, INDICES.SUBFASE_PUBLICACION), exc.dameCelda(i, INDICES.FASE_PUBLICACION)))
							)
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			logger.error(e);
		} catch (IOException e) {
			listaFilas.add(0);
			logger.error(e);
		}
		return listaFilas;
	}
}
