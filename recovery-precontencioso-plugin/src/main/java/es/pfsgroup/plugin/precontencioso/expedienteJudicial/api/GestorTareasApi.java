package es.pfsgroup.plugin.precontencioso.expedienteJudicial.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface GestorTareasApi {

	public static final String BO_PCO_GESTOR_TAREAS_RECALCULAR = "es.pfsgroup.plugin.precontencioso.expedienteJudicial.recalcularTareasPreparacionDocumental";
	public static final String BO_PCO_GESTOR_TAREAS_RECALCULAR_ESTADO = "es.pfsgroup.plugin.precontencioso.expedienteJudicial.recalcularTareasPreparacionDocumentalEstado";
	public static final String BO_PCO_GESTOR_TAREAS_CREAR = "es.pfsgroup.plugin.precontencioso.expedienteJudicial.crearTareaEspecial";
	public static final String BO_PCO_GESTOR_TAREAS_CANCELAR = "es.pfsgroup.plugin.precontencioso.expedienteJudicial.cancelarTareaEspecial";

	/**
	 * Recalcula todas las acciones sobre las tareas (crear, cancelar)
	 * 
	 * @param idProc
	 * @return
	 */
	@BusinessOperationDefinition(BO_PCO_GESTOR_TAREAS_RECALCULAR)
	void recalcularTareasPreparacionDocumental (Long idProc);
	
	/**
	 * Recalcula todas las acciones sobre las tareas (crear, cancelar)
	 * 
	 * @param idProc
	 * @return
	 */
	@BusinessOperationDefinition(BO_PCO_GESTOR_TAREAS_RECALCULAR_ESTADO)
	void recalcularTareasPreparacionDocumental (Long idProc, String estadoActualizado);
	
	/**
	 * Crear una tarea especial
	 * 
	 * @param idProc
	 * @param tipoTarea
	 * @return resultado de la operación
	 */
	@BusinessOperationDefinition(BO_PCO_GESTOR_TAREAS_CREAR)
	boolean crearTareaEspecial (Long idProc, String tipoTarea);
	
	/**
	 * Cancelar una tarea especial
	 * 
	 * @param idProc
	 * @param tipoTarea
	 * @return resultado de la operación
	 */
	@BusinessOperationDefinition(BO_PCO_GESTOR_TAREAS_CANCELAR)
	boolean cancelarTareaEspecial (Long idProc, String tipoTarea);
	
}
