package es.pfsgroup.recovery.ext.turnadodespachos;

import java.io.IOException;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.message.Message;
import org.springframework.binding.message.Severity;
import org.springframework.context.support.AbstractMessageSource;

import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.impl.GenericABMDaoImpl;
import es.pfsgroup.plugin.recovery.coreextension.utils.UtilDiccionarioManager;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;

public class EsquemaDespachoValidacionDto {

	private Long idProceso;
	private Boolean ficheroTieneErrores;
	private List<Message> listaErrores;
	private List<EsquemaTurnadoDespachoDto> listaRegistros;
	private EsquemaTurnado esquema;
	private List<String> listaProvinciasDespacho;
	private List<String> listaProvinciasPorcentaje;
	private List<DDProvincia> diccionarioProvincias;
	

	private static final String CODIGO_ERROR_NUM_COLUMNAS = "plugin.config.esquematurnado.carga.validacion.errorNumColumnas";
	private static final String CODIGO_ERROR_SIN_CABECERA = "plugin.config.esquematurnado.carga.validacion.errorSinCabecera";
	private static final String CODIGO_ERROR_FICHERO_NOT_FOUND = "plugin.config.esquematurnado.carga.validacion.errorFicheroNoEncontrado";
	private static final String CODIGO_ERROR_CAMPO_OBL_VACIO = "plugin.config.esquematurnado.carga.validacion.errorCampoObligVacio";
	private static final String CODIGO_ERROR_CAMPO_CODIGO_INCORRECTO = "plugin.config.esquematurnado.carga.validacion.errorCampoCodigoIncorrecto";
	private static final String CODIGO_ERROR_SUMA_PORCENTAJES_PROVINCIA= "plugin.config.esquematurnado.carga.validacion.errorSumaPorcentajesProvincia";
	private static final String CODIGO_ERROR_PROVINCIA_INCORRECTA="plugin.config.esquematurnado.carga.validacion.errorNombreProvincia";
	private static final String CODIGO_ERROR_FORMATO_CALIDAD_INCORRECTO="plugin.config.esquematurnado.carga.validacion.errorValorCalidad";
	
	private static final String ERROR_AL_ACCEDER_AL_FICHERO_EXCEL = "Error al acceder al fichero Excel";
	private static final String ERROR_INESPERADO_AL_RECORRER_EL_FICHERO = "Error inesperado al recorrer el fichero";

	private static final String CODIFICACION_STRING = "s";
	private static final String OBL = "*";
	
	private static final AbstractMessageSource ms = MessageUtils.getMessageSource();
			
	private List<String> listaValidacion = Arrays.asList(new String[] {
			CODIFICACION_STRING + OBL,
			CODIFICACION_STRING + OBL,
			CODIFICACION_STRING, 
			CODIFICACION_STRING, 
			CODIFICACION_STRING,
			CODIFICACION_STRING, 
			CODIFICACION_STRING,
			CODIFICACION_STRING,
			CODIFICACION_STRING
	});
	
	
	public Long getIdProceso() {
		return idProceso;
	}
	public void setIdProceso(Long idProceso) {
		this.idProceso = idProceso;
	}
	public void setFicheroTieneErrores(Boolean ficheroTieneErrores) {
		this.ficheroTieneErrores = ficheroTieneErrores;
	}
	public Boolean getFicheroTieneErrores() {
		return ficheroTieneErrores;
	}
	public List<Message> getListaErrores() {
		return listaErrores;
	}
	public void setListaErrores(List<Message> listaErrores) {
		this.listaErrores = listaErrores;
	}
	
	public List<EsquemaTurnadoDespachoDto> getListaRegistros() {
		return this.listaRegistros;
	}
	
	public void setListaRegistros(List<EsquemaTurnadoDespachoDto> listaRegistros) {
		this.listaRegistros = listaRegistros;		
	}
	
	/**
	 * @return the esquema
	 */
	public EsquemaTurnado getEsquema() {
		return esquema;
	}
	/**
	 * @param esquema the esquema to set
	 */
	public void setEsquema(EsquemaTurnado esquema) {
		this.esquema = esquema;
	}
	
