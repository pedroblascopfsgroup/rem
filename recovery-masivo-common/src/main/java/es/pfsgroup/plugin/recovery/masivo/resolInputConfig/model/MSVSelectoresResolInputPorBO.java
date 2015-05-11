package es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model;

import java.io.Serializable;
import java.util.Map;

/**
 * Clase que contiene todos los datos de mapeo entre 
 * Tipos de Resoluci�n y funciones de negocio que servir�n para seleccionar
 * por funci�n de negocio los diferentes tipos de input que podr�n generarse
 * a partir de un tipo de resoluci�n 
 * 
 * Los datos se encontrar�n en un fichero xml de configuraci�n y Spring se 
 * encargar� de inyectarlos desde el manager desde el cual se har� uso de ellos
 * 
 * @author pedro
 *
 */
public class MSVSelectoresResolInputPorBO implements Serializable {

	private static final long serialVersionUID = 7913047692061239177L;

	private Map<String, MSVSelectorResolInputPorBO> mapaSelectoresBO;

	public Map<String, MSVSelectorResolInputPorBO> getMapaSelectoresBO() {
		return mapaSelectoresBO;
	}

	public void setMapaSelectoresBO(
			Map<String, MSVSelectorResolInputPorBO> mapaSelectoresBO) {
		this.mapaSelectoresBO = mapaSelectoresBO;
	}

}
