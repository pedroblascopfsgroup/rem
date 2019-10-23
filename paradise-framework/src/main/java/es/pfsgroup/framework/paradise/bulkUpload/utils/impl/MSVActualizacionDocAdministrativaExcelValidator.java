package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
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
public class MSVActualizacionDocAdministrativaExcelValidator extends MSVExcelValidatorAbstract {

	private final String CHECK_DOC = "msg.error.masivo.doc.administrativa.validator.documento";
	private final String CHECK_ACTIVO_EXISTE = "msg.error.masivo.doc.administrativa.validator.activo.no.existe";
	private final String CHECK_APLICA = "msg.error.masivo.doc.administrativa.validator.aplica";
	private final String CHECK_ESTADO = "msg.error.masivo.doc.administrativa.validator.estado";
	private final String CHECK_CALIFICACION = "msg.error.masivo.doc.administrativa.validator.calificacion";
	private final String CHECK_LETRA_CONSUMO = "msg.error.masivo.doc.administrativa.validator.letra.consumo";
	private final String CHECK_ID_DOC = "msg.error.masivo.doc.administrativa.validator.dataid";
	private final String CHECK_ES_DOC_CEE = "msg.error.masivo.doc.administrativa.validator.campos.cee";

	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int NUM_COLS = 14;

	private final int COL_TIPO_DOC = 0;
	private final int COL_NUM_ACTIVO = 1;
	private final int COL_APLICA = 2;
	private final int COL_ESTADO = 3;
	private final int COL_F_SOLICITUD = 4;
	private final int COL_F_OBTENCION = 5;
	private final int COL_F_VALIDACION = 6;
	private final int COL_F_CADUCIDAD = 7;
	private final int COL_F_ETIQUETA = 8;
	private final int COL_CALIFICACION = 9;
	private final int COL_ID_DOC = 10;
	private final int COL_LETRA_CONSUMO = 11;
	private final int COL_CONSUMO = 12;
	private final int COL_EMISION = 13;
	private final int COL_REGISTRO = 14;

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
		Long idTipoOperacion = dtoFile.getIdTipoOperacion();

		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVActualizacionDocAdministrativaExcelValidator::validarContenidoFichero -> idTipoOperacion no puede ser null");
		}

		List<String> lista = recuperarFormato(idTipoOperacion);
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(idTipoOperacion));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(idTipoOperacion));
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(idTipoOperacion));
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
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
			mapaErrores.put(messageServices.getMessage(CHECK_ACTIVO_EXISTE), comprobarActivo(exc));
			mapaErrores.put(messageServices.getMessage(CHECK_DOC), comprobarDocumento(exc));
			mapaErrores.put(messageServices.getMessage(CHECK_APLICA), comprobarAplica(exc));
			mapaErrores.put(messageServices.getMessage(CHECK_ESTADO), comprobarEstado(exc));
			mapaErrores.put(messageServices.getMessage(CHECK_CALIFICACION), comprobarCalificacion(exc, COL_CALIFICACION));
			mapaErrores.put(messageServices.getMessage(CHECK_LETRA_CONSUMO), comprobarCalificacion(exc, COL_LETRA_CONSUMO));
			mapaErrores.put(messageServices.getMessage(CHECK_ID_DOC), comprobarIdDoc(exc));
			mapaErrores.put(messageServices.getMessage(CHECK_ES_DOC_CEE), comprobarEsDocCEE(exc));

			for (Entry<String, List<Integer>> registro : mapaErrores.entrySet()) {
				if (!registro.getValue().isEmpty()) {
					dtoValidacionContenido.setFicheroTieneErrores(true);
					dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
				}
			}
		}

		exc.cerrar();
		return dtoValidacionContenido;
	}

	@Override
	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda,	MSVBusinessValidators contentValidators) {
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
	protected ResultadoValidacion validaContenidoFila(Map<String, String> mapaDatos, List<String> listaCabeceras, MSVBusinessCompositeValidators compositeValidators) {
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

	private File recuperarPlantilla(Long idTipoOperacion) {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			logger.error(e.getMessage());
		}
		return null;
	}

	private List<Integer> comprobarActivo(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String celdaNumActivo;
		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				celdaNumActivo = exc.dameCelda(i, COL_NUM_ACTIVO);
				if (!particularValidator.existeActivo(celdaNumActivo)) {
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

	private List<Integer> comprobarDocumento(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String celdaTipoDoc;

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				celdaTipoDoc = exc.dameCelda(i, COL_TIPO_DOC);
				if (Checks.esNulo(celdaTipoDoc) || !particularValidator.existeTipoDoc(celdaTipoDoc.toUpperCase())) {
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

	private List<Integer> comprobarEstado(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String celdaEstadoDoc;
		String celdaTipoDoc;	

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				celdaEstadoDoc = exc.dameCelda(i, COL_ESTADO);
				celdaTipoDoc = exc.dameCelda(i, COL_TIPO_DOC);
				if (!Checks.esNulo(celdaEstadoDoc) && !particularValidator.existeEstadoDocumento(celdaEstadoDoc.toUpperCase())
						|| Checks.esNulo(celdaEstadoDoc) && particularValidator.esDocumentoCEE(celdaTipoDoc.toUpperCase())) {
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

	private List<Integer> comprobarCalificacion(MSVHojaExcel exc, int columna) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String codCE;
		String celdaTipoDoc;	

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				codCE = exc.dameCelda(i, columna);
				celdaTipoDoc = exc.dameCelda(i, COL_TIPO_DOC);				
				if (!Checks.esNulo(codCE) && !particularValidator.existeCalificacionEnergetica(codCE.toUpperCase())
						|| Checks.esNulo(codCE) && particularValidator.esDocumentoCEE(celdaTipoDoc.toUpperCase())) {
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

	private List<Integer> comprobarAplica(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaValidos = { "1", "0" };
		String valorCelda;

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				valorCelda = exc.dameCelda(i, COL_APLICA);
				if (!Checks.esNulo(valorCelda) && !Arrays.asList(listaValidos).contains(valorCelda.toUpperCase())) {
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

	private List<Integer> comprobarIdDoc(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String idDoc;

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				idDoc = exc.dameCelda(i, COL_ID_DOC);
				if (!Checks.esNulo(idDoc) && !StringUtils.isNumeric(idDoc)) {
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

	private List<Integer> comprobarEsDocCEE(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String celda;		

		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
				celda = exc.dameCelda(fila, COL_TIPO_DOC);
				if (!Checks.esNulo(celda) && particularValidator.esDocumentoCEE(celda)) {
					for (int col = 0; col <= NUM_COLS; col++) {
						if (col == COL_TIPO_DOC || col == COL_F_ETIQUETA || col == COL_REGISTRO) {
							continue;
						}
						if (Checks.esNulo(exc.dameCelda(fila, col)) && !listaFilas.contains(fila)) {
							listaFilas.add(fila);
						}
					}
				}
			} catch (ParseException e) {
				listaFilas.add(fila);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaFilas.add(0);
				logger.error(e.getMessage());
			}
		}
		return listaFilas;
	}

}
