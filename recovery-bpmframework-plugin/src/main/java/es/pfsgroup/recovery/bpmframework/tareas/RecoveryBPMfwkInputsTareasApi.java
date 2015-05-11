package es.pfsgroup.recovery.bpmframework.tareas;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.tareas.model.RecoveryBPMfwkInputsTareas;

public interface RecoveryBPMfwkInputsTareasApi {
	public static final String PLUGIN_RECOVERYBPMFWK_BO_SAVE_INPUT_TAREAS = "es.pfsgroup.recovery.bpmframework.tareas.RecoveryBPMfwkInputsTareas.api.save";
	public static final String PLUGIN_RECOVERYBPMFWK_BO_GET_INPUTS_BY_TAREA= "es.pfsgroup.recovery.bpmframework.tareas.RecoveryBPMfwkInputsTareas.api.getInputsByTarea";
	
	/**
	 * Guarda la relación entre input y tarea externa
	 * @param idInput
	 * @param idTarea
	 * @return
	 */
	@BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_SAVE_INPUT_TAREAS)
	public RecoveryBPMfwkInputsTareas save(Long idInput, Long idTarea);
	
	/**
	 * Obtiene los inputs de una tarea externa
	 * @param idTarea
	 * @return
	 */
	@BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_GET_INPUTS_BY_TAREA)
	public List<RecoveryBPMfwkInput> getInputsByTarea(Long idTarea);
}
