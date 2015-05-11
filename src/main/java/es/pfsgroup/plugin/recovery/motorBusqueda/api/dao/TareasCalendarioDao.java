package es.pfsgroup.plugin.recovery.motorBusqueda.api.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.plugin.recovery.motorBusqueda.api.dto.DtoTareas;

/**
 * Interfaz de persistencia para las tareas del calendario
 * @author Guillem
 *
 */
public interface TareasCalendarioDao extends AbstractDao<EXTTareaNotificacion, Long> {

	/**
	 * Interfaz para obtencion de las tareas del calendario
	 * @param dto
	 * @return List<?>
	 */
	List<?> obtenerTareasCalendario(DtoTareas dto);
	
	/**
	 * Interfaz para obtencion de una tareas del calendario
	 * @param dto
	 * @return Object
	 */
	Object obtenerTareaCalendario(DtoTareas dto);
	
}
