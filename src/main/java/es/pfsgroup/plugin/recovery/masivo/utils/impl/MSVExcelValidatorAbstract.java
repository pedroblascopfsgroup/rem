package es.pfsgroup.plugin.recovery.masivo.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.MSVExcelParser;
import es.pfsgroup.plugin.recovery.masivo.ValidationError;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelRepoApi;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessValidators;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDDOperacionMasivaDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoValidacion;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVExcelFileItemDto;
import es.pfsgroup.plugin.recovery.masivo.dto.ResultadoValidacion;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.utils.MSVExcelValidator;

public abstract class MSVExcelValidatorAbstract implements MSVExcelValidator {

	@Resource(name = "appProperties")
	private Properties appProperties;
	
	@Autowired
	private MSVDDOperacionMasivaDao operacionMasivaDao;

	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	private static final String ERROR_TAMANYO_MINIMO = "El fichero tiene que tener un mínimo de dos filas";
	private static final String ERROR_TAMANYO_MAXIMO = "El fichero tiene mas filas de las permitidas";
	private static final String ERROR_SIN_CABECERA = "No se encuentran las cabeceras en el excel";
	private static final String ERROR_FICHERO_NOT_FOUND = "No se ha podido recuperar el fichero excel";

	private static final String ERROR_NOMBRES_CABECERA = "El nombre de las columnas no es correcto";

	private DecimalFormat format;

