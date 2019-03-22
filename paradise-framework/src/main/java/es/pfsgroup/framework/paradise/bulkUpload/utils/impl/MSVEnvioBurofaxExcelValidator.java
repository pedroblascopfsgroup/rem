package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVAltaActivosExcelValidator.COL_NUM;

@Component
public class MSVEnvioBurofaxExcelValidator extends MSVExcelValidatorAbstract {
	
	private static final String ACTIVO_NO_EXISTE = "msg.error.masivo.listado.validator.activos.deben.existir";
	private static final String FECHA_COMUNICACION = "msg.error.fecha.comunicacion.envio.burofax";
	private static final String CARACTER_ENVIO_NO_VALIDO = "msg.error.masivo.caracter.invalido.envio.cartas";
	private static final String NUMERO_CARTAS_NO_VALIDO = "msg.error.fecha.comunicacion.numero.cartas";
	private static final String CARACTER_CONTACTO_NO_VALIDO = "msg.error.masivo.caracter.invalido.contacto";
	private static final String CARACTER_VISITA_NO_VALIDO = "msg.error.masivo.caracter.invalido.visita";
	private static final String CARACTER_BUROFAX_NO_VALIDO = "msg.error.masivo.caracter.invalido.burofax";
	
	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		
		static final int COL_NUM_ID_ACTIVO_HAYA = 0;
		static final int COL_NUM_FECHA_COMUNICACION = 1;
		static final int COL_NUM_ENVIO_CARTAS = 2;
		static final int COL_NUM_NUMERO_CARTAS = 3;	
		static final int COL_NUM_CONTACTO_TELEF = 4;
		static final int COL_NUM_VISITA = 5;
		static final int COL_NUM_BUROFAX = 6;
	}
	
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
			mapaErrores.put(messageServices.getMessage(FECHA_COMUNICACION), isColumnNotDateByRows(exc, COL_NUM.COL_NUM_FECHA_COMUNICACION));
			mapaErrores.put(messageServices.getMessage(CARACTER_ENVIO_NO_VALIDO), isColumnNotBoolByRows(exc, COL_NUM.COL_NUM_ENVIO_CARTAS));
			mapaErrores.put(messageServices.getMessage(NUMERO_CARTAS_NO_VALIDO), isCantidadCartasErronea(exc, COL_NUM.COL_NUM_NUMERO_CARTAS));
			mapaErrores.put(messageServices.getMessage(CARACTER_CONTACTO_NO_VALIDO), isColumnNotBoolByRows(exc, COL_NUM.COL_NUM_CONTACTO_TELEF));
			mapaErrores.put(messageServices.getMessage(CARACTER_VISITA_NO_VALIDO), isColumnNotBoolByRows(exc, COL_NUM.COL_NUM_VISITA));
			mapaErrores.put(messageServices.getMessage(CARACTER_BUROFAX_NO_VALIDO), isColumnNotBoolByRows(exc, COL_NUM.COL_NUM_BUROFAX));
			
			if (!mapaErrores.get(messageServices.getMessage(ACTIVO_NO_EXISTE)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(FECHA_COMUNICACION)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(CARACTER_ENVIO_NO_VALIDO)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(NUMERO_CARTAS_NO_VALIDO)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(CARACTER_CONTACTO_NO_VALIDO)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(CARACTER_VISITA_NO_VALIDO)).isEmpty()
				|| !mapaErrores.get(messageServices.getMessage(CARACTER_BUROFAX_NO_VALIDO)).isEmpty())
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
	
	protected ResultadoValidacion validaContenidoCelda(String nombrecolumnNumber, String contenidoCelda, MSVBusinessValidators contentValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);
		
		if ((contentValidators != null) && (contentValidators.getValidatorForColumn(nombrecolumnNumber.trim()) != null)){
			MSVColumnValidator v = contentValidators.getValidatorForColumn(nombrecolumnNumber.trim());
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
	
	private List<Integer> isColumnNotBoolByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String valorBool = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				valorBool = exc.dameCelda(i, columnNumber);

				// Si el valor Boolean no se corresponde con el estándar.
				if (!Checks.esNulo(valorBool) && (!valorBool.equalsIgnoreCase("S") && !valorBool.equalsIgnoreCase("N")
						&& !valorBool.equalsIgnoreCase("SI") && !valorBool.equalsIgnoreCase("NO") && !valorBool.equalsIgnoreCase("NA") && !valorBool.isEmpty())) {
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

	private List<Integer> isCantidadCartasErronea(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		int i=0;
		try {
			for(i=1; i<this.numFilasHoja; i++) {
					if( exc.dameCelda(i, columnNumber).equalsIgnoreCase("1")
							|| exc.dameCelda(i, columnNumber).equalsIgnoreCase("2")
							|| exc.dameCelda(i, columnNumber).equalsIgnoreCase("3")
							|| (exc.dameCelda(i, columnNumber).isEmpty())){}		
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
	private List<Integer> isActiveNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.COL_NUM_ID_ACTIVO_HAYA)))
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
	
	private List<Integer> isColumnNotDateByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		String valorDate = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				valorDate = exc.dameCelda(i, columnNumber);

				// Si el valor Date no se puede obtener adecuadamente se lanza
				// error para esa línea.
				if (!Checks.esNulo(valorDate)) {
					ft.parse(valorDate);
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
	
	
}

