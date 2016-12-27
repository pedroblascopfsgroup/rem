package es.pfsgroup.plugin.rem.propuestaprecios.service;

import java.io.File;
import java.util.List;

import javax.servlet.ServletContext;

import es.pfsgroup.plugin.rem.genericService.api.GenericService;

public interface GenerarPropuestaPreciosService extends GenericService {
	
	public static final String DEFAULT_SERVICE_BEAN_KEY = "DEFAULT";
	public static final String EXCEL_CAJAMAR_CODIGO = "01";
	public static final String EXCEL_SAREB_CODIGO = "02";
	public static final String EXCEL_BANKIA_CODIGO = "03";
	
	/**
	 * Código de tipo de operación para el que aplica este servicio.
	 * @return
	 */
	public String[] getCodigoTab();
	
	/**
	 * Carga la plantilla adecuada
	 * @param ruta
	 */
	public void cargarPlantilla(ServletContext sc);
	
	public <T> void rellenarPlantilla(String numPropuesta, String gestor, List<T> listDto);
	
	public File getFile();
	
	public void vaciarLibros();

}
