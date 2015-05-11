package es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model;

import java.io.Serializable;
import java.util.Map;

/**
 * Clase que contiene todos los datos de mapeo entre 
 * Tipos de Resoluci�n y Tipos de Input, 
 * para los tipos de input que se pueden introducir por ficheros excel
 * 
 * Los datos se encontrar�n en un fichero xml de configuraci�n y Spring se 
 * encargar� de inyectarlos desde el manager desde el cual se har� uso de ellos
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
