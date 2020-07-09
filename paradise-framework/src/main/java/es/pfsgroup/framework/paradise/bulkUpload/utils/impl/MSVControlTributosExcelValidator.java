package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.IOException;
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
public class MSVControlTributosExcelValidator extends MSVExcelValidatorAbstract {

	private static final String REGISTRO_NO_EXISTE = "msg.error.masivo.control.tributos.registro.no.existe";
	private static final String REGISTRO_EXISTE = "msg.error.masivo.control.tributos.registro.existe";
	private static final String ACTIVO_NO_EXISTE = "msg.error.masivo.control.tributos.activo.no.existe";
	private static final String ACTIVO_ES_UA = "msg.error.masivo.control.tributos.activo.es.ua";
	private static final String ACCION_NO_VALIDO = "msg.error.masivo.control.tributos.accion.no.valido";
	private static final String NUM_HAYA_VINCULADO_NO_EXISTE = "msg.error.masivo.control.tributos.vinculado.no.existe";

	private static final String RESULTADO_NO_VALIDO = "msg.error.masivo.control.tributos.resultado.no.valido";
	private static final String SOLICITUD_NO_VALIDO = "msg.error.masivo.control.tributos.tipo.solicitud.no.valido";
	private static final String ID_TRIBUTO_NO_VALIDO = "msg.error.masivo.control.tributos.id.tributo.no.valido";
	private static final String ID_TRIBUTO_VACIO = "msg.error.masivo.control.tributos.id.tributo.vacio";
	private static final String FECHA_NO_VALIDA = "msg.error.masivo.control.tributos.fecha.no.valida";
	private static final String ID_TIPO_TRIBUTO_NO_VALIDO = "msg.error.masivo.control.tributos.tipo.tributo.no.valido";
	private static final String EXPEDIENTE_NO_EXISTE = "msg.error.masivo.control.tributos.expediente.no.existe";

	private static final String FORMATO_FECHA = "dd/MM/yyyy";

	private List<Integer> listaFilasAccionNoValido;
	private List<Integer> listaFilasAccionActivoTributoExiste;
	private List<Integer> listaFilasAccionActivoTributoNoExiste;
	private List<Integer> listaFilasIdTributoErroneo;
	private List<Integer> listaFilasSinIdTributo;

	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;

		static final int COL_NUM_ACTIVO = 0;
		static final int COL_NUM_TIPO_TRIBUTO=1;
		static final int COL_NUM_FECHA_RECEPCION_TRIBUTO=2;
		static final int COL_NUM_FECHA_EMISION = 3;
		static final int COL_NUM_FECHA_RECEPCION_PROPIETARIO = 4;
		static final int COL_NUM_FECHA_RECEPCION_GESTORIA = 5;
		static final int COL_NUM_TIPO_SOLICITUD = 6;
		static final int COL_NUM_OBSERVACIONES = 7;
		static final int COL_NUM_FECHA_RECEPCION_RECURSO_BANKIA = 8;
		static final int COL_NUM_FECHA_RECEPCION_RECURSO_GESTORIA = 9;
		static final int COL_NUM_FECHA_RESPUESTA = 10;
		static final int COL_NUM_RESULTADO_SOLICITUD = 11;
		static final int COL_NUM_HAYA_VINCULADO=12;
		static final int COL_NUM_EXISTE_DOC=13;
		static final int COL_NUM_NUMERO_EXPEDIENTE=14;
		static final int COL_NUM_FECHA_COMUNICADO_DEVOLUCION_INGRESO=15;
		static final int COL_NUM_IMPORTE_RECUPERADO=16;
		static final int COL_NUM_ACCION = 17;
		static final int COL_ID_TRIBUTO = 18;
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

	@Autowired
	private MSVBusinessValidationFactory validationFactory;

	private Integer numFilasHoja;

	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {

		Long idTipoOperacion = dtoFile.getIdTipoOperacion();

		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVControlTributosExcelValidator::validarContenidoFichero -> idTipoOperacion no puede ser null");
		}

