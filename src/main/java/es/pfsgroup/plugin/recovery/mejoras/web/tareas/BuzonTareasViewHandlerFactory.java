package es.pfsgroup.plugin.recovery.mejoras.web.tareas;

import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;

/**
 * Factor�a de ViewHandlers para los Buzones de Tareas.
 * <p>
 * Estas factor�as se encargan de generar los manejadores para abrir Tareas.
 * 
 * @author bruno
 *
 */
public interface BuzonTareasViewHandlerFactory {

	/**
	 * Devuelve un manejador para abrir tareas en funci�n de su subTipo
	 * 
	 * @param subtipoTarea C�digo del Subtipo de Trarea.
	 * <p> El diccionario de Subtipos de Tarea est� representado por la clase {@link SubtipoTarea}.
	 * @return
	 */
	BuzonTareasViewHandler getHandlerForSubtipoTarea(String subtipoTarea);

}
