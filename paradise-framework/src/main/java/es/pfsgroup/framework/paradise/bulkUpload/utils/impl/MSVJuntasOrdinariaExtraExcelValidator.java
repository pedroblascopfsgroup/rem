package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
public class MSVJuntasOrdinariaExtraExcelValidator extends MSVExcelValidatorAbstract {
	
	private static final String FECHA_JUNTA_ERR = "msg.error.masivo.fecha.junta.error";
	private static final String ACTIVO_NO_EXISTE = "msg.error.masivo.listado.validator.activos.deben.existir";
	private static final String ACTIVO_PERTENECE_UA = "msg.error.masivo.plusvalia.activo.pertenece.ua";
	private static final String PROMOCION_ERR = "msg.error.masivo.caracter.si.no.invalido.promocion";
	private static final String PREJUICIO_ECONOMICO_ERR = "msg.error.masivo.caracter.si.no.invalido.prejuicio";
	private static final String ACT_JUDIC_ERR = "msg.error.masivo.caracter.si.no.invalido.act.judic";
	private static final String ESTATUTOS_ERR = "msg.error.masivo.caracter.si.no.invalido.estatutos";
	private static final String ITE_ERR = "msg.error.masivo.caracter.si.no.invalido.ite";
	private static final String MOROSOS_ERR = "msg.error.masivo.caracter.si.no.invalido.morosos";
	private static final String MOD_COUTA_ERR = "msg.error.masivo.caracter.si.no.invalido.mod.cuota";
	private static final String JGO_JE_ERR = "msg.error.masivo.caracter.si.no.invalido.jgo.je";	
	private static final String ACCION_NO_VALIDA = "msg.error.masivo.control.tributos.accion.no.valido";
	private static final String REGISTRO_NO_EXISTE = "msg.error.masivo.control.tributos.registro.no.existe";
	private static final String REGISTRO_EXISTE = "msg.error.masivo.control.tributos.registro.existe";
	private static final String JUNTAS_DECIMALES_ERR = "msg.error.masivo.juntas.err.decimales";
	
	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		
		static final int COL_NUM_FECHA_JUNTA = 0;
		static final int COL_NUM_COMUNIDAD = 1;
		static final int COL_NUM_ID_ACTIVO_HAYA = 2;
		static final int COL_NUM_PORCENTAJE_PARTICIPACION = 3;
		static final int COL_NUM_PROMOCION_50 = 4;
		static final int COL_NUM_PREJUICIO_ECONOMICO = 5;
		static final int COL_NUM_JGO_JE = 6;
		static final int COL_NUM_ACT_JUDIC = 7;
		static final int COL_NUM_MOD_ESTATUTOS = 8;
		static final int COL_NUM_ITE = 9;
		static final int COL_NUM_MOROSOS = 10;
		static final int COL_NUM_MOD_CUOTA = 11;
		static final int COL_NUM_OTROS = 12;
		static final int COL_NUM_IMPORTE = 13;
		static final int COL_NUM_CUOTA_ORDINARIA = 14;
		static final int COL_NUM_CUOTA_EXTRA = 15;
		static final int COL_NUM_SUMINISTROS = 16;
		static final int COL_NUM_PROPUESTA = 17;
		static final int COL_NUM_GUION_VOTO = 18;
		static final int COL_NUM_INDICACIONES = 19;
		static final int COL_NUM_ACCION = 20;
	}

	
	private List<Integer> listaFilasAccionNoValido;
	private List<Integer> listaFilasAccionJuntasOrdExtExiste;
	private List<Integer> listaFilasAccionJuntasOrdExtNoExiste;

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
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
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
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			validarAccion(exc);
			mapaErrores.put(messageServices.getMessage(FECHA_JUNTA_ERR), isColumnNotDateByRows(exc, COL_NUM.COL_NUM_FECHA_JUNTA));
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), isActiveNotExistsRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_PERTENECE_UA), esActivoUA(exc));
			mapaErrores.put(messageServices.getMessage(PROMOCION_ERR), isColumnNotBoolByRows(exc, COL_NUM.COL_NUM_PROMOCION_50));
			mapaErrores.put(messageServices.getMessage(PREJUICIO_ECONOMICO_ERR), isColumnNotBoolByRows(exc, COL_NUM.COL_NUM_PREJUICIO_ECONOMICO));
			mapaErrores.put(messageServices.getMessage(ACT_JUDIC_ERR), isColumnNotBoolByRows(exc, COL_NUM.COL_NUM_ACT_JUDIC));
			mapaErrores.put(messageServices.getMessage(ESTATUTOS_ERR), isColumnNotBoolByRows(exc, COL_NUM.COL_NUM_MOD_ESTATUTOS));
			mapaErrores.put(messageServices.getMessage(ITE_ERR), isColumnNotBoolByRows(exc, COL_NUM.COL_NUM_ITE));
			mapaErrores.put(messageServices.getMessage(MOROSOS_ERR), isColumnNotBoolByRows(exc, COL_NUM.COL_NUM_MOROSOS));
			mapaErrores.put(messageServices.getMessage(MOD_COUTA_ERR), isColumnNotBoolByRows(exc, COL_NUM.COL_NUM_MOD_CUOTA));
			mapaErrores.put(messageServices.getMessage(JGO_JE_ERR), isJuntasCodRows(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_PERTENECE_UA), esActivoUA(exc));
			mapaErrores.put(messageServices.getMessage(ACCION_NO_VALIDA), listaFilasAccionNoValido);
			mapaErrores.put(messageServices.getMessage(REGISTRO_NO_EXISTE), listaFilasAccionJuntasOrdExtNoExiste);
			mapaErrores.put(messageServices.getMessage(REGISTRO_EXISTE), listaFilasAccionJuntasOrdExtExiste);
			mapaErrores.put(messageServices.getMessage(JUNTAS_DECIMALES_ERR), isColumnNANDecimalByRows(exc, COL_NUM.COL_NUM_PORCENTAJE_PARTICIPACION));
			mapaErrores.put(messageServices.getMessage(JUNTAS_DECIMALES_ERR), isColumnNANDecimalByRows(exc, COL_NUM.COL_NUM_IMPORTE));
			mapaErrores.put(messageServices.getMessage(JUNTAS_DECIMALES_ERR), isColumnNANDecimalByRows(exc, COL_NUM.COL_NUM_CUOTA_ORDINARIA));
			mapaErrores.put(messageServices.getMessage(JUNTAS_DECIMALES_ERR), isColumnNANDecimalByRows(exc, COL_NUM.COL_NUM_CUOTA_EXTRA));
			mapaErrores.put(messageServices.getMessage(JUNTAS_DECIMALES_ERR), isColumnNANDecimalByRows(exc, COL_NUM.COL_NUM_SUMINISTROS));

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
	
	
	/**
	 * Comprueba si el activo existe	
	 * 
	 * @param exc
	 * @return lista errores
	 */
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
	
	/**
	 * Comprueba si el formato de fecha es correcto	
	 * 
	 * @param exc
	 * @return lista errores
	 */
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
	
	/**
	 * Comprueba si el codigo del campo booleano es correcto
	 * 	
	 * @param exc
	 * @return lista errores
	 */
	private List<Integer> isColumnNotBoolByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String valorBool = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				valorBool = exc.dameCelda(i, columnNumber);

				// Si el valor Boolean no se corresponde con el estándar.
				if (!Checks.esNulo(valorBool) && (!valorBool.equalsIgnoreCase("S") && !valorBool.equalsIgnoreCase("N") && !valorBool.isEmpty())) {
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
	
	/**
	 * 
	 * Comprueba si el activo es una UA
	 * 
	 * @param exc
	 * @return
	 */
	private List<Integer> esActivoUA(MSVHojaExcel exc){
		
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		int i = 0;
		try {
			for (i = 1 ; i < this.numFilasHoja ; i++){
				if(particularValidator.esActivoUA(exc.dameCelda(i, COL_NUM.COL_NUM_ID_ACTIVO_HAYA)))
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
		listaFilasAccionJuntasOrdExtExiste = new ArrayList<Integer>();
		listaFilasAccionJuntasOrdExtNoExiste = new ArrayList<Integer>();
		
		String valorAccion ="";
		String valorActivo = "";
		String valorFechaJunta = "";

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {

			try {
				
				valorActivo = exc.dameCelda(i, COL_NUM.COL_NUM_ID_ACTIVO_HAYA);
				valorAccion = exc.dameCelda(i, COL_NUM.COL_NUM_ACCION);
				valorFechaJunta = exc.dameCelda(i, COL_NUM.COL_NUM_FECHA_JUNTA);

				Boolean existeJunta = particularValidator.existeJunta(valorActivo, valorFechaJunta);

				if (!particularValidator.esAccionValido(valorAccion)) {
					listaFilasAccionNoValido.add(i);
				}

				if (valorAccion.equals(DD_ACM_ADD) && existeJunta) {
					listaFilasAccionJuntasOrdExtExiste.add(i);
				}

				if (!valorAccion.equals(DD_ACM_ADD) && !existeJunta) {
					listaFilasAccionJuntasOrdExtNoExiste.add(i);
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
	
	private List<Integer> isJuntasCodRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!particularValidator.existeCodJGOJE(exc.dameCelda(i, COL_NUM.COL_NUM_JGO_JE)))
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
	
	private List<Integer> isColumnNANDecimalByRows(MSVHojaExcel exc, int columnNumber) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		Double superficie = null;

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				String value = exc.dameCelda(i, columnNumber);
				if (!Checks.esNulo(value) && !esArroba(value)) {
					if (value.contains(",")) {
						value = value.replace(",", ".");
					}
					superficie = !Checks.esNulo(value) ? Double.parseDouble(value) : null;

					// Si el superficie no es un número válido.
					if (!Checks.esNulo(superficie) && superficie.isNaN()) {
						listaFilas.add(i);
					}
				}
			} catch (NumberFormatException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage());
				e.printStackTrace();
			} catch (ParseException e) {
				logger.error(e.getMessage());
				listaFilas.add(i);
			}
		}

		return listaFilas;
	}
	
	private boolean esArroba(String cadena) {
		return cadena.trim().equals("@");
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
}