		List<String> lista = recuperarFormato(idTipoOperacion);
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(idTipoOperacion));
		MSVBusinessCompositeValidators compositeValidators = validationFactory
				.getCompositeValidators(getTipoOperacion(idTipoOperacion));
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(idTipoOperacion));
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators,
				compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(idTipoOperacion);

		// Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		// Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			validarAccion(exc);
			mapaErrores.put(messageServices.getMessage(ACCION_NO_VALIDO), listaFilasAccionNoValido);
			mapaErrores.put(messageServices.getMessage(REGISTRO_NO_EXISTE), listaFilasAccionActivoTributoNoExiste);
			mapaErrores.put(messageServices.getMessage(REGISTRO_EXISTE), listaFilasAccionActivoTributoExiste);
			mapaErrores.put(messageServices.getMessage(ID_TRIBUTO_NO_VALIDO), listaFilasIdTributoErroneo);
			mapaErrores.put(messageServices.getMessage(ID_TRIBUTO_VACIO), listaFilasSinIdTributo);
			mapaErrores.put(messageServices.getMessage(ACTIVO_NO_EXISTE), existeActivo(exc));
			mapaErrores.put(messageServices.getMessage(ACTIVO_ES_UA), esActivoUA(exc));
			mapaErrores.put(messageServices.getMessage(NUM_HAYA_VINCULADO_NO_EXISTE), esNumHayaVinculado(exc));
			mapaErrores.put(messageServices.getMessage(RESULTADO_NO_VALIDO), esResultadoValido(exc));
			mapaErrores.put(messageServices.getMessage(SOLICITUD_NO_VALIDO), esSolicitudValido(exc));
			mapaErrores.put(messageServices.getMessage(FECHA_NO_VALIDA), esFechaNoValida(exc));
			mapaErrores.put(messageServices.getMessage(ID_TIPO_TRIBUTO_NO_VALIDO), esTipoTributoValido(exc));
			mapaErrores.put(messageServices.getMessage(EXPEDIENTE_NO_EXISTE), esExpedienteValido(exc));
			

			
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

	@Override
	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda,
			MSVBusinessValidators contentValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);

		if ((contentValidators != null) && (contentValidators.getValidatorForColumn(nombreColumna.trim()) != null)) {
			MSVColumnValidator v = contentValidators.getValidatorForColumn(nombreColumna.trim());
			MSVValidationResult result = validationRunner.runValidation(v, contenidoCelda);
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

	private void validarAccion(MSVHojaExcel exc) {

		final String DD_ACM_ADD = "01";
		listaFilasAccionNoValido = new ArrayList<Integer>();
		listaFilasAccionActivoTributoExiste = new ArrayList<Integer>();
		listaFilasAccionActivoTributoNoExiste = new ArrayList<Integer>();
		listaFilasIdTributoErroneo = new ArrayList<Integer>();
		listaFilasSinIdTributo = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {

			try {

				String valorCelda = exc.dameCelda(i, COL_NUM.COL_NUM_ACCION);
				String valorCeldaActivo = exc.dameCelda(i, COL_NUM.COL_NUM_ACTIVO);
				String valorCeldaFechaRecurso = exc.dameCelda(i, COL_NUM.COL_NUM_FECHA_EMISION);
				String valorCeldaTipoSolicitud = exc.dameCelda(i, COL_NUM.COL_NUM_TIPO_SOLICITUD);
				String valorCeldaIdTributo = exc.dameCelda(i, COL_NUM.COL_ID_TRIBUTO);

				if (!Checks.esNulo(valorCeldaFechaRecurso) && (getLengthOfYear(valorCeldaFechaRecurso) != null
						&& getLengthOfYear(valorCeldaFechaRecurso) <= 4)) {
					Boolean existeActivoTributo = Boolean.TRUE.equals(particularValidator.existeActivoTributo(
							valorCeldaActivo, valorCeldaFechaRecurso, valorCeldaTipoSolicitud, valorCeldaIdTributo));

					if (!particularValidator.esAccionValido(valorCelda)) {
						listaFilasAccionNoValido.add(i);
					}

					if (valorCelda.equals(DD_ACM_ADD) && existeActivoTributo) {
						listaFilasAccionActivoTributoExiste.add(i);

						if (!Checks.esNulo(valorCeldaIdTributo)) {
							listaFilasIdTributoErroneo.add(i);
						}
					}

					if (valorCelda.equals(DD_ACM_ADD) && !existeActivoTributo && !Checks.esNulo(valorCeldaIdTributo)) {
						listaFilasIdTributoErroneo.add(i);
					}

					if (!valorCelda.equals(DD_ACM_ADD) && !existeActivoTributo) {
						listaFilasAccionActivoTributoNoExiste.add(i);
						if (Checks.esNulo(valorCeldaIdTributo)) {
							listaFilasSinIdTributo.add(i);
						}
					}
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

	private List<Integer> esNumHayaVinculado(MSVHojaExcel exc) {

		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				String valorGasto = exc.dameCelda(i, COL_NUM.COL_NUM_HAYA_VINCULADO);
				String valorActivo = exc.dameCelda(i, COL_NUM.COL_NUM_ACTIVO);
				if (!Checks.esNulo(valorGasto)
						&& !particularValidator.esNumHayaVinculado(Long.parseLong(valorGasto), valorActivo)) {
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
	
	private List<Integer> esExpedienteValido(MSVHojaExcel exc) {

		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				String numExpediente = exc.dameCelda(i, COL_NUM.COL_NUM_NUMERO_EXPEDIENTE);
				if (!Checks.esNulo(numExpediente)
						&& !particularValidator.esnNumExpedienteValido(Long.parseLong(numExpediente))) {
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

	private List<Integer> esActivoUA(MSVHojaExcel exc) {

		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if (particularValidator.esActivoUA(exc.dameCelda(i, COL_NUM.COL_NUM_ACTIVO)))
					listaFilas.add(i);
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

	private List<Integer> existeActivo(MSVHojaExcel exc) {

		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.existeActivo(exc.dameCelda(i, COL_NUM.COL_NUM_ACTIVO)))
					listaFilas.add(i);
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

	private List<Integer> esResultadoValido(MSVHojaExcel exc) {

		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.esResultadoValido(exc.dameCelda(i, COL_NUM.COL_NUM_RESULTADO_SOLICITUD)))
					listaFilas.add(i);
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
	
	private List<Integer> esTipoTributoValido(MSVHojaExcel exc) {

		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.esTipoTributoValido(exc.dameCelda(i, COL_NUM.COL_NUM_TIPO_TRIBUTO)))
					listaFilas.add(i);
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

	private List<Integer> esSolicitudValido(MSVHojaExcel exc) {

		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.esSolicitudValido(exc.dameCelda(i, COL_NUM.COL_NUM_TIPO_SOLICITUD)))
					listaFilas.add(i);
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

	/**
	 * Funcion para comprobar el formato de la Fecha
	 * 
	 * @param exc
	 * @param columnNumber
	 * @return
	 */
	private List<Integer> esFechaNoValida(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String valorDate = null;
		Integer[] fechas = { COL_NUM.COL_NUM_FECHA_EMISION, COL_NUM.COL_NUM_FECHA_RECEPCION_PROPIETARIO,
				COL_NUM.COL_NUM_FECHA_RECEPCION_GESTORIA, COL_NUM.COL_NUM_FECHA_RECEPCION_RECURSO_BANKIA,
				COL_NUM.COL_NUM_FECHA_RECEPCION_RECURSO_GESTORIA, COL_NUM.COL_NUM_FECHA_RESPUESTA };

		for (int i = COL_NUM.DATOS_PRIMERA_FILA; i < numFilasHoja; i++) {
			try {
				for (int j = 0; j < fechas.length; j++) {
					valorDate = exc.dameCelda(i, fechas[j]);
					Integer yearSize = getLengthOfYear(valorDate);
					if (!Checks.esNulo(valorDate) && (yearSize == null || yearSize > 4)) {
						listaFilas.add(i);
					}
				}
			} catch (IllegalArgumentException e) {
				logger.error(e.getMessage(), e);
				e.printStackTrace();
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
				e.printStackTrace();
			} catch (ParseException e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(i);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}

	private Integer getLengthOfYear(String date) {
		Integer yearSize = null;
		if (date != null) {
			String[] dateArray = date.split("\\/");
			String year = dateArray == null ? null : dateArray[dateArray.length - 1];
			yearSize = year == null ? null : year.length();
		}
		return yearSize;
	}

}
