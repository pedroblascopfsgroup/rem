package es.pfsgroup.recovery.bpmframework.bpm;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.api.JBPMProcessApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

/**
 * Operaciones de negocio que exitenenden las funcionalidades de
 * {@link JBPMProcessApi} y {@link EXTJBPMProcessApi}, para incluir los Inputs
 * 
 * @author bruno
 * 
 */
public interface RecoveryBPMFwkProcessApi {

    static final String PLUGIN_RECOVERYBPMFWK_BO_BPM_SIGNAL_PROCESS = "es.pfsgroup.recovery.bpmframework.bpm.signalProcess";
    static final String PLUGIN_RECOVERYBPMFWK_BO_BPM_GET_INPUTS_FOR_NODE = "es.pfsgroup.recovery.bpmframework.bpm.getInputsForNode";
    static final String PLUGIN_RECOVERYBPMFWK_BO_BPM_GET_INPUTS_FOR_PRC = "es.pfsgroup.recovery.bpmframework.bpm.getInputsForPrc";

    /**
     * Avanza un BPM por una transici�n dejando constancia de cual ha sido el
     * Input que ha provocado el avance.
     * 
     * @param idProcess
     * @param transitionName
     * @param input
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_BPM_SIGNAL_PROCESS)
    void signalProcess(final Long idProcess, final String transitionName, final RecoveryBPMfwkInput input);

    /**
     * Devuelve una lista de ids de los id's de input que han provocado la
     * salida de un nodo.
     * 
     * @param nodeName
     * @return
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_BPM_GET_INPUTS_FOR_NODE)
    List<Long> getInputsForNode(String nodeName);
    
    /**
     * Devuelve una lista de inputs que han tenido lugar en un procedimiento
     * @param idProcedimiento
     * @return
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_BPM_GET_INPUTS_FOR_PRC)
    List<RecoveryBPMfwkInput> getInputsForPrc(Long idProcedimiento);

}