	/**
	 * validarFormatoFichero; recorre una hoja excel y comprueba las
	 * validaciones de formato especificadas (se encuentran a través del dtoFile
	 * que recupera el tipo de operación)
	 * 
	 * @param exc
	 *            MSVHojaExcel : descriptor de la hoja excel
	 * @param dtoFile
	 *            MSVExcelFileItemDto: contiene la información del tipo de
	 *            operación
	 * @return MSVDtoValidacionFormato: contiene la información de la validacion
	 * 
	 * @author pedro
	 */
	@Override
	public MSVDtoValidacion validarFormatoFichero(MSVExcelFileItemDto dtoFile) {

		DecimalFormatSymbols symbols = new DecimalFormatSymbols();
		symbols.setDecimalSeparator(',');
		format = new DecimalFormat("0.#");
		format.setDecimalFormatSymbols(symbols);

		List<String> listaValidacion = recuperarFormato(dtoFile.getIdTipoOperacion());

		// recuperamos el fichero mediante el objeto excelParse
		@SuppressWarnings("deprecation")
		MSVHojaExcel exc;
		@SuppressWarnings("deprecation")
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion()));
		if (dtoFile.getExcelFile() != null) {
			checkExcelFile(dtoFile.getExcelFile());
			exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		} else {
			exc = excelParser.getExcel(dtoFile.getRuta());
		}

		MSVDtoValidacion dto = recorrerFichero(exc, excPlantilla, listaValidacion, null, null, true);

		return dto;
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

	/**
	 * recorrerFichero; recorre una hoja excel y comprueba las validaciones de
	 * formato especificadas
	 * 
	 * @param exc
	 *            MSVHojaExcel : descriptor de la hoja excel
	 * @param listaValidacion
	 *            : lista de validaciones a aplicar a la hoja excel
	 * 
	 * @param contentValidators
	 *            Validadores de contenido, es requerido si se quiere hacer una
	 *            validación de negocio. Este parámetro puede ser null si sólo
	 *            se quiere realizar una validación de formato
	 * 
	 * @return MSVDtoValidacion contiene la información de la validacion
	 * 
	 * @author pedro
	 */
	@SuppressWarnings("deprecation")
	public MSVDtoValidacion recorrerFichero(MSVHojaExcel exc, MSVHojaExcel excPlantilla, List<String> listaValidacion, MSVBusinessValidators contentValidators, 
			MSVBusinessCompositeValidators compositeValidators, boolean validacionFormato) {

		try {
			MSVDtoValidacion dto = new MSVDtoValidacion();
			dto.setFicheroTieneErrores(false);

			// nos creamos una lista que va a tener una entrada por cada fila
			// del fichero excel
			// cada string contendrá la concatenación de los errores de cada
			// columna
			// si una fila no tiene ningún error se le pasará un string vacío
			List<String> listaErrores = new ArrayList<String>();

			// validamos las especificaciones básicas
			// si tiene errores previos no será necesario analizar el fichero
			Boolean erroresPrevios = false;

			List<String> cabecerasExcel = null;
			List<String> cabecerasExcelPlantilla = null;
			
			String numeroMaximoFilas = appProperties.getProperty(KEY_NUMERO_MAXIMO_FILAS);
			if (numeroMaximoFilas == null) {
				numeroMaximoFilas = "5000";
			}
			// recuperamos las cabeceras del excel
			if (!Checks.esNulo(exc)) {
				try {
					// validacion tamaño minimo
					if (exc.getNumeroFilas() < 2) {
						erroresPrevios = true;
						listaErrores.add(ERROR_TAMANYO_MINIMO);
					}
					cabecerasExcel = exc.getCabeceras();
					if (excPlantilla != null){
						cabecerasExcelPlantilla = excPlantilla.getCabeceras();
					}
					if (exc.getNumeroFilas() > Integer.parseInt(numeroMaximoFilas)) {
						erroresPrevios = true;
						listaErrores.add(ERROR_TAMANYO_MAXIMO);
					}
					// validacion de que tiene el número de columnas que
					// esperamos
					if (validacionFormato && (!Checks.esNulo(cabecerasExcel)) && (!Checks.estaVacio(cabecerasExcel))) {
						if (cabecerasExcel.size() != listaValidacion.size()) {
							erroresPrevios = true;
							String error_num_columnas = "Se esperan " + listaValidacion.size() + " columnas y se han recibido " + cabecerasExcel.size();
							listaErrores.add(error_num_columnas);
						}
						//Validamos que el nombre de las columnas sea el correcto.
						if (!this.validarNombreCabeceras(cabecerasExcel,cabecerasExcelPlantilla)){
							erroresPrevios = true;
							listaErrores.add(ERROR_NOMBRES_CABECERA);
						}
					} else if (validacionFormato){
						erroresPrevios = true;
						listaErrores.add(ERROR_SIN_CABECERA);
					}
				} catch (IOException ioe) {
					throw new ValidationError("Error al acceder al fichero Excel", ioe);
				}
			} else {
				erroresPrevios = true;
				listaErrores.add(ERROR_FICHERO_NOT_FOUND);
			}
			// validacion tamaño maximo

			boolean erroresContenido = false;
			if (!erroresPrevios) {
				// validar cada una de las líneas del fichero
				for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
					StringBuilder errorDesc = new StringBuilder();
					// PBO: Preparar la recogida de datos para las validaciones multivalor (compuesta)
					Map<String, String> mapaDatos = new HashMap<String, String>();
					// validar cada una de las columnas de cada fila
					for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {
						String contenidoCelda = exc.dameCelda(fila, columna);
						ResultadoValidacion resultadoValidacion;
						if (validacionFormato) {
							resultadoValidacion = validaCelda(listaValidacion.get(columna), contenidoCelda, cabecerasExcel.get(columna));
						} else {
							resultadoValidacion = validaContenidoCelda(cabecerasExcel.get(columna), contenidoCelda, contentValidators);
						}
						errorDesc.append((resultadoValidacion.getErroresFila() != null ? resultadoValidacion.getErroresFila() : ""));
						if (!resultadoValidacion.getValido()) {
							erroresContenido = true;
						}
						//PBO: recuperar los valores con sus columnas, para pasarlo a la validación multivalor (compuesta)
						mapaDatos.put(cabecerasExcel.get(columna), contenidoCelda);
					}
					//PBO: Invocar a la validación multivalor (compuesta)
					if (!validacionFormato) {
						ResultadoValidacion resultadoValidacionCompuesta = validaContenidoFila(mapaDatos, exc.getCabeceras(), compositeValidators);
						errorDesc.append((resultadoValidacionCompuesta.getErroresFila() != null ? resultadoValidacionCompuesta.getErroresFila() : ""));
						if (!resultadoValidacionCompuesta.getValido()) {
							erroresContenido = true;
						}
					}
					listaErrores.add(errorDesc.toString());
				}
			}

			if (erroresPrevios || erroresContenido) {
				dto.setFicheroTieneErrores(true);
				String nomFicheroErrores = exc.crearExcelErrores(listaErrores);
				FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
				dto.setExcelErroresFormato(fileItemErrores);
			} else {
				dto.setFicheroTieneErrores(false);
			}
			exc.cerrar();

			return dto;
		} catch (ValidationError ve) {
			throw ve;
		} catch (Exception e) {
			throw new RuntimeException("Error inesperado al recorrer el fichero", e);
		}
	}

	private boolean validarNombreCabeceras(List<String> cabecerasExcel,
			List<String> cabecerasExcelPlantilla) {
		if (cabecerasExcel == null || cabecerasExcelPlantilla == null){
			return false;
		}
		for (int columna = 0; columna < cabecerasExcel.size(); columna++) {
			if (!cabecerasExcel.get(columna).equals(cabecerasExcelPlantilla.get(columna))){
				return false;
			}
		}
		return true;
	}

	/**
	 * Devuelve un tipo de operación
	 * 
	 * @param idTipoOperacion
	 * @return
	 */
	protected MSVDDOperacionMasiva getTipoOperacion(Long idTipoOperacion) {
		MSVDDOperacionMasiva tipoOperacion = operacionMasivaDao.get(idTipoOperacion);
		return tipoOperacion;
	}

	private ResultadoValidacion validaCelda(String validacion, String contenidoCelda, String cabecera) {

		String inicioTextoError = "El campo '" + cabecera + "' ";
		String errObligatorio = inicioTextoError + "no puede estar vacío. ";
		String errNumerico = inicioTextoError + "debe ser numérico. ";
		String errImporte = inicioTextoError + "no es un importe válido. ";
		String errFecha = inicioTextoError + "no es una fecha válida. ";
		String errLongitud = inicioTextoError + "debe tener una longitud máxima de ";
		String errBooleano = inicioTextoError + "debe ser uno de estos valores 'S', 'SI', 'N' o 'NO' ";

		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);
		resultado.setErroresFila("");
		if (!Checks.esNulo(validacion)) {
			if (Checks.esNulo(contenidoCelda) && validacion.contains("*")) {
				resultado.setValido(false);
				resultado.setErroresFila(errObligatorio);
			} else if (Checks.esNulo(contenidoCelda) && (!validacion.contains("*"))) {
				// Bruno 26/2/2013 En este caso no hacemos nada, si el campo no
				// es obligatorio y está vacío valida
			} else if (MSVExcelValidator.CODIFICACION_NUMERICA.equals(validacion.substring(0, 1))) {
				try {
					Long.parseLong(contenidoCelda);
				} catch (Exception e) {
					resultado.setValido(false);
					resultado.setErroresFila(errNumerico);
				}
			} else if (MSVExcelValidator.CODIFICACION_IMPORTE.equals(validacion.substring(0, 1))) {
				try {
					format.parse(contenidoCelda).floatValue();
				} catch (Exception e) {
					resultado.setValido(false);
					resultado.setErroresFila(errImporte);
				}
			} else if (MSVExcelValidator.CODIFICACION_FECHA.equals(validacion.substring(0, 1))) {
				try {
					if (contenidoCelda.length() > 10) {
						contenidoCelda = contenidoCelda.substring(0, 10);
					}
					contenidoCelda = contenidoCelda.replaceAll(" ", "").replaceAll("-", "").replaceAll("/", "");
					if (contenidoCelda.length() < 6 || contenidoCelda.length() > 8) {
						resultado.setValido(false);
						resultado.setErroresFila(errFecha);						
					} else { 
						
						SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy");
						df.setLenient(false);
						df.parse(contenidoCelda);
					}
				} catch (Exception e) {
					resultado.setValido(false);
					resultado.setErroresFila(errFecha);
				}
			} else if (MSVExcelValidator.CODIFICACION_STRING.equals(validacion.substring(0, 1))) {
				int longitudMax = obtenerLongitudMax(validacion);
				if (longitudMax != 0 && contenidoCelda.length() > longitudMax) {
					resultado.setValido(false);
					resultado.setErroresFila(errLongitud + longitudMax);
				}
			} else if (MSVExcelValidator.CODIGO_BOOLEAN.equals(validacion.substring(0, 1))) {
				if (!contenidoCelda.equalsIgnoreCase("S") && !contenidoCelda.equalsIgnoreCase("SI") && !contenidoCelda.equalsIgnoreCase("N") && !contenidoCelda.equalsIgnoreCase("NO")) {
					resultado.setValido(false);
					resultado.setErroresFila(errBooleano);
				}
			}
		}
		// Cualquier otro formato se ignora
		return resultado;
	}

	private List<String> recuperarFormato(Long idTipoOperacion) {
		MSVDDOperacionMasiva tipoOperacion = getTipoOperacion(idTipoOperacion);
		String stringValidacion = tipoOperacion.getValidacionFormato();
		List<String> lista = Arrays.asList(stringValidacion.split(","));
		return lista;
	}

	private int obtenerLongitudMax(String validacion) {

		int result = 0;

		if (validacion.length() >= 2) {
			String strLong = validacion.substring(1);
			try {
				result = Integer.parseInt(strLong);
			} catch (Exception e) {
			}
		}

		return result;

	}

	/**
	 * Este método comprueba que el objeto excelFile esté correcto, es decir:
	 * <ol>
	 * <li>Que contenga un fileItem</li>
	 * <li>Que el fileItem contenga un File</li>
	 * <ol>
	 * Si todo es correcto éste método termina con normalidad, si no lanza una
	 * excepción de tipo IllegalStateException
	 * 
	 * @param excelFile
	 * 
	 * @throws IllegalStateExcepcion
	 *             Lanza esta excepción si el excelFile es null o si alguna de
	 *             las condiciones no se cumple
	 * 
	 * @author bruno
	 */
	private void checkExcelFile(ExcelFileBean excelFile) {
		if (excelFile == null) {
			throw new IllegalStateException("El objeto excelFile es nulo");
		}

		if (excelFile.getFileItem() == null) {
			throw new IllegalStateException("El objeto excelFile es no contiene un FileItem");
		}

		if (excelFile.getFileItem().getFile() == null) {
			throw new IllegalStateException("El objeto excelFile conteiene un FileItem sin un File asociado");
		}
	}

	/**
	 * Valida el contenido de una celda
	 * 
	 * @param nombreColumna
	 *            Nombre de la columna
	 * @param contenidoCelda
	 *            Contenido de la celda
	 * @param contentValidators
	 *            Validadores de contenido
	 * @return
	 */
	protected abstract ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda, MSVBusinessValidators contentValidators);

	/**
	 * Realiza validaciones multivalor con diferentes valores de la fila
	 * @param mapaDatos
	 * @param compositeValidators
	 * @return
	 */
	protected abstract ResultadoValidacion validaContenidoFila(
			Map<String, String> mapaDatos,
			List<String> listaCabeceras,
			MSVBusinessCompositeValidators compositeValidators);
}
