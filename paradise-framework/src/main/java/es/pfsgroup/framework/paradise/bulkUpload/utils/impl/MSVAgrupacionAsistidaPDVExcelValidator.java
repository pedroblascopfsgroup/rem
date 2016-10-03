package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelRepoApi;
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

@Component
public class MSVAgrupacionAsistidaPDVExcelValidator extends MSVExcelValidatorAbstract {
	
	public static final String ACTIVO_NO_EXISTE = "Activo no encontrado con este número de activo";
	public static final String ACTIVO_EN_AGRUPACION = "El Activo ya está incluido en la agrupación";
	public static final String ACTIVE_NOT_SHARING_PLACE = "Todos los activos no comparten la misma PROVINCIA, MUNICIPIO, CP y CARTERA.";
	public static final String ACTIVO_NO_INCLUIDO_PERIMETRO = "El activo no está incluido en perímetro";
	
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
			mapaErrores.put(ACTIVO_NO_EXISTE, activesNotExistsRows(exc));
			mapaErrores.put(ACTIVO_EN_AGRUPACION, activosEnAgrupacionRows(exc));
			mapaErrores.put(ACTIVE_NOT_SHARING_PLACE, activesNotSharingPlaceRows(exc));
			mapaErrores.put(ACTIVO_NO_INCLUIDO_PERIMETRO, activosNoIncluidosPerimetroRows(exc));
						
			try{
				if(!mapaErrores.get(ACTIVO_NO_EXISTE).isEmpty() ||
						!mapaErrores.get(ACTIVO_EN_AGRUPACION).isEmpty() ||
						!mapaErrores.get(ACTIVE_NOT_SHARING_PLACE).isEmpty() ||
						!mapaErrores.get(ACTIVO_NO_INCLUIDO_PERIMETRO).isEmpty() ){
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
			e.printStackTrace();
		}
		return null;
	}
	
	private List<Integer> activesNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try{
			for(i=1; i<exc.getNumeroFilas();i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, 1)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosEnAgrupacionRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		Long idActivo;
		Long idAgrupacion;
		int i = 0;
		try {
			for(i=1; i<exc.getNumeroFilas();i++){
				idAgrupacion = Long.parseLong(exc.dameCelda(i, 0));
				idActivo = Long.parseLong(exc.dameCelda(i, 1));
				if(!particularValidator.esActivoEnAgrupacion(idActivo, idAgrupacion))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activesNotSharingPlaceRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		String numAgrupRemAnterior = new String(); //Numero de agrupacion recogido cada vez que cambie
		String numAgrupRem = new String(); //Numero de agrupacion que tiene cada fila
		
		try{
			for(i=1; i<exc.getNumeroFilas();i++){
				numAgrupRem = exc.dameCelda(i, 0);
				if(!numAgrupRemAnterior.equals(numAgrupRem)){
					// Solo cuando haya un cambio de cartera en las filas, volvemos a realizar validacion
					if(!particularValidator.esMismaCarteraLocationByNumAgrupRem(numAgrupRem))
						listaFilas.add(i);
					numAgrupRemAnterior = numAgrupRem;
				}
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> activosNoIncluidosPerimetroRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<exc.getNumeroFilas();i++){
				if(!particularValidator.esActivoIncluidoPerimetro(exc.dameCelda(i, 1)))
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
