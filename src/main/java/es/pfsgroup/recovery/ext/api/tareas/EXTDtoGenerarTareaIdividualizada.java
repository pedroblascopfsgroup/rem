package es.pfsgroup.recovery.ext.api.tareas;

import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;


/**
 * Informaci�n necesaria para generar una tarea/notificaci�n destinada a un usuario particular
 * @author bruno
 *
 */
public interface EXTDtoGenerarTareaIdividualizada {
	
	/**
	 * ID del Usuario que debe recibir la tarea
	 * @return
	 */
	Long getDestinatario();
	
	/**
	 * Informaci�n necesaria para generar la tarea
	 * @return
	 */
	DtoGenerarTarea getTarea();
	
	/**
	 * Informaci�n necesaria para generar la tarea
	 * @return
	 */
	TipoCalculo getTipoCalculo();

}
