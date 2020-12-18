package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
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


@Component
public class MSVActualizarPorcentajeConstruccion extends MSVExcelValidatorAbstract {
		
	//Textos con errores de validacion y Validaciones Globales
	public static final String ACTIVE_AND_PORCENTAJE_ARE_NULL = "Faltan datos obligatorios.";
	
	//Validaciones Línea
	public static final String NUM_ACTIVE_NOT_EXISTS ="Activo inexistente.";
	public static final String ACTIVO_FUERA_PERIMETRO_HAYA = "Activo no está en perímetro HAYA.";
	public static final String ACTIVO_UNIDAD_ALQUILABLE = "El activo es una unidad alquilable.";
	public static final String PORCENTAJE_CONSTRUCCION_INCORRECTO = "% Construcción incorrecto.";	
	public static final String PORCENTAJE_CONSTRUCCION_NO_DECIMAL = "% Construcción no es un número decimal.";	

	//Posicion fija de Columnas excel, para validaciones especiales de diccionario
	public static final int COL_NUM_ACTIVO = 0;
	public static final int COL_PORCENTAJE_CONSTRUCCION = 1;

    protected final Log logger = LogFactory.getLog(getClass());
    
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
	
	@Resource
    MessageService messageServices;
	
	private Integer numFilasHoja;
	

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getRuta());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion()));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getRuta());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
				Map<String,List<Integer>> mapaErrores = new HashMap<String,List<Integer>>();
				mapaErrores.put(ACTIVE_AND_PORCENTAJE_ARE_NULL, isColumnNullByRows(exc));
				mapaErrores.put(NUM_ACTIVE_NOT_EXISTS, isActiveNotExistsRows(exc));
				mapaErrores.put(ACTIVO_FUERA_PERIMETRO_HAYA, activosFueraPerimetroRows(exc));
				mapaErrores.put(ACTIVO_UNIDAD_ALQUILABLE, activosUnidadAlquilableRows(exc));
				mapaErrores.put(PORCENTAJE_CONSTRUCCION_INCORRECTO, porcentajeConstruccionIncorrectoRows(exc));
				mapaErrores.put(PORCENTAJE_CONSTRUCCION_NO_DECIMAL, porcentajeNumrico(exc));

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
	
	private List<Integer> porcentajeNumrico(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if (!StringUtils.isNumeric(exc.dameCelda(i, COL_PORCENTAJE_CONSTRUCCION)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> isColumnNullByRows(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if (Checks.esNulo(exc.dameCelda(i, COL_NUM_ACTIVO)) && Checks.esNulo(exc.dameCelda(i, COL_PORCENTAJE_CONSTRUCCION)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
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
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
		
	private List<Integer> activosFueraPerimetroRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.esActivoIncluidoPerimetro(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> activosUnidadAlquilableRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(particularValidator.esUnidadAlquilable(exc.dameCelda(i, 0)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
	
	private List<Integer> porcentajeConstruccionIncorrectoRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			String porcentajeConstruccion = null;
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_PORCENTAJE_CONSTRUCCION)))
						porcentajeConstruccion = exc.dameCelda(i, COL_PORCENTAJE_CONSTRUCCION);
						Double d = Double.valueOf(porcentajeConstruccion);
						if (!(d >= 0.0 && d <= 100.0)) {
							listaFilas.add(i);
						}
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (Exception e) {
			listaFilas.add(0);
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return listaFilas;
	}
}