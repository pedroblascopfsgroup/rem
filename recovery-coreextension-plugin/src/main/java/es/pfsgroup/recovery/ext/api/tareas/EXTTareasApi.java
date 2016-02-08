package es.pfsgroup.recovery.ext.api.tareas;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * API con nuevas funcionalidades del coreextension para las tareas
 * 
 * @author bruno
 * 
 */
public interface EXTTareasApi {

	public static final String EXT_CREAR_TAREA_INDIVIDUALIZADA = "es.pfsgroup.recovery.ext.api.tareas.crearTareaIndividualizada";
	public static final String EXT_BUSCAR_TAREAS_PENDIENTES_DELEGATOR = "es.pfsgroup.recovery.ext.api.tareass.buscarTareasPendientesDelegator";
	public static final String EXT_BUSCAR_TAREAS_PENDIENTES_CARTERIZACION = "es.pfsgroup.recovery.ext.api.tareas.buscarTareasPendientesConCarterizacion";
	public static final String EXT_OBTENER_CANT_TAREAS_PENDIENTES_DELEGATOR = "es.pfsgroup.recovery.ext.api.tareas.obtenerCantidadDeTareasPendientesDelegator";
	public static final String EXT_OBTENER_CANT_TAREAS_PENDIENTES_CARTERIZACION = "es.pfsgroup.recovery.ext.api.tareas.obtenerCantidadDeTareasPendientesCarterizacion";

	/**
	 * Crea una tarea individualizada, es decir, que va destinada a un usuario
	 * particular. Esta tarea siempre le va a salir al buz�n de ese usuario,
	 * independiententemente de que sea gestro o no de una unidad de gesti�n
	 * 
	 * @param dto
	 *            Informaci�n necesaria para generar la tarea
	 * @return
	 * @throws EXTCrearTareaException
	 *             Si se produce un error al generar la tarea
	 */

	@BusinessOperationDefinition(EXT_CREAR_TAREA_INDIVIDUALIZADA)
	Long crearTareaNotificacionIndividualizada(
			EXTDtoGenerarTareaIdividualizada dto) throws EXTCrearTareaException;

	/**
	 * Este m�todo, dependiendo de las funciones que tenga el usuario, delega la
	 * b�squeda de tareas a otras operaciones con opciones ampliadas. Las
	 * opciones disponbles son
	 * <ul>
	 * <li>Para la funcion BUSQUEDA_CARTERIZADA_TAREAS, devuelve las tareas
	 * teniendo en cuenta si el perfil es carterizado o no</li>
	 * </ul>
	 * 
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(EXT_BUSCAR_TAREAS_PENDIENTES_DELEGATOR)
	@Transactional
	public Page buscarTareasPendientesDelegator(DtoBuscarTareaNotificacion dto);

	/**
	 * Este m�todo, dependiendo de las funciones que tenga el usuario, delega la
	 * obtenci�n del count de todas las tareas pendientes a otras operaciones
	 * con opciones ampliadas. Las opciones disponbles son
	 * <ul>
	 * <li>Para la funcion BUSQUEDA_CARTERIZADA_TAREAS, devuelve las tareas
	 * teniendo en cuenta si el perfil es carterizado o no</li>
	 * </ul>
	 * .
	 * 
	 * @param dto
	 *            dto
	 * @return cuenta
	 */
	@BusinessOperationDefinition(EXT_OBTENER_CANT_TAREAS_PENDIENTES_DELEGATOR)
	public List<Long> obtenerCantidadDeTareasPendientesDelegator(
			DtoBuscarTareaNotificacion dto);

	/**
	 * Variante de la b�squeda de tareas con soporte para la carterizaci�n
	 * 
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(EXT_BUSCAR_TAREAS_PENDIENTES_CARTERIZACION)
	@Transactional
	public Page buscarTareasPendientesConCarterizacion(
			DtoBuscarTareaNotificacion dto);
	
	/**
	 * Variante de la obtenci�n de los contadores para las tareas pendientes con soporte para la carterizaci�n
	 * 
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(EXT_OBTENER_CANT_TAREAS_PENDIENTES_CARTERIZACION)
	public List<Long> obtenerCantidadDeTareasPendientesCarterizacion(
			DtoBuscarTareaNotificacion dto);

}
