package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.Checks;
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
public class MSVReclamacionesPlusvaliasExcelValidator extends MSVExcelValidatorAbstract {
	
	// Textos con errores de validacion
	public static final String ACTIVO_NO_EXISTE = "msg.error.masivo.activo.no.existe";
	public static final String ACTIVO_PERTENECE_UA = "msg.error.masivo.plusvalia.activo.pertenece.ua";
	public static final String GASTO_NO_EXISTE = "msg.error.masivo.plusvalia.gasto.no.existe";
	public static final String MINUSVALIA_NO_VALIDO_SN = "msg.error.masivo.plusvalia.minusvalia";
	public static final String APERTURA_EXP_NO_VALIDO = "msg.error.masivo.plusvalia.apertura.expediente.no.valido";
	public static final String EXENTO_NO_VALIDO_SN = "msg.error.masivo.plusvalia.exento";
	public static final String AUTOLIQUIDACION_NO_VALIDO_SN = "msg.error.masivo.plusvalia.autoliquidacion";
	public static final String ACCION_NO_VALIDA = "msg.error.masivo.plusvalia.accion.no.valido";
	private static final String REGISTRO_NO_EXISTE = "msg.error.masivo.control.tributos.registro.no.existe";
	private static final String REGISTRO_EXISTE = "msg.error.masivo.control.tributos.registro.existe";
	
	private static final int POSICION_COLUMNA_NUM_ACTIVO_HAYA = 0;
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final int POSICION_COLUMNA_FECHA_PLUSVALIA = 2;
	private static final int POSICION_COLUMNA_APERTURA_EXP = 5;
	private static final int POSICION_COLUMNA_GASTO = 7;
	private static final int POSICION_COLUMNA_MINUSVALIA = 8;
	private static final int POSICION_COLUMNA_EXENTO = 9;
	private static final int POSICION_COLUMNA_AUTOLIQUIDACION = 10;
	private static final int POSICION_COLUMNA_ACCION = 12;
	
	private static final String COD_SI = "S";
	private static final String COD_NO = "N";

