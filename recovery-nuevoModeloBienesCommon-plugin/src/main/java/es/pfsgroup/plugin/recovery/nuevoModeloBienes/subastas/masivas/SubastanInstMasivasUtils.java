package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.masivas;

import java.io.IOException;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.context.support.AbstractMessageSource;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.utils.MessageUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.plugin.recovery.masivo.ValidationError;
import es.pfsgroup.plugin.recovery.masivo.dto.ResultadoValidacion;
import es.pfsgroup.plugin.recovery.masivo.utils.MSVExcelValidator;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dto.GuardarInstruccionesDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.manager.SubastaInstMasivasLoteDto;

@Service
public class SubastanInstMasivasUtils {

	private static final String NO = "NO";
	private static final String N = "N";
	private static final String SI = "SI";
	private static final String S = "S";
	private static final String MAXIMO_FILAS_POR_DEFECTO = "5000";
	private static final String DDMMYYYY = "ddMMyyyy";
	private static final String FORMATO_DECIMAL_POR_DEFECTO = "0.#";

	private static final String ERROR_AL_ACCEDER_AL_FICHERO_EXCEL = "Error al acceder al fichero Excel";
	private static final String ERROR_INESPERADO_AL_RECORRER_EL_FICHERO = "Error inesperado al recorrer el fichero";
	
	private static final String KEY_NUMERO_MAXIMO_FILAS = "masivo.cargaExcel.maxFilas";
	
	private final String XLS_TYPE="application/vnd.ms-excel";
	private final String XLSX_TYPE="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";			

	private static final String CODIGO_ERROR_TIPO_FICHERO_INCORRECTO="plugin.nuevoModeloBienes.instruccionesMasivas.errorTipoFicheroIncorrecto";
	private static final String CODIGO_ERROR_NUM_FILAS="plugin.nuevoModeloBienes.instruccionesMasivas.errorNumFilas";
	private static final String CODIGO_ERROR_NUM_COLUMNAS="plugin.nuevoModeloBienes.instruccionesMasivas.errorNumColumnas";
	private static final String CODIGO_ERROR_TAMANYO_MINIMO = "plugin.nuevoModeloBienes.instruccionesMasivas.errorTamanyoMinimo";
	private static final String CODIGO_ERROR_TAMANYO_MAXIMO = "plugin.nuevoModeloBienes.instruccionesMasivas.errorTamanyoMaximo";
	private static final String CODIGO_ERROR_SIN_CABECERA = "plugin.nuevoModeloBienes.instruccionesMasivas.errorSinCabecera";
	private static final String CODIGO_ERROR_FICHERO_NOT_FOUND = "plugin.nuevoModeloBienes.instruccionesMasivas.errorFicheroNoEncontrado";

	private static final String CODIGO_ERROR_CAMPO_OBL_VACIO = "plugin.nuevoModeloBienes.instruccionesMasivas.errorCampoObligVacio";
	private static final String CODIGO_ERROR_CAMPO_NUMERICO = "plugin.nuevoModeloBienes.instruccionesMasivas.errorNumericoNoValido";
	private static final String CODIGO_ERROR_CAMPO_IMPORTE = "plugin.nuevoModeloBienes.instruccionesMasivas.errorImporteNoValido";
	private static final String CODIGO_ERROR_CAMPO_FECHA = "plugin.nuevoModeloBienes.instruccionesMasivas.errorFechaNoValida";
	private static final String CODIGO_ERROR_CAMPO_BOOLEANO = "plugin.nuevoModeloBienes.instruccionesMasivas.errorLongitudMaxima";
	private static final String CODIGO_ERROR_LONGITUD_MAXIMA = "plugin.nuevoModeloBienes.instruccionesMasivas.errorBooleanoNoValido";

	private static final AbstractMessageSource ms = MessageUtils.getMessageSource();
	private static final String SALTO_LINEA = "      ";
	private static final String CODIGO_ERROR_LOTE_FECHA = "plugin.nuevoModeloBienes.instruccionesMasivas.errorLoteFSubasta";
	private static final String CODIGO_ERROR_LOTE_NUMAUTOS = "plugin.nuevoModeloBienes.instruccionesMasivas.errorLoteNumAutos";
	private static final String CODIGO_ERROR_LOTE_NO_ASIGNADO = "plugin.nuevoModeloBienes.instruccionesMasivas.errorLoteNoAsignado";

	private final String OBL = "*";
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private GenericABMDao genericDao;

