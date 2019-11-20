package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	private final String CHECK_EMISION = "msg.error.masivo.doc.administrativa.validator.emision";
	private final String CHECK_LETRA_CONSUMO ="msg.error.masivo.doc.administrativa.validator.letra.consumo";
	private final String CHECK_CONSUMO = "msg.error.masivo.doc.administrativa.validator.consumo";
	private final String CHECK_ID_DOC = "msg.error.masivo.doc.administrativa.validator.dataid";
	private final String CHECK_ES_DOC_CEE = "msg.error.masivo.doc.administrativa.validator.campos.cee";
	private final String CHECK_FECHA_SOLICITUD = "msg.error.masivo.doc.administrativa.validator.fecha.solicitud";
	private final String CHECK_FECHA_OBTENCION = "msg.error.masivo.doc.administrativa.validator.fecha.obtencion";
	private final String CHECK_FECHA_VALIDACION = "msg.error.masivo.doc.administrativa.validator.fecha.validacion";
	private final String CHECK_FECHA_CADUCIDAD = "msg.error.masivo.doc.administrativa.validator.fecha.caducidad";
	private final String CHECK_FECHA_ETIQUETA = "msg.error.masivo.doc.administrativa.validator.fecha.etiqueta";

	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int NUM_COLS = 15;

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

	Map<String, List<Integer>> mapaErrores;

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

		if (!dtoValidacionContenido.getFicheroTieneErrores() && !validarFichero(exc)) {
			dtoValidacionContenido.setFicheroTieneErrores(true);
			dtoValidacionContenido.setExcelErroresFormato(new FileItem(new File(exc.crearExcelErroresMejorado(mapaErrores))));
		}
		exc.cerrar();
		return dtoValidacionContenido;
	}

	private boolean validarFichero(MSVHojaExcel exc) {
		boolean esCorrecto = true;
		mapaErrores = new HashMap<String, List<Integer>>();
		ArrayList<ArrayList<Integer>> listasError = new ArrayList<ArrayList<Integer>>();
		ArrayList<Integer> errList = null;

		String[] listaValidos = { "1", "0" };
		String celda;

		for (int columna = 0; columna < NUM_COLS; columna++) {
			listasError.add(columna, new ArrayList<Integer>());
		}

		for (int fila = FILA_DATOS; fila < this.numFilasHoja; fila++) {
			try {
				boolean docTipoCEE = particularValidator.esDocumentoCEE(exc.dameCelda(fila, COL_TIPO_DOC));

				for (int columna = 0; columna < NUM_COLS; columna++) {
					errList = listasError.get(columna);
					celda = exc.dameCelda(fila, columna);
					boolean valorOK = true;

					switch (columna) {
					case COL_TIPO_DOC:
						valorOK = !Checks.esNulo(celda) && particularValidator.existeTipoDoc(celda);
						break;

					case COL_NUM_ACTIVO:
						valorOK = !Checks.esNulo(celda) && particularValidator.existeActivo(celda);
						break;

					case COL_APLICA:
						valorOK = !Checks.esNulo(celda) && Arrays.asList(listaValidos).contains(celda);
						break;

					case COL_ESTADO:
						valorOK = Checks.esNulo(celda) && !docTipoCEE
								|| !Checks.esNulo(celda) && particularValidator.existeEstadoDocumento(celda);
						break;

					case COL_F_SOLICITUD:
					case COL_F_OBTENCION:
					case COL_F_VALIDACION:
					case COL_F_CADUCIDAD:
					case COL_F_ETIQUETA:		
					case COL_ID_DOC:
					case COL_CONSUMO:
					case COL_EMISION:
						valorOK = Checks.esNulo(celda) && !docTipoCEE || !Checks.esNulo(celda);
						break;
					
					case COL_CALIFICACION:
					case COL_LETRA_CONSUMO:
						valorOK = !Checks.esNulo(celda) && particularValidator.existeCalificacionEnergetica(celda)
								|| Checks.esNulo(celda) && !docTipoCEE;
						break;

					case COL_REGISTRO:
						valorOK = true;
						break;
					}

					if (!valorOK) {
						errList.add(fila);
						esCorrecto = false;
					}

				}

			} catch (ParseException e) {
				errList.add(fila);
				logger.error(e.getMessage());
			} catch (Exception e) {
				errList.add(0);
				logger.error(e.getMessage());
			}
		}
		
		if (!esCorrecto) {
			mapaErrores.put(messageServices.getMessage(CHECK_ACTIVO_EXISTE), listasError.get(COL_NUM_ACTIVO));
			mapaErrores.put(messageServices.getMessage(CHECK_DOC), listasError.get(COL_TIPO_DOC));
			mapaErrores.put(messageServices.getMessage(CHECK_APLICA), listasError.get(COL_APLICA));
			mapaErrores.put(messageServices.getMessage(CHECK_ESTADO), listasError.get(COL_ESTADO));
			mapaErrores.put(messageServices.getMessage(CHECK_CALIFICACION), listasError.get(COL_CALIFICACION));
			mapaErrores.put(messageServices.getMessage(CHECK_EMISION), listasError.get(COL_EMISION));
			mapaErrores.put(messageServices.getMessage(CHECK_LETRA_CONSUMO), listasError.get(COL_LETRA_CONSUMO));
			mapaErrores.put(messageServices.getMessage(CHECK_CONSUMO), listasError.get(COL_CONSUMO));
			mapaErrores.put(messageServices.getMessage(CHECK_ID_DOC), listasError.get(COL_ID_DOC));
			mapaErrores.put(messageServices.getMessage(CHECK_FECHA_SOLICITUD), listasError.get(COL_F_SOLICITUD));
			mapaErrores.put(messageServices.getMessage(CHECK_FECHA_CADUCIDAD), listasError.get(COL_F_CADUCIDAD));
			mapaErrores.put(messageServices.getMessage(CHECK_FECHA_OBTENCION), listasError.get(COL_F_OBTENCION));
			mapaErrores.put(messageServices.getMessage(CHECK_FECHA_VALIDACION), listasError.get(COL_F_VALIDACION));
			mapaErrores.put(messageServices.getMessage(CHECK_FECHA_ETIQUETA), listasError.get(COL_F_ETIQUETA));
		}
		return esCorrecto;
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

	private File recuperarPlantilla(Long idTipoOperacion) {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			logger.error(e.getMessage());
		}
		return null;
	}

}
