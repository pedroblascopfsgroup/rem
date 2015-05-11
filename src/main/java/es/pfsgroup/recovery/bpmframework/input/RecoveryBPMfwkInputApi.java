package es.pfsgroup.recovery.bpmframework.input;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

/**
 * Operaciones de negocio para el ABM de Inputs
 * 
 * @author bruno
 * 
 */
public interface RecoveryBPMfwkInputApi {
    
    String PLUGIN_RECOVERYBPMFWK_BO_SAVE_INPUT = "es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi.saveInput";
    public static final String PLUGIN_RECOVERYBPMFWK_BO_GET_INPUT = "es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi.get";

    /**
     * Persiste un INPUT nuevo
     * 
     * @param input
     * 
     * @return Devuelve el id del input persistido
     * 
     * @throws RecoveryBPMfwkError Si hay alg�n problema al guardar el input
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_SAVE_INPUT)
    RecoveryBPMfwkInput saveInput(RecoveryBPMfwkInputDto input) throws RecoveryBPMfwkError;

    /**
     * Obtiene un input a partir de su ID
     * @param idInput
     * @return
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_GET_INPUT)
    public RecoveryBPMfwkInput get(Long idInput);
}
