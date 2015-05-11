package es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/** 
 * Clase que contiene los objetos de configuración de tipos resolución para cada
 * tipo de procedimiento
 * 
 * Se trata de un mapa con los tipos de resoluciones implicadas en un tipo de 
 * procedimiento y la lista de alternativas  (configuraciones de input) posibles
 * 
 * Spring se encarga de recuperar los datos correspondientes desde un fichero
 * xml de configuración
 * 
 * @author pedro
 *
 */

public class MSVConfigTiposResoluciones  implements Serializable {

	private static final long serialVersionUID = -2483403869765743226L;

	private Map<String, List<MSVConfigResolInput>> mapaTiposResoluciones;

	public Map<String, List<MSVConfigResolInput>> getMapaTiposResoluciones() {
		return mapaTiposResoluciones;
	}

	public void setMapaTiposResoluciones(
			Map<String, List<MSVConfigResolInput>> mapaTiposResoluciones) {
		this.mapaTiposResoluciones = mapaTiposResoluciones;
	}

//	public Map<String, List<MSVConfigResolInput>> getMapaTipoResolucion() {
//		return mapaTiposResoluciones;
//	}
//
//	public void setMapaTipoResolucion(Map<String, List<MSVConfigResolInput>> mapaTipoResolucion) {
//		this.mapaTiposResoluciones = mapaTipoResolucion;
//	}

	
}
