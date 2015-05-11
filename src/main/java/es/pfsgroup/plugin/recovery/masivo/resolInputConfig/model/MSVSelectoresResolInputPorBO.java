package es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model;

import java.io.Serializable;
import java.util.Map;

/**
 * Clase que contiene todos los datos de mapeo entre 
 * Tipos de Resolución y funciones de negocio que servirán para seleccionar
 * por función de negocio los diferentes tipos de input que podrán generarse
 * a partir de un tipo de resolución 
 * 
 * Los datos se encontrarán en un fichero xml de configuración y Spring se 
 * encargará de inyectarlos desde el manager desde el cual se hará uso de ellos
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
