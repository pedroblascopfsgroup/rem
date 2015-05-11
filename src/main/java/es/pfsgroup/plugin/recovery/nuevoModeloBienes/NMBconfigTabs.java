package es.pfsgroup.plugin.recovery.nuevoModeloBienes;

import java.util.Map;

/**
 * Contiene los tabs seg�n el tipo de bien.
 * La configuraci�n se carga mediante fichero xml.
 * 
 * @author carlos
 *
 */
public interface NMBconfigTabs {

	/**
	 * Recupera el listado tabas para tipos de bien
	 *  
	 * @return
	 */
	public Map<String, NMBconfigTabsTipoBien> getMapaTabsTipoBien();

}
