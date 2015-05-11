package es.pfsgroup.plugin.recovery.calendario.api.web.handler;

import es.pfsgroup.plugin.recovery.motorBusqueda.api.dto.DtoTareas;

/**
 * Interfaz para el manejo de la capa de presentaci�n
 * @author Guillem
 *
 */
public interface CalendarioViewHandler {
    
	/**
	 * M�todo que chequea el tipo de subtarea
	 * @param subtipoTarea
	 * @return
	 */
	public boolean isValid(String subtipoTarea);

	/**
	 * M�todo que obtiene el objeto a enviar a la capa de presentaci�n
	 * @param dto
	 * @param businessOperation
	 * @return
	 */
    public Object getModel(DtoTareas dto);

    /**
     * M�todo que obtiene la ruta de la jsp que se servir� a la capa de presentaci�n
     * @return
     */
    public String getJspName();
    
}
