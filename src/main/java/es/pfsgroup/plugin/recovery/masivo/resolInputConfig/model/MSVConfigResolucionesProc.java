package es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model;

import java.io.Serializable;
import java.util.Map;

/**
 * Clase que contiene todos los datos de mapeo entre 
 * Tipos de Resoluci�n y Tipos de Input, 
 * para los diferentes tipos de procedimiento que hayan adoptado este sistema
 * 
 * Los datos se encontrar�n en un fichero xml de configuraci�n y Spring se 
 * encargar� de inyectarlos desde el manager desde el cual se har� uso de ellos
 * 
 * @author pedro
 *
 */

public class MSVConfigResolucionesProc implements Serializable{

	private static final long serialVersionUID = 6181409949938789726L;

	private Map<String, MSVConfigTiposResoluciones> mapaConfigResoluciones;

	public Map<String, MSVConfigTiposResoluciones> getMapaConfigResoluciones() {
		return mapaConfigResoluciones;
	}

	public void setMapaConfigResoluciones(Map<String, MSVConfigTiposResoluciones> mapaConfigResoluciones) {
		this.mapaConfigResoluciones = mapaConfigResoluciones;
	}
	
	
}
