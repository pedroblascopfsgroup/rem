package es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model;

import java.io.Serializable;
import java.util.Map;

/**
 * Clase que contiene todos los datos de mapeo entre 
 * Tipos de Resolución y Tipos de Input, 
 * para los tipos de input que se pueden introducir por ficheros excel
 * 
 * Los datos se encontrarán en un fichero xml de configuración y Spring se 
 * encargará de inyectarlos desde el manager desde el cual se hará uso de ellos
 * 
 * @author pedro
 *
 */

public class MSVConfigResolucionesBatch implements Serializable{

	private static final long serialVersionUID = -8396485597305606382L;

	private Map<String, String> mapaConfigResolucionesBatch;

	public Map<String, String> getMapaConfigResolucionesBatch() {
		return mapaConfigResolucionesBatch;
	}

	public void setMapaConfigResolucionesBatch(Map<String, String> mapaConfigResolucionesBatch) {
		this.mapaConfigResolucionesBatch = mapaConfigResolucionesBatch;
	}
	
	
}
