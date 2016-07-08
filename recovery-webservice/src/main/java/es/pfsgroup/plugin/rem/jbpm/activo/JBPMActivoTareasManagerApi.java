package es.pfsgroup.plugin.rem.jbpm.activo;

import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;


public interface JBPMActivoTareasManagerApi {

	/**
	 * Devuelve el plazo (en milisegundos) de una tarea de un procedimiento.
	 * @@param idTipoTarea id del tipo de tarea
	 * @param idTramite id del trámite al que pertenece
	 * @return plazo de la tarea en milisegundos
	 */
	// Se ha creado una factoria para implementar esta tarea
	//public Long getPlazoTarea(Long idTipoTarea, Long idTramite);
	
	
    /**
     * Método que inicializa las fechas de una tarea.
     * @param tarea Tarea del BPM para inicializar las fechas
     */
	public void iniciaFechasTarea(TareaNotificacion tarea, ExecutionContext executionContext);

}
