package es.pfsgroup.plugin.recovery.calendario.api.web.handler;

import es.pfsgroup.plugin.recovery.motorBusqueda.api.dto.DtoTareas;

/**
 * Interfaz para el manejo de la capa de presentación
 * @author Guillem
 *
 */
public interface CalendarioViewHandler {
    
	/**
	 * Método que chequea el tipo de subtarea
	 * @param subtipoTarea
	 * @return
	 */
	public boolean isValid(String subtipoTarea);

	/**
	 * Método que obtiene el objeto a enviar a la capa de presentación
	 * @param dto
	 * @param businessOperation
	 * @return
	 */
    public Object getModel(DtoTareas dto);

    /**
     * Método que obtiene la ruta de la jsp que se servirá a la capa de presentación
     * @return
     */
    public String getJspName();
    
}
