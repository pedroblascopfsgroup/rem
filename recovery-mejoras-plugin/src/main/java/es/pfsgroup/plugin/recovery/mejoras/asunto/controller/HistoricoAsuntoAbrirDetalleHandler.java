package es.pfsgroup.plugin.recovery.mejoras.asunto.controller;

import es.pfsgroup.plugin.recovery.mejoras.web.viewHandlers.RecoveryViewHandler;

/**
 * Hay que implementar esta interfaz para que el Hist�rico del Asunto sepa c�mo abrir un tipo concreto de tareas
 * @author bruno
 *
 */
public interface HistoricoAsuntoAbrirDetalleHandler extends RecoveryViewHandler{

	/**
	 * Este es el objeto que se le pasar� a la JSP para que muesre los datos
	 * @return
	 */
	Object getViewData(Long idTarea, Long idTraza, Long idEntidad);

	/**
	 * Este es el nombre de la JSP que queremos mostrar.
	 * @return
	 */
	String getJspName();
}