	public List<String> getListaProvinciasDespacho() {
		return listaProvinciasDespacho;
	}

	public void setListaProvinciasDespacho(List<String> listaProvinciasDespacho) {
		this.listaProvinciasDespacho = listaProvinciasDespacho;
	}

	public List<String> getListaProvinciasPorcentaje() {
		return listaProvinciasPorcentaje;
	}

	public void setListaProvinciasPorcentaje(List<String> listaProvinciasPorcentaje) {
		this.listaProvinciasPorcentaje = listaProvinciasPorcentaje;
	}
	
	public List<DDProvincia> getDiccionarioProvincias() {
		return diccionarioProvincias;
	}
	public void setDiccionarioProvincias(List<DDProvincia> diccionarioProvincias) {
		this.diccionarioProvincias = diccionarioProvincias;
	}
	
	public void validarFichero(HojaExcel exc) throws ValidationException {

		try {
			this.setFicheroTieneErrores(false);
			listaRegistros = new LinkedList<EsquemaTurnadoDespachoDto>();
			listaErrores = new LinkedList<Message>();

			// nos creamos una lista que va a tener una entrada por cada fila del fichero excel
			// cada string contendrá la concatenación de los errores de cada columna
			// si una fila no tiene ningún error se le pasará un string vacío
			List<String> cabecerasExcel = null;
			
			// recuperamos las cabeceras del excel
			if (!Checks.esNulo(exc)) {
				try {
					cabecerasExcel = exc.getCabeceras();
					// validacion de que tiene el número de columnas que esperamos
					if ((!Checks.esNulo(cabecerasExcel)) && (!Checks.estaVacio(cabecerasExcel))) {
						if (cabecerasExcel.size() != listaValidacion.size()) {
							ficheroTieneErrores = true;
							String error_num_columnas = ms.getMessage(CODIGO_ERROR_NUM_COLUMNAS, new Object[] {listaValidacion.size(), cabecerasExcel.size()}, MessageUtils.DEFAULT_LOCALE);
							listaErrores.add(new Message(this, error_num_columnas, Severity.ERROR));
						}
					} 
					else {
						ficheroTieneErrores = true;
						listaErrores.add(new Message(this, ms.getMessage(CODIGO_ERROR_SIN_CABECERA, new Object[] {}, MessageUtils.DEFAULT_LOCALE), Severity.ERROR));
					}
				} 
				catch (IOException ioe) {
					throw new ValidationException(ErrorMessageUtils.convertMessages(new Message[]{new Message(this, ERROR_AL_ACCEDER_AL_FICHERO_EXCEL, Severity.ERROR)}));
				}
			} 
			else {
				ficheroTieneErrores = true;
				listaErrores.add(new Message(this, ms.getMessage(CODIGO_ERROR_FICHERO_NOT_FOUND, new Object[] {}, MessageUtils.DEFAULT_LOCALE), Severity.ERROR));
			}
			
			if (!ficheroTieneErrores) {
				
				// validar cada una de las lineas del fichero
				for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
					
					EsquemaTurnadoDespachoDto esquemaTurnadoDespachoDto = new EsquemaTurnadoDespachoDto(); 
					
					
					// validar cada una de las columnas de cada fila
					for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {
						String contenidoCelda = exc.dameCelda(fila, columna);
						validaCelda(fila, listaValidacion.get(columna), contenidoCelda, cabecerasExcel.get(columna), esquema);
						
						if(!ficheroTieneErrores) {
							switch (columna) {
							case 0:
								esquemaTurnadoDespachoDto.setId(Long.parseLong(contenidoCelda));
								break;
							case 2:
								esquemaTurnadoDespachoDto.setTurnadoCodigoImporteLitigios(contenidoCelda);
								break;
							case 3:
								esquemaTurnadoDespachoDto.setTurnadoCodigoImporteConcursal(contenidoCelda);
								break;
							case 4:
								esquemaTurnadoDespachoDto.setTurnadoCodigoCalidadLitigios(contenidoCelda);
								break;
							case 5:
								esquemaTurnadoDespachoDto.setTurnadoCodigoCalidadConcursal(contenidoCelda);
								break;
							case 6:
								esquemaTurnadoDespachoDto.setNombreProvincia(this.corregirCharEspecialesProvincia(contenidoCelda));
								break;
							case 7:
								esquemaTurnadoDespachoDto.setProvinciaCalidadLitigio(contenidoCelda);
								break;
							case 8:
								esquemaTurnadoDespachoDto.setProvinciaCalidadConcurso(contenidoCelda);
								break;
							default:
								break;
							}	
						}
					}
					if(!ficheroTieneErrores) {
						listaRegistros.add(esquemaTurnadoDespachoDto);
					}
				}	
				
				if(ficheroTieneErrores) {
					throw new ValidationException(ErrorMessageUtils.convertMessages(listaErrores));
				}	
			}
			else {
				throw new ValidationException(ErrorMessageUtils.convertMessages(listaErrores));
			}			
		} 
		catch(ValidationException e) {
			throw e;
		}
		catch (Exception e) {
			throw new ValidationException(ErrorMessageUtils.convertMessages(new Message[]{new Message(this, ERROR_INESPERADO_AL_RECORRER_EL_FICHERO, Severity.ERROR)}));
		}
		finally {
			exc.cerrar();
		}
	}
	
	private void validaCelda(int fila, String validacion, String contenidoCelda, String cabecera, EsquemaTurnado esquemaVigente) {

		if (!Checks.esNulo(validacion)) {
			if (Checks.esNulo(contenidoCelda) && validacion.contains(OBL)) {
				ficheroTieneErrores = true;
				listaErrores.add(new Message(this, ms.getMessage(CODIGO_ERROR_CAMPO_OBL_VACIO, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE), Severity.ERROR));
			}
		}
		
		if(contenidoCelda != null && !"".equals(contenidoCelda)) {
			boolean enc = false;
			
			if(cabecera.equals("TIPO IMPORTE - LITIGIOS")) {
				
				List<EsquemaTurnadoConfig> configs = esquemaVigente.getConfiguracion();
				for(EsquemaTurnadoConfig config : configs) {
					
					if(config.getTipo().equals(EsquemaTurnadoConfig.TIPO_LITIGIOS_IMPORTE)) {
						if(contenidoCelda.equals(config.getCodigo())) {
							enc = true;
							break;
						}
					}
					
				}
				
				if(!enc) {
					ficheroTieneErrores = true;
					listaErrores.add(new Message(this, ms.getMessage(CODIGO_ERROR_CAMPO_CODIGO_INCORRECTO, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE), Severity.ERROR));
				}
			}
			else if(cabecera.equals("TIPO IMPORTE - CONCURSOS")) {
				
				List<EsquemaTurnadoConfig> configs = esquemaVigente.getConfiguracion();
				for(EsquemaTurnadoConfig config : configs) {
					
					if(config.getTipo().equals(EsquemaTurnadoConfig.TIPO_CONCURSAL_IMPORTE)) {
						if(contenidoCelda.equals(config.getCodigo())) {
							enc = true;
							break;
						}
					}
					
				}
				
				if(!enc) {
					ficheroTieneErrores = true;
					listaErrores.add(new Message(this, ms.getMessage(CODIGO_ERROR_CAMPO_CODIGO_INCORRECTO, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE), Severity.ERROR));
				}
			}
			else if(cabecera.equals("TIPO CALIDAD - LITIGIOS")) {
				
				List<EsquemaTurnadoConfig> configs = esquemaVigente.getConfiguracion();
				for(EsquemaTurnadoConfig config : configs) {
					
					if(config.getTipo().equals(EsquemaTurnadoConfig.TIPO_LITIGIOS_CALIDAD)) {
						if(contenidoCelda.equals(config.getCodigo())) {
							enc = true;
							break;
						}
					}
					
				}
				
				if(!enc) {
					ficheroTieneErrores = true;
					listaErrores.add(new Message(this, ms.getMessage(CODIGO_ERROR_CAMPO_CODIGO_INCORRECTO, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE), Severity.ERROR));
				}
			}		
			else if(cabecera.equals("TIPO CALIDAD - CONCURSOS")) {

				List<EsquemaTurnadoConfig> configs = esquemaVigente.getConfiguracion();
				for(EsquemaTurnadoConfig config : configs) {
					
					if(config.getTipo().equals(EsquemaTurnadoConfig.TIPO_CONCURSAL_CALIDAD)) {
						if(contenidoCelda.equals(config.getCodigo())) {
							enc = true;
							break;
						}
					}
					
				}
				
				if(!enc) {
					ficheroTieneErrores = true;
					listaErrores.add(new Message(this, ms.getMessage(CODIGO_ERROR_CAMPO_CODIGO_INCORRECTO, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE), Severity.ERROR));
				}
			}		
			else if(cabecera.equals("PROVINCIA")) {
				//Comprueba que la provincia exista tal y como esta en DD_PRV_PROVINCIA
				for(DDProvincia provincia : diccionarioProvincias){
					if(provincia.getDescripcion().equalsIgnoreCase(this.corregirCharEspecialesProvincia(contenidoCelda))) {
						enc = true;
						break;
					}
				}
				if(!enc) {
					ficheroTieneErrores = true;
					listaErrores.add(new Message(this, ms.getMessage(CODIGO_ERROR_PROVINCIA_INCORRECTA, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE), Severity.ERROR));
				}
			}
			else if(cabecera.equals("CALIDAD PROVINCIA - LITIGIOS")) {
				List<EsquemaTurnadoConfig> configs = esquemaVigente.getConfiguracion();
				for(EsquemaTurnadoConfig config : configs) {
					
					if(config.getTipo().equals(EsquemaTurnadoConfig.TIPO_LITIGIOS_CALIDAD)) {
						if(contenidoCelda.equals(config.getCodigo())) {
							enc = true;
							break;
						}
					}
				}
				
				if(!enc) {
					ficheroTieneErrores = true;
					listaErrores.add(new Message(this, ms.getMessage(CODIGO_ERROR_CAMPO_CODIGO_INCORRECTO, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE), Severity.ERROR));
				}
			}
			else if(cabecera.equals("CALIDAD PROVINCIA - CONCURSOS")) {
				List<EsquemaTurnadoConfig> configs = esquemaVigente.getConfiguracion();
				for(EsquemaTurnadoConfig config : configs) {
					
					if(config.getTipo().equals(EsquemaTurnadoConfig.TIPO_CONCURSAL_CALIDAD)) {
						if(contenidoCelda.equals(config.getCodigo())) {
							enc = true;
							break;
						}
					}	
				}
				
				if(!enc) {
					ficheroTieneErrores = true;
					listaErrores.add(new Message(this, ms.getMessage(CODIGO_ERROR_CAMPO_CODIGO_INCORRECTO, new Object[] {fila, cabecera}, MessageUtils.DEFAULT_LOCALE), Severity.ERROR));
				}
			}
		}
	}
	
	/**
	 * Al leer carácteres especiales de la hoja excel, y como solo afecta a las PROVINCIAS, para luego tratarlas, hacemos la corrección ya.
	 * El problema viene al leer las provincias del fichero excel, y no hay forma de tratar el carácter extraño.
	 * @param nombre
	 * @return
	 */
	private String corregirCharEspecialesProvincia(String nombre) {
		List<String> provinciasBuenas = Arrays.asList("A CORU\u00d1A", "\u00c1LAVA", "ALMER\u00cdA" , "\u00c1VILA", "C\u00c1CERES","C\u00c1DIZ","CASTELL\u00d3N","C\u00d3RDOBA","GUIP\u00daZCOA","JA\u00c9N","LE\u00d3N","L\u00c9RIDA","M\u00c1LAGA");
		List<String> provSinCharSpecials =  Arrays.asList("A CORUA","LAVA","ALMERA","VILA","CCERES","CDIZ","CASTELLN","CRDOBA","GUIPZCOA","JAN","LEN","LRIDA","MLAGA");

		nombre = nombre.toUpperCase().replaceAll("[^\\x00-\\x7F]", "");
		
		if(provSinCharSpecials.contains(nombre)){
			int pos = provSinCharSpecials.indexOf(nombre);
			nombre = provinciasBuenas.get(pos);
		}
		
		return nombre;
	}
}
