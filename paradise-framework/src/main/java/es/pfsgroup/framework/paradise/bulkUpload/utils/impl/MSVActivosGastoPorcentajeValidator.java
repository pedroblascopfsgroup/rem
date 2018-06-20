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
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
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
public class MSVActivosGastoPorcentajeValidator extends MSVExcelValidatorAbstract{
	public static final String ACTIVE_NOT_EXISTS = "El activo no existe.";
	public static final String GASTO_NOT_EXISTS = "El gasto no existe.";
	public static final String ACTIVO_GASTO_NO_RELACION = "El activo y el gasto no están relacionados.";
	public static final String PORCENTAJE_SUPERIOR_100 = "El porcentaje es superior a 100.";
	public static final String PORCENTAJE_INFERIOR_100 = "El porcentaje es inferior a 100.";
	public static final String NO_TODOS_ACTIVOS = "Deben estar todos los activos relacionados con el gasto.";
	public static final String MAS_DE_UN_GASTO = "No puede haber mas de un gasto por carga masiva.";

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
	
	private static final Integer MAXGASTOS = 1;

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

				List<Integer> gastosRegistrados = gastosExcel(exc);
				List<Integer> gastosRegistradosNum = new ArrayList<Integer>();
				
				if(MAXGASTOS != gastosRegistrados.size()){
					gastosRegistradosNum.add(1);
				}	
				
				mapaErrores.put(ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
				mapaErrores.put(GASTO_NOT_EXISTS, isGastoNotExistsRows(exc));
				mapaErrores.put(ACTIVO_GASTO_NO_RELACION, isRelacionActivoGastoNotExistsRows(exc));
				mapaErrores.put(PORCENTAJE_SUPERIOR_100, isPorcentajeSuperiorA100(exc));
				mapaErrores.put(PORCENTAJE_INFERIOR_100, isPorcentajeInferiorA100(exc));
				mapaErrores.put(NO_TODOS_ACTIVOS, isTodosActivosDelGasto(exc));
				mapaErrores.put(MAS_DE_UN_GASTO, gastosRegistradosNum);
				
			if (!mapaErrores.get(MAS_DE_UN_GASTO).isEmpty() 
					|| !mapaErrores.get(ACTIVE_NOT_EXISTS).isEmpty() 
					|| !mapaErrores.get(GASTO_NOT_EXISTS).isEmpty()
					|| !mapaErrores.get(ACTIVO_GASTO_NO_RELACION).isEmpty() 
					|| !mapaErrores.get(PORCENTAJE_SUPERIOR_100).isEmpty()
					|| !mapaErrores.get(PORCENTAJE_INFERIOR_100).isEmpty() 
					|| !mapaErrores.get(NO_TODOS_ACTIVOS).isEmpty()) {
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
	
	private List<Integer> isGastoNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.existeGasto(exc.dameCelda(i, 1)))
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
	
	private List<Integer> isRelacionActivoGastoNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.tienenRelacionActivoGasto(exc.dameCelda(i, 0), exc.dameCelda(i, 1)))
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
	
	private List<Integer> isPorcentajeSuperiorA100(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double porcentajeTotal = new Double(0);
		
		for(int i=1; i<this.numFilasHoja;i++){
			try{
				porcentajeTotal += Double.parseDouble(exc.dameCelda(i, 2));
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if(porcentajeTotal > 100.00){
			listaFilas.add(1);
		}
		
		return listaFilas;
	}
	
	private List<Integer> isPorcentajeInferiorA100(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double porcentajeTotal = new Double(0);
		
		for(int i=1; i<this.numFilasHoja;i++){
			try{
				porcentajeTotal += Double.parseDouble(exc.dameCelda(i, 2));
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if(porcentajeTotal < 100.00){
			listaFilas.add(1);
		}
		
		return listaFilas;
	}
	
	private List<Integer> gastosExcel(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		for(int i=1; i<this.numFilasHoja;i++){
			try {
				if(listaFilas.isEmpty()){
					listaFilas.add(Integer.parseInt(exc.dameCelda(i, 1)));
				}else if(!listaFilas.contains(Integer.parseInt(exc.dameCelda(i, 1)))){
					listaFilas.add(Integer.parseInt(exc.dameCelda(i, 1)));
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			} 
		}
		
		return listaFilas;
	}
	
	private List<Integer> isTodosActivosDelGasto(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		try{
		String numGasto = exc.dameCelda(1, 1);
		List<Long> numActivos = particularValidator.getRelacionGastoActivo(numGasto);
		for(int i=1; i<this.numFilasHoja; i++){
			if(!numActivos.contains(Long.parseLong(exc.dameCelda(i, 0)))){
				listaFilas.add(i);
			}
		}
		}catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return listaFilas;
	}
	
}
