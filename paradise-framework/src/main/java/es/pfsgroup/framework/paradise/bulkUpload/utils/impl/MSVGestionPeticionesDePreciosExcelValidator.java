package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
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
public class MSVGestionPeticionesDePreciosExcelValidator extends MSVExcelValidatorAbstract {

	private static final String SEPARATOR = ", ";

	public static final String ACTIVO_INEXISTENTE = "El activo introducido no existe.";
	public static final String CODIGO_PETICION_NO_EXISTE = "El código de Petición no existe.";
	public static final String CODIGO_PETICION_NO_EDITABLE = "Petición de Precios no editable";
	public static final String TIPO_PETICION_NO_EXISTE = "El tipo de petición introducido no existe";
	
	public static final class COL_NUM {
		static final int FILA_CABECERA = 2;
		static final int DATOS_PRIMERA_FILA = 3;

		static final int NUM_ACTIVO_HAYA = 0;
		static final int COD_PETICION = 1;
		static final int COD_TIPO_PETICION = 2;
		static final int FECHA_SOLICITUD = 3;
		static final int FECHA_SANCION = 4;
		static final int OBSERVACIONES = 5;
	}
	
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
	
	protected final Log logger = LogFactory.getLog(getClass());
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
			logger.error(e.getMessage(), e);
		}
		if (Boolean.FALSE.equals(dtoValidacionContenido.getFicheroTieneErrores())) {
			Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
			
			List<Integer> activosInextistentes = isActiveExistsRows(exc);
			mapaErrores.put(ACTIVO_INEXISTENTE, activosInextistentes);
			mapaErrores.put(CODIGO_PETICION_NO_EDITABLE, esPeticionEditable(exc));
			mapaErrores.put(TIPO_PETICION_NO_EXISTE, esTipoPeticionExistente(exc));
			
			if (!mapaErrores.get(ACTIVO_INEXISTENTE).isEmpty() || !mapaErrores.get(CODIGO_PETICION_NO_EDITABLE).isEmpty() 
					|| !mapaErrores.get(TIPO_PETICION_NO_EXISTE).isEmpty()) {
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
	
	
	private List<Integer> isActiveExistsRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		int i = 0;
		try {
			for (i=1; i<this.numFilasHoja;i++) {
				if (Boolean.FALSE.equals(particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA))))
					listaFilas.add(i);
			}
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (IOException e) {
			logger.error(e.getMessage(),e);
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error(e.getMessage(),e);
			listaFilas.add(i);
		}

		return listaFilas;
	}
	
	private List<Integer> esPeticionEditable(MSVHojaExcel exc){
	List<Integer> listaFilas = new ArrayList<Integer>();
	String codPeticion = "";
	String numActivo = "";
	
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				codPeticion = exc.dameCelda(i, COL_NUM.COD_PETICION);
				numActivo = exc.dameCelda(i, COL_NUM.NUM_ACTIVO_HAYA);
				
				if(Boolean.FALSE.equals(particularValidator.esPeticionEditable(codPeticion, numActivo)))
					listaFilas.add(i);
					
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
		
	}
	
	private List<Integer> esTipoPeticionExistente(MSVHojaExcel exc) {
		
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				if(Boolean.FALSE.equals(particularValidator.existeTipoPeticion(exc.dameCelda(i, COL_NUM.COD_TIPO_PETICION))))
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