	private List<String> listaValidacion = Arrays.asList(new String[] {
			MSVExcelValidator.CODIFICACION_STRING, MSVExcelValidator.CODIFICACION_FECHA, 
			MSVExcelValidator.CODIFICACION_NUMERICA + OBL, 
			MSVExcelValidator.CODIFICACION_IMPORTE + OBL, MSVExcelValidator.CODIFICACION_IMPORTE + OBL,
			MSVExcelValidator.CODIFICACION_IMPORTE + OBL, MSVExcelValidator.CODIFICACION_IMPORTE + OBL,
			MSVExcelValidator.CODIFICACION_IMPORTE + OBL, MSVExcelValidator.CODIFICACION_STRING});
	
	private DecimalFormat format;
	private SimpleDateFormat df;

	public SubastanInstMasivasUtils() {
		format = new DecimalFormat(FORMATO_DECIMAL_POR_DEFECTO);
		df = new SimpleDateFormat(DDMMYYYY);
		df.setLenient(false);
		DecimalFormatSymbols symbols = new DecimalFormatSymbols();
		symbols.setDecimalSeparator(',');
		format.setDecimalFormatSymbols(symbols);
	}
	
	public boolean tipoFicheroCorrecto(String contentType) {
		return (XLS_TYPE.equals(contentType) || XLSX_TYPE.equals(contentType));
	}
    

	public HojaExcel obtenerExcel(FileItem fileItem) {
		
		HojaExcel exc = new HojaExcel();
		exc.setFile(fileItem.getFile());
		exc.setRuta(fileItem.getFile().getAbsolutePath());
		return exc;
		
	}
	
