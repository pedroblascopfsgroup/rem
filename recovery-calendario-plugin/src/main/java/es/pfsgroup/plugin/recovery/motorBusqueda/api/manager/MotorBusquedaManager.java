package es.pfsgroup.plugin.recovery.motorBusqueda.api.manager;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.motorBusqueda.api.dto.DtoTareas;

/**
 * Interfaz para el motor de busqueda de tareas
 * @author Guillem
 *
 */
public interface MotorBusquedaManager {

	public static final String BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREAS_CALENDARIO = "plugin.motorBusqueda.manager.buscarTareasCalendario";
	public static final String BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREA_CALENDARIO = "plugin.motorBusqueda.manager.buscarTareaCalendario";
	public static final String BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREAS = "plugin.motorBusqueda.manager.buscarTareas";
	public static final String BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREA = "plugin.motorBusqueda.manager.buscarTarea";

	/**
	 * Metodo para la busqueda de tareas del calendario
	 * @param dto
	 * @return List<?>
	 */
	@BusinessOperationDefinition(BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREAS_CALENDARIO)
	public List<?> buscarTareasCalendario(DtoTareas dto);
	
	/**
	 * Metodo para la busqueda de una tarea del calendario
	 * @param dto
	 * @return Object
	 */
	@BusinessOperationDefinition(BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREA_CALENDARIO)
	public Object buscarTareaCalendario(DtoTareas dto);
	
	/**
	 * Metodo para la busqueda de tareas genericas
	 * @param dto
	 * @return List<?>
	 */
	@BusinessOperationDefinition(BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREAS)
	public List<?> buscarTareas(DtoTareas dto);
	
	/**
	 * Metodo para la busqueda de una tarea generica
	 * @param dto
	 * @return Object
	 */
	@BusinessOperationDefinition(BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREA)
	public Object buscarTarea(DtoTareas dto);
		
}
