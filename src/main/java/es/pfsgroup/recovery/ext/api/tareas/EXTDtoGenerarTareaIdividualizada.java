package es.pfsgroup.recovery.ext.api.tareas;

import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;


/**
 * Información necesaria para generar una tarea/notificación destinada a un usuario particular
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
	 * Información necesaria para generar la tarea
	 * @return
	 */
	DtoGenerarTarea getTarea();
	
	/**
	 * Información necesaria para generar la tarea
	 * @return
	 */
	TipoCalculo getTipoCalculo();

}
