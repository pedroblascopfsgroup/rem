package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
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
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidators;
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
public class MSVValidadorCargaMasivaAdecuacion extends MSVExcelValidatorAbstract {
	
	private static final String ACTIVO_NO_EXISTE = "msg.error.masivo.listado.validator.activos.deben.existir";
	private static final String ACTIVO_VENDIDO = "msg.error.masivo.agrupar.activos.asistida.activo.vendido";
	private static final String ACTIVO_FUERA_PERIMETRO = "msg.error.masivo.actualizar.perimetro.checks.no";
	private static final String ACTIVO_FUERA_PERIMETRO_HAYA = "msg.error.masivo.actualizar.perimetro.activo";
	private static final String CARACTER_NO_VALIDO = "msg.error.masivo.caracter.invalido";
	private static final int COL_NUM_ID_ACTIVO_HAYA = 0;
	private static final int COL_NUM_ADECUACION= 1;


	@Resource
    private MessageService messageServices;

	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;
	
	private Integer numFilasHoja;
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = new MSVDtoValidacion();
		dtoValidacionContenido.setFicheroTieneErrores(false);
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
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), isActiveNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_VENDIDO), activosVendidosRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO), activosIncluidosPerimetroRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO_HAYA), activosIncluidosPerimetroRowsHaya(exc));
			mapaErrores.put(messageServices.getMessage(CARACTER_NO_VALIDO), hayCaracterInvalido(exc));
			
			if (!mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_VENDIDO)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(ACTIVO_FUERA_PERIMETRO_HAYA)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(CARACTER_NO_VALIDO)).isEmpty())
			{
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

	private List<Integer> hayCaracterInvalido(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i=0;
		try {
			for(i=1; i<this.numFilasHoja; i++) {
					if((exc.dameCelda(i, COL_NUM_ADECUACION).equalsIgnoreCase("S"))
							|| (exc.dameCelda(i, COL_NUM_ADECUACION).equalsIgnoreCase("SI"))		   
							|| (exc.dameCelda(i, COL_NUM_ADECUACION).equalsIgnoreCase("N")) 
							|| (exc.dameCelda(i, COL_NUM_ADECUACION).equalsIgnoreCase("NO"))
							|| (exc.dameCelda(i, COL_NUM_ADECUACION).equalsIgnoreCase("NA"))
							|| (exc.dameCelda(i, COL_NUM_ADECUACION).isEmpty())){}		
					else {
						listaFilas.add(i);
					}
				}
			}catch(Exception e) {
				if (i != 0) 
					listaFilas.add(i);
				logger.error(e.getMessage());
				e.printStackTrace();
				
			}
		return listaFilas;
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
		
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.existeActivo(exc.dameCelda(i, COL_NUM_ID_ACTIVO_HAYA)))
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
				if(particularValidator.esActivoVendido(exc.dameCelda(i, COL_NUM_ID_ACTIVO_HAYA)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}
	
	private List<Integer> activosIncluidosPerimetroRows(MSVHojaExcel exc){
		List <Integer> listaFilas = new ArrayList<Integer>();
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++) {
				if(!particularValidator.isActivoIncluidoPerimetroAlquiler(exc.dameCelda(i, COL_NUM_ID_ACTIVO_HAYA)))
					listaFilas.add(i);
			}
		} catch (Exception e) {
			if (i != 0) listaFilas.add(i);
			logger.error(e.getMessage());
			e.printStackTrace();
		}

		return listaFilas;
	}

	private List<Integer> activosIncluidosPerimetroRowsHaya(MSVHojaExcel exc){
		List <Integer> listaFilas = new ArrayList<Integer>();
		int i = 0;
		try {
			for(i=1; i<this.numFilasHoja;i++) {
				if(!particularValidator.esActivoIncluidoPerimetro(exc.dameCelda(i, COL_NUM_ID_ACTIVO_HAYA)))
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

