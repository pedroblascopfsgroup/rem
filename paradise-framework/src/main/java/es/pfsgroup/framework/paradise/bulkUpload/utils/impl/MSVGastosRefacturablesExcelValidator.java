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
public class MSVGastosRefacturablesExcelValidator extends MSVExcelValidatorAbstract {

	private static final String GASTO_PADRE_NO_EXISTE = "msg.error.masivo.gasto.refacturable.validator.padre.no.existe";
	private static final String GASTO_PADRE_REFACTURADO = "msg.error.masivo.gasto.refacturable.validator.padre.refacturado";
	private static final String GASTO_PADRE_NO_PERTENECE_BANKIA_SAREB = "msg.error.masivo.gasto.refacturable.validator.padre.no.pertenece.bankia.sareb";
	private static final String GASTO_PADRE_NO_EMISOR_HAYA = "msg.error.masivo.gasto.refacturable.validator.padre.no.emisor.haya";
	private static final String GASTO_PADRE_NO_DESTINATARIO_PROPIETARIO = "msg.error.masivo.gasto.refacturable.validator.padre.no.destinatario.propietario";

	private static final String GASTO_HIJO_NO_EXISTE = "msg.error.masivo.gasto.refacturable.validator.hijo.no.existe";
	private static final String GASTO_HIJO_NO_REFACTURABLE = "msg.error.masivo.gasto.refacturable.validator.hijo.no.refacturable";
	private static final String GASTO_HIJO_NO_PERTENECE_BANKIA_SAREB = "msg.error.masivo.gasto.refacturable.validator.hijo.no.pertenece.bankia.sareb";
	private static final String GASTO_HIJO_NO_DESTINATARIO_HAYA = "msg.error.masivo.gasto.refacturable.validator.hijo.no.destinatario.haya";
	private static final String GASTO_HIJO_DIFERENTE_CARTERA = "msg.error.masivo.gasto.refacturable.validator.hijo.diferente.cartera";
	private static final String GASTO_HIJO_EXISTE = "msg.error.masivo.gasto.refacturable.validator.hijo.existe";
	private static final int FILA_CABECERA = 0;
	private static final int FILA_DATOS = 1;

	private static final int COL_GASTO_PADRE = 0;
	private static final int COL_GASTO_HIJO = 1;

	private Integer numFilasHoja;

