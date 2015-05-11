package es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTareaResumen.dao;

import java.util.List;

import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoPanelControlFiltros;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTareaResumen.model.PCExpedienteTareaResumen;

public interface PCExpedienteTareaResumenDao {
	
	/**
	 * Recupera las tareas de los letrados a través de la vista resumen
	 * param id de letrado
	 * return List<PCExpedienteTareaResumen> 
	 */
	public List<PCExpedienteTareaResumen>  buscaTareasPendientesLetradosPanelControl(String idLetrado);

	/**
	 * Recupera el número total de expedientes a través de la vista resumen
	 * param codigo de la zona
	 * return Long
	 */
	public Long getNumeroExpedientes(String codigo);

	/**
	 * Recupera el importe total de expedientes a través de la vista resumen
	 * param codigo de la zona
	 * return Float
	 */
	public Float getImporteExpedientes(String cod);

	/**
	 * Recupera el número total de tareas a través de la vista resumen
	 * agrupado por tipo o rango de tarea que se desea obtener
	 * param codigo de la zona, rango: tipo de tarea
	 * return Long
	 */
	public Long totalTareasPendientes(String cod, int rango);

	/**
	 * Obtiene la última fecha de refresco de la vista resumen de tareas
	 * @return String
	 */
	public String getFechaRefresco();

	
}