	private List<Integer> listaFilasAccionNoValido;
	private List<Integer> listaFilasAccionActivoPlusvaliaExiste;
	private List<Integer> listaFilasAccionActivoPlusvaliaNoExiste;
	
	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Autowired
	private ExcelRepoApi excelRepoApi;
	
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
		} 
		catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			validarAccion(exc);
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), isActiveNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_PERTENECE_UA), esActivoUA(exc));
			mapaErrores.put(messageServices.getMessage(GASTO_NO_EXISTE), existeGasto(exc));
			mapaErrores.put(messageServices.getMessage(APERTURA_EXP_NO_VALIDO), existeAperturaExp(exc));
			mapaErrores.put(messageServices.getMessage(MINUSVALIA_NO_VALIDO_SN), existeMinusvalia(exc));
			mapaErrores.put(messageServices.getMessage(EXENTO_NO_VALIDO_SN), existeExento(exc));
			mapaErrores.put(messageServices.getMessage(AUTOLIQUIDACION_NO_VALIDO_SN), existeAutoliquidacion(exc));
			mapaErrores.put(messageServices.getMessage(ACCION_NO_VALIDA), listaFilasAccionNoValido);
			mapaErrores.put(messageServices.getMessage(REGISTRO_NO_EXISTE), listaFilasAccionActivoPlusvaliaNoExiste);
			mapaErrores.put(messageServices.getMessage(REGISTRO_EXISTE), listaFilasAccionActivoPlusvaliaExiste);

			for (Entry<String, List<Integer>> registro : mapaErrores.entrySet()) {
				if (!registro.getValue().isEmpty()) {
					dtoValidacionContenido.setFicheroTieneErrores(true);
					dtoValidacionContenido
							.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
				}
			}
		}
		
		exc.cerrar();
		
		return dtoValidacionContenido;
	}

	@Override
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
	
	
	private File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = excelRepoApi.dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} 
		catch (FileNotFoundException e) {
			logger.error(e.getMessage());
		}
		return null;
	}
	
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for (i = 1 ; i < this.numFilasHoja ; i++){
				if(!particularValidator.existeActivo(exc.dameCelda(i, POSICION_COLUMNA_NUM_ACTIVO_HAYA)))
					listaFilas.add(i);
			}
		} 
		catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
		}
		
		return listaFilas;
	}
	
	private List<Integer> esActivoUA(MSVHojaExcel exc){
		
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for (i = 1 ; i < this.numFilasHoja ; i++){
				if(particularValidator.esActivoUA(exc.dameCelda(i, POSICION_COLUMNA_NUM_ACTIVO_HAYA)))
					listaFilas.add(i);
			}
		} 
		catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
		}
		
		return listaFilas;
		
	}
	
	private List<Integer> existeGasto(MSVHojaExcel exc) {

		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				String valorGasto = exc.dameCelda(i, POSICION_COLUMNA_GASTO);
				if (!Checks.esNulo(valorGasto) && !particularValidator.existeGasto(valorGasto)) {
					listaFilas.add(i);
				}

			} catch (ParseException e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}

	
	private List<Integer> existeAperturaExp(MSVHojaExcel exc){

		List<Integer> listaFilas = new ArrayList<Integer>();
		
		String valor ="";
		
		int i = 0;
		try {
			for (i = 1 ; i < this.numFilasHoja ; i++){
				 valor = exc.dameCelda(i, POSICION_COLUMNA_APERTURA_EXP);
				if(Checks.esNulo((valor)) || !(COD_SI.equals(valor) || COD_NO.equals(valor)))
					listaFilas.add(i);
			}
		} 
		catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
		}
		
		
		return listaFilas;
	}
	
	private List<Integer> existeMinusvalia(MSVHojaExcel exc){

		List<Integer> listaFilas = new ArrayList<Integer>();
		
		String valor ="";
		
		int i = 0;
		try {
			for (i = 1 ; i < this.numFilasHoja ; i++){
				 valor = exc.dameCelda(i, POSICION_COLUMNA_MINUSVALIA);
				if(Checks.esNulo((valor)) || !(COD_SI.equals(valor) || COD_NO.equals(valor)))
					listaFilas.add(i);
			}
		} 
		catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
		}
		
		
		return listaFilas;
	}
	
	private List<Integer> existeExento(MSVHojaExcel exc){

		List<Integer> listaFilas = new ArrayList<Integer>();
		
		String valor ="";
		
		int i = 0;
		try {
			for (i = 1 ; i < this.numFilasHoja ; i++){
				 valor = exc.dameCelda(i, POSICION_COLUMNA_EXENTO);
				if(Checks.esNulo((valor)) || !(COD_SI.equals(valor) || COD_NO.equals(valor)))
					listaFilas.add(i);
			}
		} 
		catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
		}
		
		
		return listaFilas;
	}
	
	private List<Integer> existeAutoliquidacion(MSVHojaExcel exc){

		List<Integer> listaFilas = new ArrayList<Integer>();
		
		String valor ="";
		
		int i = 0;
		try {
			for (i = 1 ; i < this.numFilasHoja ; i++){
				 valor = exc.dameCelda(i, POSICION_COLUMNA_AUTOLIQUIDACION);
				if(Checks.esNulo((valor)) || !(COD_SI.equals(valor) || COD_NO.equals(valor)))
					listaFilas.add(i);
			}
		} 
		catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
		}
		
		
		return listaFilas;
	}
	
	private void validarAccion(MSVHojaExcel exc) {

		final String DD_ACM_ADD = "01";
		listaFilasAccionNoValido = new ArrayList<Integer>();
		listaFilasAccionActivoPlusvaliaExiste = new ArrayList<Integer>();
		listaFilasAccionActivoPlusvaliaNoExiste = new ArrayList<Integer>();
		
		String valorAccion ="";
		String valorFechaPlusvalia= "";
		String valorActivo = "";

		for (int i = DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {

			try {
				
				valorActivo = exc.dameCelda(i, POSICION_COLUMNA_NUM_ACTIVO_HAYA);
				valorAccion = exc.dameCelda(i, POSICION_COLUMNA_ACCION);
				valorFechaPlusvalia = exc.dameCelda(i, POSICION_COLUMNA_FECHA_PLUSVALIA);

				Boolean existeActivoPlusvalia = particularValidator.existeActivoPlusvalia(valorActivo,valorFechaPlusvalia);

				if (!particularValidator.esAccionValido(valorAccion)) {
					listaFilasAccionNoValido.add(i);
				}

				if (valorAccion.equals(DD_ACM_ADD) && existeActivoPlusvalia) {
					listaFilasAccionActivoPlusvaliaExiste.add(i);
				}

				if (!valorAccion.equals(DD_ACM_ADD) && !existeActivoPlusvalia) {
					listaFilasAccionActivoPlusvaliaNoExiste.add(i);
				}

			} catch (ParseException e) {
				listaFilasAccionNoValido.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilasAccionNoValido.add(0);
				logger.error(e.getMessage());
			}
		}
	}

}
