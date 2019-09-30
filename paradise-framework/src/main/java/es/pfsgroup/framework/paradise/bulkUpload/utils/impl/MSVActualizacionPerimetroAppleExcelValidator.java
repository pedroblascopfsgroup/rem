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
public class MSVActualizacionPerimetroAppleExcelValidator extends MSVExcelValidatorAbstract {

	private final String CHECK_ACTIVO_EXISTE = "msg.error.masivo.valores.perimetro.apple.validator.activo.no.existe";
	private final String CHECK_ACTIVO_APPLE = "msg.error.masivo.valores.perimetro.apple.validator.activo.no.apple";
	private final String CHECK_SERVICER_ACTIVO = "msg.error.masivo.valores.perimetro.apple.validator.servicer";
	private final String CHECK_PERIMETRO_CARTERA = "msg.error.masivo.valores.perimetro.apple.validator.perimetro.cartera";
	private final String CHECK_CESION = "msg.error.masivo.valores.perimetro.apple.validator.cesion.comercial";
	private final String CHECK_MACC = "msg.error.masivo.valores.perimetro.apple.validator.perimetro.macc";
	private final String CHECK_CAMPO_ORDINARIO = "msg.error.masivo.valores.perimetro.apple.validator.campo.ordinario";

	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int COL_NUM_ACTIVO = 0;
	private final int COL_SERVICER_ACTIVO = 1;
	private final int COL_PERIMETRO_CARTERA = 2;
	private final int COL_NOMBRE_CARTERA = 3;
	private final int COL_CESION_COMERCIAL = 4;
	private final int COL_PERIMETRO_MACC = 5;
	private final int COL_VALOR_ORDINARIO = 6;

	private List<Integer> listaActivoNoExiste;
	private List<Integer> listaActivoNoApple;

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
					"MSVActualizacionPerimetroAppleExcelValidator::validarContenidoFichero -> idTipoOperacion no puede ser null");
		}

		List<String> lista = recuperarFormato(idTipoOperacion);
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(idTipoOperacion));
		MSVBusinessCompositeValidators compositeValidators = validationFactory	.getCompositeValidators(getTipoOperacion(idTipoOperacion));
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
			comprobarActivo(exc);
			mapaErrores.put(messageServices.getMessage(CHECK_ACTIVO_EXISTE), listaActivoNoExiste);
			mapaErrores.put(messageServices.getMessage(CHECK_ACTIVO_APPLE), listaActivoNoApple);
			mapaErrores.put(messageServices.getMessage(CHECK_SERVICER_ACTIVO), comprobarServicer(exc));
			mapaErrores.put(messageServices.getMessage(CHECK_CESION), comprobarCesion(exc));
			mapaErrores.put(messageServices.getMessage(CHECK_PERIMETRO_CARTERA),	esValorSiNo(exc, COL_PERIMETRO_CARTERA));
			mapaErrores.put(messageServices.getMessage(CHECK_MACC), esValorSiNo(exc, COL_PERIMETRO_MACC));
			mapaErrores.put(messageServices.getMessage(CHECK_CAMPO_ORDINARIO), comprobarValorOrdinario(exc));

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

		if ((contentValidators != null) && (contentValidators.getValidatorForColumn(nombreColumna.trim()) != null)) {
			MSVColumnValidator v = contentValidators.getValidatorForColumn(nombreColumna.trim());
			MSVValidationResult result = validationRunner.runValidation(v, contenidoCelda);
			resultado.setValido(result.isValid());
			resultado.setErroresFila(result.getErrorMessage());
		}
		return resultado;
	}

	@Override
	protected ResultadoValidacion validaContenidoFila(Map<String, String> mapaDatos, List<String> listaCabeceras,	MSVBusinessCompositeValidators compositeValidators) {
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

	private List<Integer> comprobarServicer(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String celdaServicer;

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				celdaServicer = exc.dameCelda(i, COL_SERVICER_ACTIVO);
				if (!Checks.esNulo(celdaServicer)
						&& !particularValidator.perteneceDDServicerActivo(celdaServicer.toUpperCase())) {
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

	private List<Integer> comprobarCesion(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String celdaCesion;

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				celdaCesion = exc.dameCelda(i, COL_CESION_COMERCIAL);
				if (!Checks.esNulo(celdaCesion)
						&& !particularValidator.perteneceDDCesionComercial(celdaCesion.toUpperCase())) {
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

	private List<Integer> comprobarValorOrdinario(MSVHojaExcel exc) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String celdaValorOrdinario;

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				celdaValorOrdinario = exc.dameCelda(i, COL_VALOR_ORDINARIO);
				if (!Checks.esNulo(celdaValorOrdinario)
						&& !particularValidator.perteneceDDClasificacionApple(celdaValorOrdinario)) {
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

	private void comprobarActivo(MSVHojaExcel exc) {
		String celdaNumActivo;
		listaActivoNoExiste = new ArrayList<Integer>();
		listaActivoNoApple = new ArrayList<Integer>();

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				celdaNumActivo = exc.dameCelda(i, COL_NUM_ACTIVO);
				if (!particularValidator.existeActivo(celdaNumActivo)) {
					listaActivoNoExiste.add(i);
				} else if (!particularValidator.esActivoApple(celdaNumActivo)) {
					listaActivoNoApple.add(i);
				}
			} catch (ParseException e) {
				listaActivoNoExiste.add(i);
				logger.error(e.getMessage());
			} catch (Exception e) {
				listaActivoNoExiste.add(0);
				logger.error(e.getMessage());
			}
		}
	}

	private List<Integer> esValorSiNo(MSVHojaExcel exc, int celda) {
		List<Integer> listaFilas = new ArrayList<Integer>();
		String[] listaValidos = { "SI", "S", "NO", "N" };
		String valorCelda;

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				valorCelda = exc.dameCelda(i, celda);
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

}