	protected final Log logger = LogFactory.getLog(getClass());

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

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {

		Long idTipoOperacion = dtoFile.getIdTipoOperacion();

		if (idTipoOperacion == null) {
			throw new IllegalArgumentException(
					"MSVGastosRefacturablesExcelValidator::validarContenidoFichero -> idTipoOperacion no puede ser null");
		}

		List<String> lista = recuperarFormato(idTipoOperacion);
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(idTipoOperacion));
		MSVBusinessCompositeValidators compositeValidators = validationFactory
				.getCompositeValidators(getTipoOperacion(idTipoOperacion));		
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperaPlantilla(idTipoOperacion));
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
			mapaErrores.put(messageServices.getMessage(GASTO_PADRE_NO_EXISTE), existeGasto(exc, COL_GASTO_PADRE));
			mapaErrores.put(messageServices.getMessage(GASTO_PADRE_REFACTURADO), esGastoRefacturado(exc, COL_GASTO_PADRE));
			mapaErrores.put(messageServices.getMessage(GASTO_PADRE_NO_EMISOR_HAYA), esGastoEmisorHaya(exc, COL_GASTO_PADRE));
			mapaErrores.put(messageServices.getMessage(GASTO_PADRE_NO_PERTENECE_BANKIA_SAREB), perteneceGastoBankiaSareb(exc, COL_GASTO_PADRE));
			mapaErrores.put(messageServices.getMessage(GASTO_PADRE_NO_DESTINATARIO_PROPIETARIO), esGastoDestinatarioPropietario(exc, COL_GASTO_PADRE));

			mapaErrores.put(messageServices.getMessage(GASTO_HIJO_EXISTE), existeGastoRefacturable(exc, COL_GASTO_HIJO));
			mapaErrores.put(messageServices.getMessage(GASTO_HIJO_NO_EXISTE), existeGasto(exc, COL_GASTO_HIJO));
			mapaErrores.put(messageServices.getMessage(GASTO_HIJO_NO_REFACTURABLE), esGastoRefacturable(exc, COL_GASTO_HIJO));
			mapaErrores.put(messageServices.getMessage(GASTO_HIJO_NO_PERTENECE_BANKIA_SAREB), perteneceGastoBankiaSareb(exc, COL_GASTO_HIJO));
			mapaErrores.put(messageServices.getMessage(GASTO_HIJO_NO_DESTINATARIO_HAYA), esGastoDestinatarioHaya(exc, COL_GASTO_HIJO));
			mapaErrores.put(messageServices.getMessage(GASTO_HIJO_DIFERENTE_CARTERA), esGastoMismaCartera(exc, COL_GASTO_PADRE, COL_GASTO_HIJO));

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

	private File recuperaPlantilla(Long idTipoOperacion) {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			logger.error(e.getMessage());
		}
		return null;
	}

	
	private List<Integer> existeGastoRefacturable(MSVHojaExcel exc, int colGasto) {

		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				if (particularValidator.existeGastoRefacturable(exc.dameCelda(i, colGasto)))
					listaFilas.add(i);
				// numero gasto refacturable' ya existe
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
	 * Comprueba si existe el gasto 
	 * @param exc
	 * @param colGasto número de columna con los gastos a comprobar
	 * @return listado con el número de fila en las que NO existe el gasto
	 */
	private List<Integer> existeGasto(MSVHojaExcel exc, int colGasto) {

		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.existeGasto(exc.dameCelda(i, colGasto)))
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
	 * Comprueba si el gasto es refacturado 
	 * @param exc
	 * @param colGasto número de columna con los gastos a comprobar
	 * @return listado con el número de fila en las que el gasto es refacturado
	 */
	private List<Integer> esGastoRefacturado(MSVHojaExcel exc, int colGasto) {

		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				if (particularValidator.esGastoRefacturado(exc.dameCelda(i, colGasto)))
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
	 * Comprueba si el gasto es refacturable	 
	 * @param exc
	 * @param colGasto número de columna con los gastos a comprobar
	 * @return listado con el número de fila en las que el gasto no es posible
	 *         refacturar
	 */
	private List<Integer> esGastoRefacturable(MSVHojaExcel exc, int colGasto) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {

				if (colGasto == COL_GASTO_HIJO && !particularValidator.esGastoRefacturable(exc.dameCelda(i, colGasto))
						|| colGasto == COL_GASTO_PADRE
								&& particularValidator.esGastoRefacturable(exc.dameCelda(i, colGasto))) {
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

	/**
	 * Comprueba si el gasto es pertenece a BANKIA o SAREB	  
	 * @param exc
	 * @param colGasto número de columna con los gastos a comprobar
	 * @return listado con el número de fila en las que el gasto NO pertenece a
	 *         BANKIA o SAREB
	 */
	private List<Integer> perteneceGastoBankiaSareb(MSVHojaExcel exc, int colGasto) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.perteneceGastoBankiaSareb(exc.dameCelda(i, colGasto)))
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
	 * Comprueba si el gasto tiene como destinatario HAYA	 
	 * @param exc
	 * @param colGasto número de columna con los gastos a comprobar
	 * @return listado con el número de fila en las que el gasto NO tiene
	 *         destinatario HAYA
	 */
	private List<Integer> esGastoDestinatarioHaya(MSVHojaExcel exc, int colGasto) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.esGastoDestinatarioHaya(exc.dameCelda(i, colGasto)))
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
	 * Comprueba si el gasto tiene como destinatario HAYA	 
	 * @param exc
	 * @param colGasto número de columna con los gastos a comprobar
	 * @return listado con el número de fila en las que el gasto NO tiene
	 *         destinatario HAYA
	 */
	private List<Integer> esGastoDestinatarioPropietario(MSVHojaExcel exc, int colGasto) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.esGastoDestinatarioPropietario(exc.dameCelda(i, colGasto)))
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
	 * Comprueba si el gasto tiene como emisor HAYA	 
	 * @param exc
	 * @param colGasto número de columna con los gastos a comprobar
	 * @return listado con el número de fila en las que el emisor del gasto NO es
	 *         HAYA
	 */
	private List<Integer> esGastoEmisorHaya(MSVHojaExcel exc, int colGasto) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.esGastoEmisorHaya(exc.dameCelda(i, colGasto)))
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
	
	/***
	 * Comprueba si los gastos a refacturar pertenecen a la misma cartera
	 * @param exc
	 * @param colGasto número de columna con los gastos a comprobar
	 * @param colOtroGasto número de columna con los gastos a comprobar
	 * @return listado con el número de fila en las que el gasto tiene diferente cartera
	 */
	private List<Integer> esGastoMismaCartera(MSVHojaExcel exc, int colGasto, int colOtroGasto) {
		List<Integer> listaFilas = new ArrayList<Integer>();

		for (int i = FILA_DATOS; i < this.numFilasHoja; i++) {
			try {
				if (!particularValidator.esGastoMismaCartera(exc.dameCelda(i, colGasto),
						exc.dameCelda(i, colOtroGasto)))
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

}
