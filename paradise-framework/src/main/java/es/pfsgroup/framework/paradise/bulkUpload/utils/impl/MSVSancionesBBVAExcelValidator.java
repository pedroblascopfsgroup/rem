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
import es.pfsgroup.commons.utils.Checks;
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
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVAltaActivosExcelValidator.COL_NUM;

@Component
public class MSVSancionesBBVAExcelValidator extends MSVExcelValidatorAbstract {

	private static final String SEPARATOR = ", ";

	public static final String OFERTA_INEXISTENTE = "Oferta inexistente.";
	public static final String OFERTA_BBVA = "Oferta no BBVA";
	public static final String OFERTA_ANULADA = "Oferta anulada";
	public static final String OFERTA_VENDIDA = "Oferta vendida";
	public static final String OFERTA_ERRONEA = "Oferta erronea";
	public static final String OFERTA_VACIA = "Oferta erronea";
	public static final String FECHA_RESPUESTA_COMITE_VACIA = "La fecha no puede estar vacío.";
	public static final String CODIGO_RESOLUCION_COMITE_VACIO = "El código de resolución comité no puede estar vacío.";
	public static final String IMPORTE_CONTRAOFERTA_VACIO = "El importe de la contraoferta no puede estar vacío";
	public static final String CODIGO_RESOLUCION_COMITE_CONTRAOFERTA = "";
	
	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;

		static final int NUM_OFERTA_BBVA = 0;
		static final int FECHA_RESPUESTA_COMITE = 1;
		static final int RESOLUCION_COMITE = 2;
		static final int IMPORTE_CONTRAOFERTA = 3;
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
			
			//mapaErrores.put(OFERTA_VACIA, isColumnNullByRows(exc, COL_NUM.NUM_OFERTA_BBVA));
			mapaErrores.put(OFERTA_INEXISTENTE, isOfertaExistsRows(exc));
			mapaErrores.put(OFERTA_BBVA, isOfertaBBVARows(exc));
			mapaErrores.put(OFERTA_ANULADA, esOfertaAnuladaRows(exc));
			mapaErrores.put(OFERTA_VENDIDA, esOfertaVendida(exc));
			mapaErrores.put(OFERTA_ERRONEA, esOfertaErronea(exc));
			//mapaErrores.put(FECHA_RESPUESTA_COMITE_VACIA, isColumnNullByRows(exc, COL_NUM.FECHA_RESPUESTA_COMITE));
			//mapaErrores.put(CODIGO_RESOLUCION_COMITE_VACIO, isColumnNullByRows(exc, COL_NUM.RESOLUCION_COMITE));
			//Si es contraoferta y el importe esta vacio se añade el error
			mapaErrores.put(IMPORTE_CONTRAOFERTA_VACIO, esContraofertaAndImporteVacio(exc));
	
			
			if (!mapaErrores.get(OFERTA_INEXISTENTE).isEmpty()
					|| !mapaErrores.get(OFERTA_BBVA).isEmpty()  
					|| !mapaErrores.get(OFERTA_ANULADA).isEmpty()
					|| !mapaErrores.get(OFERTA_VENDIDA).isEmpty() 
					|| !mapaErrores.get(OFERTA_ERRONEA).isEmpty()
					|| !mapaErrores.get(IMPORTE_CONTRAOFERTA_VACIO).isEmpty()) {
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
	
	
	private List<Integer> isOfertaExistsRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String numOferta = "";
		int i = 0;
		try {
			for (i=1; i<this.numFilasHoja;i++) {
				numOferta = exc.dameCelda(i, COL_NUM.NUM_OFERTA_BBVA);
				if (Boolean.FALSE.equals(particularValidator.existeOferta(numOferta)))
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
	
	private List<Integer> isOfertaBBVARows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String numOferta = "";
		int i = 0;
		try {
			for (i=1; i<this.numFilasHoja;i++) {
				numOferta = exc.dameCelda(i, COL_NUM.NUM_OFERTA_BBVA);
				if (Boolean.FALSE.equals(particularValidator.esOfertaBBVA(numOferta))) {
					if (particularValidator.existeOferta(numOferta))
					listaFilas.add(i);
				}
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
	
	
	
	
	private List<Integer> esOfertaAnuladaRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		String numOferta = "";	
			int i = 0;
			try {
				for(i=1; i<this.numFilasHoja;i++){
					numOferta = exc.dameCelda(i, COL_NUM.NUM_OFERTA_BBVA);
					if(Boolean.TRUE.equals(particularValidator.esOfertaAnulada(numOferta)))
						listaFilas.add(i);
				}
			} catch (Exception e) {
				if (i != 0) listaFilas.add(i);
				logger.error(e.getMessage());
				e.printStackTrace();
			}
			
			return listaFilas;
		}
	
	
	private List<Integer> esOfertaVendida(MSVHojaExcel exc) {
		
		List<Integer> listaFilas = new ArrayList<Integer>();
		String numOferta = "";
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				numOferta = exc.dameCelda(i, COL_NUM.NUM_OFERTA_BBVA);
				if(Boolean.TRUE.equals(particularValidator.esOfertaVendida(numOferta)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
private List<Integer> esOfertaErronea(MSVHojaExcel exc) {
		
		List<Integer> listaFilas = new ArrayList<Integer>();
		String numOferta = "";
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++){
				numOferta = exc.dameCelda(i, COL_NUM.NUM_OFERTA_BBVA);
				if(Boolean.TRUE.equals(particularValidator.esOfertaErronea(numOferta)))
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
 * Método genérico para comprobar si el valor de una columna está informado
 * o no.
 * 
 * @param exc
 *            : documento excel con los datos.
 * @param columnNumber
 *            : número de columna a comprobar.
 * @return Devuelve una lista con los errores econtrados. Tantos registros
 *         como errores.
 */
private List<Integer> isColumnNullByRows(MSVHojaExcel exc, int columnNumber) {
	List<Integer> listaFilas = new ArrayList<Integer>();

	for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
		try {
			if (Checks.esNulo(exc.dameCelda(i, columnNumber))) {
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
	}

	return listaFilas;
}


private List<Integer> esContraoferta(MSVHojaExcel exc) {
	
	List<Integer> listaFilas = new ArrayList<Integer>();
	String resolucionComite = "";
	int i = 0;
	try {
		for(i=1; i<this.numFilasHoja;i++){
			resolucionComite = exc.dameCelda(i, COL_NUM.RESOLUCION_COMITE);
			if("03".equals(resolucionComite)) 
				listaFilas.add(i);
		}
	} catch (Exception e) {
		if (i != 0) listaFilas.add(i);
		logger.error(e.getMessage());
		e.printStackTrace();
	}
	
	return listaFilas;
}


private List<Integer> esContraofertaAndImporteVacio(MSVHojaExcel exc) {
	
	List<Integer> listaFilas = new ArrayList<Integer>();
	String importe = "";
	String resolucionComite = "";
	int i = 0;
	try {
		for(i=1; i<this.numFilasHoja;i++){
			importe = exc.dameCelda(i, COL_NUM.IMPORTE_CONTRAOFERTA);
			resolucionComite = exc.dameCelda(i, COL_NUM.RESOLUCION_COMITE);
			if("03".equals(resolucionComite) && Checks.esNulo(importe)) 
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
