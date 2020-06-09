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
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVSuperGestEcoTrabajosExcelValidator.COL_NUM;

@Component
public class MSVBorradoTrabajosValidator extends MSVExcelValidatorAbstract {
		
	public static final String TRABAJO_NO_EXISTE = "El trabajo no existe.";
//	public static final String TRAMITE_TRABAJO_NO_EXISTE = "El trámite del trabajo no existe";
//	public static final String TRABAJO_SIN_TAREA = "El trabajo no tiene ninguna tarea creada.";
	public static final String COLUMNA_CON_CODIGO_REPETIDO = "El código del trabajo está duplicado en la columna.";
	public static final String COL_A_B_INCORRECTA = "La columna ANULAR/BORRAR solo puede ser: 'A' o 'B' (sin las comillas)";
	public static final int COL_NUM_TRABAJO = 0;
	public static final int COL_SIN_COD_REPETIDOS = 0;
	public static final int COL_ANULAR_BORRAR = 1;
	
	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
//	@Autowired
//	private ApiProxyFactory proxyFactory;
	
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
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage() ,e);
		}
		
		if (Boolean.FALSE.equals(dtoValidacionContenido.getFicheroTieneErrores())) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(TRABAJO_NO_EXISTE, isWorkNotExistsRows(exc));
			//mapaErrores.put(TRAMITE_TRABAJO_NO_EXISTE, existeTramiteTrabajo(exc));
			//mapaErrores.put(TRABAJO_SIN_TAREA, hayTareasEnTrabajo(exc));
			mapaErrores.put(COLUMNA_CON_CODIGO_REPETIDO, hayCodigosRepetidos(exc));
			mapaErrores.put(COL_A_B_INCORRECTA, anularBorrarIncorrecto(exc));
			if (Boolean.FALSE.equals(mapaErrores.get(TRABAJO_NO_EXISTE).isEmpty())
//					|| Boolean.FALSE.equals(mapaErrores.get(TRAMITE_TRABAJO_NO_EXISTE).isEmpty())
//					|| Boolean.FALSE.equals(mapaErrores.get(TRABAJO_SIN_TAREA).isEmpty())
					|| Boolean.FALSE.equals(mapaErrores.get(COLUMNA_CON_CODIGO_REPETIDO).isEmpty())
					|| Boolean.FALSE.equals(mapaErrores.get(COL_A_B_INCORRECTA).isEmpty())) {
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
	
		
    private List<Integer> isWorkNotExistsRows(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();
        
        try{
            for(int i=1; i<this.numFilasHoja;i++){
                try {
                    if(Boolean.FALSE.equals(particularValidator.existeTrabajo(exc.dameCelda(i, COL_NUM_TRABAJO))))
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
    
	/*
	private List<Integer> existeTramiteTrabajo(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(Boolean.FALSE.equals(Checks.esNulo(exc.dameCelda(i, COL_NUM_TRABAJO)))
						&& Boolean.FALSE.equals(particularValidator.existeTramiteTrabajo((exc.dameCelda(i, COL_NUM_TRABAJO))))
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
	
	private List<Integer> hayTareasEnTrabajo(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(Boolean.FALSE.equals(Checks.esNulo(exc.dameCelda(i, COL_NUM_TRABAJO)))
						&& Boolean.FALSE.equals(particularValidator.existenTareasEnTrabajo((exc.dameCelda(i, COL_NUM_TRABAJO))))
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
	*/
	
	private List<Integer> hayCodigosRepetidos(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();
        List<String> listaCodigos = new ArrayList<String>();
        String codigo = null;
        try{
            for(int i=1; i<this.numFilasHoja;i++){
                try {
                    codigo = exc.dameCelda(i, COL_SIN_COD_REPETIDOS);
                    if(Boolean.FALSE.equals(Checks.esNulo(codigo))
                        && listaCodigos.contains(codigo)
                    )
                        listaFilas.add(i);
                    else
                        listaCodigos.add(codigo);
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

	private List<Integer> anularBorrarIncorrecto(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();
        try{
            for(int i=1; i<this.numFilasHoja;i++){
                try {
                	String valor = exc.dameCelda(i, COL_ANULAR_BORRAR);
                	if(!"B".equals(valor) && 
                			!"A".equals(valor) &&
                			!"b".equals(valor) && 
                			!"a".equals(valor)) {
                		listaFilas.add(i);
                	}
                } catch (ParseException e) {
                    listaFilas.add(i);
                } catch (IOException e) {
                	listaFilas.add(i);
				}
            }
        } catch (IllegalArgumentException e) {
            listaFilas.add(0);
            logger.error(e);
        }
        return listaFilas;
    }
	
}