	public SubastaInstMasivasValidacionDto validarFormatoFichero(HojaExcel exc) {

		try {
			SubastaInstMasivasValidacionDto dto = new SubastaInstMasivasValidacionDto();
			dto.setFicheroTieneErrores(false);

			// nos creamos una lista que va a tener una entrada por cada fila del fichero excel
			// cada string contendrá la concatenación de los errores de cada columna
			// si una fila no tiene ningún error se le pasará un string vacío
			List<String> listaErrores = new ArrayList<String>();

			// validamos las especificaciones básicas
			// si tiene errores previos no será necesario analizar el fichero
			Boolean erroresPrevios = false;

			List<String> cabecerasExcel = null;
			
			String numeroMaximoFilas = appProperties.getProperty(KEY_NUMERO_MAXIMO_FILAS);
			if (numeroMaximoFilas == null) {
				numeroMaximoFilas = MAXIMO_FILAS_POR_DEFECTO;
			}
			// recuperamos las cabeceras del excel
			if (!Checks.esNulo(exc)) {
				try {
					// validacion tamaño minimo
					if (exc.getNumeroFilas() < 2) {
						erroresPrevios = true;
						listaErrores.add(ms.getMessage(CODIGO_ERROR_TAMANYO_MINIMO, new Object[] {}, MessageUtils.DEFAULT_LOCALE));
					}
					cabecerasExcel = exc.getCabeceras();
					if (exc.getNumeroFilas() > Integer.parseInt(numeroMaximoFilas)) {
						erroresPrevios = true;
						listaErrores.add(ms.getMessage(CODIGO_ERROR_TAMANYO_MAXIMO, new Object[] {}, MessageUtils.DEFAULT_LOCALE));
					}
					// validacion de que tiene el número de columnas que esperamos
					if ((!Checks.esNulo(cabecerasExcel)) && (!Checks.estaVacio(cabecerasExcel))) {
						if (cabecerasExcel.size() != listaValidacion.size()) {
							erroresPrevios = true;
							String error_num_columnas = ms.getMessage(CODIGO_ERROR_NUM_COLUMNAS, 
									new Object[] {listaValidacion.size(), cabecerasExcel.size()}, MessageUtils.DEFAULT_LOCALE);
							listaErrores.add(error_num_columnas);
						}
					} else {
						erroresPrevios = true;
						listaErrores.add(ms.getMessage(CODIGO_ERROR_SIN_CABECERA, new Object[] {}, MessageUtils.DEFAULT_LOCALE));
					}
				} catch (IOException ioe) {
					throw new ValidationError(ERROR_AL_ACCEDER_AL_FICHERO_EXCEL, ioe);
				}
			} else {
				erroresPrevios = true;
				listaErrores.add(ms.getMessage(CODIGO_ERROR_FICHERO_NOT_FOUND, new Object[] {}, MessageUtils.DEFAULT_LOCALE));
			}
			// validacion tamaño maximo
			boolean erroresContenido = false;
			if (!erroresPrevios) {
				// validar cada una de las lineas del fichero
				for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
					StringBuilder errorDesc = new StringBuilder();
					// validar cada una de las columnas de cada fila
					for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {
						String contenidoCelda = exc.dameCelda(fila, columna);
						ResultadoValidacion resultadoValidacion = 
								validaCelda(fila, listaValidacion.get(columna), contenidoCelda, cabecerasExcel.get(columna));
						errorDesc.append((resultadoValidacion.getErroresFila() != null ? resultadoValidacion.getErroresFila() : ""));
						if (!resultadoValidacion.getValido()) {
							erroresContenido = true;
						}
					}
					listaErrores.add(errorDesc.toString());
				}
			}

			if (erroresPrevios || erroresContenido) {
				dto.setFicheroTieneErrores(true);
				dto.setListaErrores(listaErrores);
			} else {
				dto.setFicheroTieneErrores(false);
				dto.setListaErrores(null);
			}
			exc.cerrar();

			return dto;
		} catch (ValidationError ve) {
			throw ve;
		} catch (Exception e) {
			throw new RuntimeException(ERROR_INESPERADO_AL_RECORRER_EL_FICHERO, e);
		}
	}

	private ResultadoValidacion validaCelda(int fila, String validacion, String contenidoCelda, String cabecera) {

		final String errObligatorio = ms.getMessage(CODIGO_ERROR_CAMPO_OBL_VACIO, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE);
		final String errNumerico = ms.getMessage(CODIGO_ERROR_CAMPO_NUMERICO, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE);
		final String errImporte = ms.getMessage(CODIGO_ERROR_CAMPO_IMPORTE, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE);
		final String errFecha = ms.getMessage(CODIGO_ERROR_CAMPO_FECHA, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE);
		final String errBooleano = ms.getMessage(CODIGO_ERROR_CAMPO_BOOLEANO, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE);

		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);
		resultado.setErroresFila("");
		if (!Checks.esNulo(validacion)) {
			if (Checks.esNulo(contenidoCelda) && validacion.contains(OBL)) {
				resultado.setValido(false);
				resultado.setErroresFila(errObligatorio);
			} else if (Checks.esNulo(contenidoCelda) && (!validacion.contains(OBL))) {
				// Bruno 26/2/2013 En este caso no hacemos nada, si el campo no
				// es obligatorio y est� vac�o valida
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
					String errLongitud = ms.getMessage(CODIGO_ERROR_LONGITUD_MAXIMA, new Object[] {fila, cabecera, longitudMax}, MessageUtils.DEFAULT_LOCALE);
					resultado.setErroresFila(errLongitud);
				}
			} else if (MSVExcelValidator.CODIGO_BOOLEAN.equals(validacion.substring(0, 1))) {
				if (!contenidoCelda.equalsIgnoreCase(S) && !contenidoCelda.equalsIgnoreCase(SI) && 
						!contenidoCelda.equalsIgnoreCase(N) && !contenidoCelda.equalsIgnoreCase(NO)) {
					resultado.setValido(false);
					resultado.setErroresFila(errBooleano);
				}
			}
		}
		// Cualquier otro formato se ignora
		return resultado;
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

	public List<SubastaInstMasivasLoteDto> recuperarLotes(HojaExcel exc) {
		List<SubastaInstMasivasLoteDto> listaLotes = new ArrayList<SubastaInstMasivasLoteDto>();
		
		try {
			int numColumnas = exc.getCabeceras().size();
			int numFilas = exc.getNumeroFilas();
			
			for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
				SubastaInstMasivasLoteDto lote = new SubastaInstMasivasLoteDto();
				for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {	
					lote = rellenaLote(lote, exc.dameCelda(fila, columna), columna);
				}
				listaLotes.add(lote);
			}
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return listaLotes;
	}

	private SubastaInstMasivasLoteDto rellenaLote(SubastaInstMasivasLoteDto lote, String valor, int columna) {
		
		try {
			if (columna==0) {
				lote.setNumAutos(valor);
			} else if (columna==1) {
				lote.setFechaSubasta(df.parse(valor));
			} else if (columna==2) {
				lote.setIdLote(Long.parseLong(valor));
			} else if (columna==3) {
				lote.setPujaSinPostores(format.parse(valor).floatValue());
			} else if (columna==4) {
				lote.setPujaPostoresDesde(format.parse(valor).floatValue());
			} else if (columna==5) {
				lote.setPujaPostoresHasta(format.parse(valor).floatValue());
			} else if (columna==6) {
				lote.setValorSubasta(format.parse(valor).floatValue());
			} else if (columna==7) {
				lote.setDeudaJudicial(format.parse(valor).floatValue());
			} else if (columna==8) {
				lote.setInstrucciones(valor);
			}
		} catch (NumberFormatException e) {
		} catch (ParseException e) {
		}
		return lote;

	}

	public List<String> validacionesNegocio(Long idSubasta,
			List<SubastaInstMasivasLoteDto> listaLotes) {

		List<String> erroresValidacion = new ArrayList<String>();
		
		Subasta subasta = obtenerSubasta(idSubasta);
		
		//Comprobar número de lotes de la subasta
		String errorNumLotes = validarNumeroLotes(subasta, listaLotes.size());
		if (!Checks.esNulo(errorNumLotes)) {
			erroresValidacion.add(errorNumLotes);
		}

		for (SubastaInstMasivasLoteDto lote : listaLotes) {
			String errorLote = validarLote(subasta, lote);
			if (!Checks.esNulo(errorLote)) {
				erroresValidacion.add(errorLote);
			}
		}
		
		return erroresValidacion;
	}

	private Subasta obtenerSubasta(Long idSubasta) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idSubasta);
		return genericDao.get(Subasta.class, filtro);
	}

	private String validarNumeroLotes(Subasta subasta, int numFilas) {
		
		String resultado = null;
		int numLotes = subasta.getLotesSubasta().size();
		if (numLotes != numFilas) {
			resultado = ms.getMessage(CODIGO_ERROR_NUM_FILAS, new Object[] {numFilas, numLotes}, MessageUtils.DEFAULT_LOCALE);
		}
		return resultado;
	}

	private String validarLote(Subasta subasta, SubastaInstMasivasLoteDto lote) {

		boolean existeLote = false;
		StringBuilder mensaje = new StringBuilder();
		
		for (LoteSubasta loteSubasta : subasta.getLotesSubasta()) {
			if (loteSubasta.getId().equals(lote.getIdLote())) {
				existeLote = true;
			}
		}
		if (!existeLote) {
			mensaje.append(ms.getMessage(CODIGO_ERROR_LOTE_NO_ASIGNADO, new Object[] {lote.getIdLote()}, MessageUtils.DEFAULT_LOCALE)).append(SALTO_LINEA);
		}
		
		if (!Checks.esNulo(subasta.getNumAutos()) && 
				!Checks.esNulo(lote.getNumAutos()) && 
				!subasta.getNumAutos().equals(lote.getNumAutos())) {
			mensaje.append(ms.getMessage(CODIGO_ERROR_LOTE_NUMAUTOS, new Object[] {lote.getIdLote()}, MessageUtils.DEFAULT_LOCALE)).append(SALTO_LINEA);
		}
		
		if (!Checks.esNulo(subasta.getFechaSenyalamiento()) && 
				!Checks.esNulo(lote.getFechaSubasta()) && 
				!subasta.getFechaSenyalamiento().equals(lote.getFechaSubasta())) {
			mensaje.append(ms.getMessage(CODIGO_ERROR_LOTE_FECHA, new Object[] {lote.getIdLote()}, MessageUtils.DEFAULT_LOCALE)).append(SALTO_LINEA);
		}
		
		return mensaje.toString();
		
	}

	public GuardarInstruccionesDto obtenerDtoGuardaInstruccionesLoteSubasta(
			SubastaInstMasivasLoteDto lote) {
		String cero = "0.0"				;
		
		GuardarInstruccionesDto dto = new GuardarInstruccionesDto();
		dto.setDeudaJudicial(lote.getDeudaJudicial().toString());
		dto.setIdLote(lote.getIdLote().toString());
		dto.setObservaciones(lote.getInstrucciones());
		dto.setPujaPostoresDesde(lote.getPujaPostoresDesde().toString());
		dto.setPujaPostoresHasta(lote.getPujaPostoresHasta().toString());
		dto.setPujaSinPostores(lote.getPujaSinPostores().toString());
		dto.setRiesgoConsignacion(cero);
		dto.setTipoSubasta50(cero);
		dto.setTipoSubasta60(cero);
		dto.setTipoSubasta70(cero);
		dto.setValorSubasta(lote.getValorSubasta().toString());
		
		return dto;
	}

	
	public String transformarListaAString(List<String> lista) {
		StringBuffer mensaje = new StringBuffer();
		for (String string : lista) {
			mensaje.append(string).append(SALTO_LINEA);
		}
		return mensaje.toString();
	}

	public String obtenerMensajeErrorTipoIncorrecto() {
		return ms.getMessage(CODIGO_ERROR_TIPO_FICHERO_INCORRECTO, new Object[] {}, MessageUtils.DEFAULT_LOCALE);
	}

}
