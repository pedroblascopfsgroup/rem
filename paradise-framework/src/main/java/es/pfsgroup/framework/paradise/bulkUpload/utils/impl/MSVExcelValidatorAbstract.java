package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelRepoApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidators;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVDDOperacionMasivaDao;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.dto.ResultadoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.ExcelFileBean;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelValidator;
import es.pfsgroup.framework.paradise.bulkUpload.utils.ValidationError;

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

	public static final String ACTIVE_DUPLICATED = "Este activo ya pertenece a esta agrupación.";
	
	private DecimalFormat format;

	/**
	 * validarFormatoFichero; recorre una hoja excel y comprueba las
	 * validaciones de formato especificadas (se encuentran a trav�s del dtoFile
	 * que recupera el tipo de operaci�n)
	 * 
	 * @param exc
	 *            MSVHojaExcel : descriptor de la hoja excel
	 * @param dtoFile
	 *            MSVExcelFileItemDto: contiene la informaci�n del tipo de
	 *            operaci�n
	 * @return MSVDtoValidacionFormato: contiene la informaci�n de la validacion
	 * 
	 * @author pedro
	 * @throws Exception 
	 */
	@Override
	public MSVDtoValidacion validarFormatoFichero(MSVExcelFileItemDto dtoFile) throws Exception {

		DecimalFormatSymbols symbols = new DecimalFormatSymbols();
		symbols.setDecimalSeparator(',');
		format = new DecimalFormat("0.#");
		format.setDecimalFormatSymbols(symbols);

		List<String> listaValidacion = recuperarFormato(dtoFile.getIdTipoOperacion());

		// recuperamos el fichero mediante el objeto excelParse
		MSVHojaExcel exc;
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

	public File recuperarPlantilla(Long idTipoOperacion)  {
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
	 *            validaci�n de negocio. Este par�metro puede ser null si s�lo
	 *            se quiere realizar una validaci�n de formato
	 * 
	 * @return MSVDtoValidacion contiene la informaci�n de la validacion
	 * 
	 * @author pedro
	 * @throws Exception 
	 */
	public MSVDtoValidacion recorrerFichero(MSVHojaExcel exc, MSVHojaExcel excPlantilla, List<String> listaValidacion, MSVBusinessValidators contentValidators, 
			MSVBusinessCompositeValidators compositeValidators, boolean validacionFormato) throws Exception {

		try {
			MSVDtoValidacion dto = new MSVDtoValidacion();
			dto.setFicheroTieneErrores(false);

			// nos creamos una lista que va a tener una entrada por cada fila
			// del fichero excel
			// cada string contendr� la concatenaci�n de los errores de cada
			// columna
			// si una fila no tiene ning�n error se le pasar� un string vac�o
			List<String> listaErrores = new ArrayList<String>();

			// validamos las especificaciones b�sicas
			// si tiene errores previos no ser� necesario analizar el fichero
			Boolean erroresPrevios = false;

			List<String> cabecerasExcelHoja0 = null;
			List<String> cabecerasExcelPlantilla = null;
			
			String numeroMaximoFilas = appProperties.getProperty(KEY_NUMERO_MAXIMO_FILAS);
			if (numeroMaximoFilas == null) {
				numeroMaximoFilas = "5000";
			}
			// recuperamos las cabeceras del excel
			exc.setPosColumnaByFormato(this.convertListToStringSeparatedByComma(listaValidacion));
			Integer numFilasDatosHoja0 = exc.getNumeroFilas();
			if (!Checks.esNulo(exc)) {
				try {
					// validacion tama�o minimo
					if (numFilasDatosHoja0 < 2) {
						erroresPrevios = true;
						listaErrores.add(ERROR_TAMANYO_MINIMO);
					}
					cabecerasExcelHoja0 = exc.getCabeceras();
					if (excPlantilla != null){
						cabecerasExcelPlantilla = excPlantilla.getCabeceras();
					}
					if (numFilasDatosHoja0 > Integer.parseInt(numeroMaximoFilas)) {
						erroresPrevios = true;
						listaErrores.add(ERROR_TAMANYO_MAXIMO);
					}
					// validacion de que tiene el n�mero de columnas que
					// esperamos
					if (validacionFormato && (!Checks.esNulo(cabecerasExcelHoja0)) && (!Checks.estaVacio(cabecerasExcelHoja0))) {
						if (cabecerasExcelHoja0.size() != listaValidacion.size()) {
							erroresPrevios = true;
							String error_num_columnas = "Se esperan " + listaValidacion.size() + " columnas y se han recibido " + cabecerasExcelHoja0.size();
							listaErrores.add(error_num_columnas);
						}
						//Validamos que el nombre de las columnas sea el correcto.
						else if (!this.validarNombreCabeceras(cabecerasExcelHoja0,cabecerasExcelPlantilla)){
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
			// validacion tama�o maximo
			
			boolean erroresContenido = false;
			if (!erroresPrevios) {
				for (int fila = 1; fila < numFilasDatosHoja0; fila++) {				
					StringBuilder errorDesc = new StringBuilder();
					// PBO: Preparar la recogida de datos para las validaciones multivalor (compuesta)
					Map<String, String> mapaDatos = new HashMap<String, String>();
					for (int columna = 0; columna < cabecerasExcelHoja0.size(); columna++) {
						List<String> contenidoColumna = new ArrayList<String>();
						contenidoColumna.add(null);
						for (int i = 1; i < numFilasDatosHoja0; i++) {
							contenidoColumna.add(exc.dameCelda(i, columna));
						}
						String contenidoCelda = contenidoColumna.get(fila);
						ResultadoValidacion resultadoValidacion;
						if (validacionFormato) {							
							resultadoValidacion = validaCelda(listaValidacion.get(columna), contenidoCelda, cabecerasExcelHoja0.get(columna));
							if (resultadoValidacion.getValido()) {
								resultadoValidacion = validaColumna(listaValidacion.get(columna), fila, contenidoColumna, cabecerasExcelHoja0.get(columna));
							}
						} else {
							resultadoValidacion = validaContenidoCelda(cabecerasExcelHoja0.get(columna), contenidoCelda, contentValidators);
						}
						errorDesc.append((resultadoValidacion.getErroresFila() != null ? resultadoValidacion.getErroresFila() : ""));
						if (!resultadoValidacion.getValido()) {
							erroresContenido = true;
						}
						//PBO: recuperar los valores con sus columnas, para pasarlo a la validaci�n multivalor (compuesta)
						mapaDatos.put(cabecerasExcelHoja0.get(columna), contenidoCelda);
					}
					//PBO: Invocar a la validaci�n multivalor (compuesta)
					if (!validacionFormato) {
						ResultadoValidacion resultadoValidacionCompuesta = validaContenidoFila(mapaDatos, cabecerasExcelHoja0, compositeValidators);
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
			throw new Exception("Error inesperado al recorrer el fichero", e);
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
	 * Devuelve un tipo de operaci�n
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
				// es obligatorio y est� vac�o valida
			} else if (validacion.contains(MSVExcelValidator.CODIFICACION_NUMERICA)) {
				try {
					Long.parseLong(contenidoCelda);
				} catch (Exception e) {
					resultado.setValido(false);
					resultado.setErroresFila(errNumerico);
				}
			} else if (validacion.contains(MSVExcelValidator.CODIFICACION_IMPORTE)) {
				try {
					format.parse(contenidoCelda).floatValue();
				} catch (Exception e) {
					resultado.setValido(false);
					resultado.setErroresFila(errImporte);
				}
			} else if (validacion.contains(MSVExcelValidator.CODIFICACION_FECHA)) {
				try {
					//petición para borrar el campo del registro que lleve una @
					if(!contenidoCelda.trim().equals("@")) {						
					
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
					}
				} catch (Exception e) {
					resultado.setValido(false);
					resultado.setErroresFila(errFecha);
				}
			} else if (validacion.contains(MSVExcelValidator.CODIFICACION_STRING)) {
				int longitudMax = obtenerLongitudMax(validacion);
				if (longitudMax != 0 && contenidoCelda.length() > longitudMax) {
					resultado.setValido(false);
					resultado.setErroresFila(errLongitud + longitudMax);
				}
			} else if (validacion.contains(MSVExcelValidator.CODIGO_BOOLEAN)) {
				if (!contenidoCelda.equalsIgnoreCase("S") && !contenidoCelda.equalsIgnoreCase("SI") && !contenidoCelda.equalsIgnoreCase("N") && !contenidoCelda.equalsIgnoreCase("NO")) {
					resultado.setValido(false);
					resultado.setErroresFila(errBooleano);
				}
			}
		}
		// Cualquier otro formato se ignora
		return resultado;
	}
	
	private ResultadoValidacion validaColumna(String validacion, int filaValidacion, List<String> contenidoColumna, String cabecera) {
		
		String inicioTextoError = "La columna '" + cabecera + "' ";
		String errTodosIguales = inicioTextoError + "debe tener todos los valores iguales. ";
		String errNingunRepetido = inicioTextoError + "no puede contener valores repetidos. ";
		String errSoloUnUno = inicioTextoError + "solo puede contener un uno. ";
		
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);
		resultado.setErroresFila("");	
		
		if (validacion.contains(MSVExcelValidator.VALIDAR_COLUMNA_TODOS_IGUALES)) {
			String primerValor = contenidoColumna.get(1);
			if (contenidoColumna.size() > 2) {
				boolean isFound = false;
				int fila = 2;
				while (!isFound && fila < contenidoColumna.size()) {
					String tmp = contenidoColumna.get(fila);
					if (!tmp.equals(primerValor) && fila == filaValidacion) {
						resultado.setValido(false);
						resultado.setErroresFila(errTodosIguales);
						isFound = true;
					}
					fila++;
				}
			}
		}
		
		if (validacion.contains(MSVExcelValidator.VALIDAR_COLUMNA_NINGUN_REPETIDO)) {
			HashSet<String> set = new HashSet<String>();
			boolean isFound = false;
			int fila = 1;
			while (!isFound && fila < contenidoColumna.size()) {
				String tmp = contenidoColumna.get(fila);
				if(set.contains(tmp) && fila== filaValidacion) {
					resultado.setValido(false);
					resultado.setErroresFila(errNingunRepetido);
					isFound = true; 
				}
				fila++;
				if (!Checks.esNulo(tmp) || validacion.contains(MSVExcelValidator.CODIGO_NO_NULO)) {
					set.add(tmp);
				}
				
			}
		}
			
		if (validacion.contains(MSVExcelValidator.VALIDAR_COLUMNA_SOLO_UN_UNO)) {
			int total = 0;
			boolean isFound = false;
			int fila = 1;
			while (!isFound && fila < contenidoColumna.size()) {
				String tmp = contenidoColumna.get(fila);
				if (tmp.equals("1")) {
					total++;						
					if (total > 1 && fila == filaValidacion) {
						resultado.setValido(false);
						resultado.setErroresFila(errSoloUnUno);
						isFound = true;
					}
				}
				fila++;
			}
		}
		
		return resultado;
	}

	protected List<String> recuperarFormato(Long idTipoOperacion) {
		MSVDDOperacionMasiva tipoOperacion = getTipoOperacion(idTipoOperacion);
		String stringValidacion = tipoOperacion.getValidacionFormato();
		return Arrays.asList(stringValidacion.split(","));		
	}

	private int obtenerLongitudMax(String validacion) {

		int result = 0;

		if (validacion.length() >= 2) {
			String strLong = validacion.substring(1);
			try {
				result = Integer.parseInt(strLong);
			} catch (Exception e) {
				e.getMessage();
			}
		}

		return result;

	}

	/**
	 * Este m�todo comprueba que el objeto excelFile est� correcto, es decir:
	 * <ol>
	 * <li>Que contenga un fileItem</li>
	 * <li>Que el fileItem contenga un File</li>
	 * <ol>
	 * Si todo es correcto �ste m�todo termina con normalidad, si no lanza una
	 * excepci�n de tipo IllegalStateException
	 * 
	 * @param excelFile
	 * 
	 * @throws IllegalStateExcepcion
	 *             Lanza esta excepci�n si el excelFile es null o si alguna de
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
	
	private String convertListToStringSeparatedByComma(List<String> lista) {
		StringBuilder sb = new StringBuilder();
        for(String str : lista){
            sb.append(str).append(",");
        }
        return sb.toString();
	}
}