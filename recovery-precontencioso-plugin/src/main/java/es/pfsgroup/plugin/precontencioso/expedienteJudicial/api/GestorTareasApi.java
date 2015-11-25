package es.pfsgroup.plugin.precontencioso.expedienteJudicial.api;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface GestorTareasApi {

	public static final String BO_PCO_GESTOR_TAREAS_RECALCULAR = "es.pfsgroup.plugin.precontencioso.expedienteJudicial.recalcularTareasPreparacionDocumental";
	public static final String BO_PCO_GESTOR_TAREAS_RECALCULAR_ESTADO = "es.pfsgroup.plugin.precontencioso.expedienteJudicial.recalcularTareasPreparacionDocumentalEstado";
	public static final String BO_PCO_GESTOR_TAREAS_CREAR = "es.pfsgroup.plugin.precontencioso.expedienteJudicial.crearTareaEspecial";
	public static final String BO_PCO_GESTOR_TAREAS_CANCELAR = "es.pfsgroup.plugin.precontencioso.expedienteJudicial.cancelarTareaEspecial";
	public static final String BO_PCO_ES_TAREA_ESPECIAL = "es.pfsgroup.plugin.precontencioso.expedienteJudicial.esTareaEspecial";

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
	
	
	/**
	 * Devuelve si una tarea de precontencioso es de tipo especial
	 * 
	 * @param tareaId
	 * @return resultado de la operación
	 */
	@BusinessOperationDefinition(BO_PCO_ES_TAREA_ESPECIAL)
	boolean getEsTareaPrecontenciosoEspecial(Long tareaId);
	
	/**
	 * Comprueba si existe la tarea del código especificado, asociada al procedimiento pasado como parámetro
	 * @param proc
	 * @param codigoTarea
	 * @return
	 */
	boolean existeTarea(Procedimiento proc, String codigoTarea);
	
}
