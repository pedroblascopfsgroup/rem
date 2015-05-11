package es.pfsgroup.plugin.recovery.mejoras.web.tareas;

import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;

/**
 * Factoría de ViewHandlers para los Buzones de Tareas.
 * <p>
 * Estas factorías se encargan de generar los manejadores para abrir Tareas.
 * 
 * @author bruno
 *
 */
public interface BuzonTareasViewHandlerFactory {

	/**
	 * Devuelve un manejador para abrir tareas en función de su subTipo
	 * 
	 * @param subtipoTarea Código del Subtipo de Trarea.
	 * <p> El diccionario de Subtipos de Tarea está representado por la clase {@link SubtipoTarea}.
	 * @return
	 */
	BuzonTareasViewHandler getHandlerForSubtipoTarea(String subtipoTarea);

}
