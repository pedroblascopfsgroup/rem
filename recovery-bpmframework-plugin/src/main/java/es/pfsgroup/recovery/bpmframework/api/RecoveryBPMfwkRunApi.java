package es.pfsgroup.recovery.bpmframework.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputInfo;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

/**
 * Operaciones de negocio para la ejecuci�n de procesos
 * 
 * @author bruno
 * 
 */
public interface RecoveryBPMfwkRunApi {

    String PLUGIN_RECOVERYBPMFWK_BO_PROCESA_INPUT = "es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkRunApi.procesaInput";
    
    /**
     * Procesa un input ejecutando en el sistema lo que marque la configuraci�n
     * para ese tipo de input
     * 
     * @param input
     *            El input puede ser un objeto persistido
     *            {@link RecoveryBPMfwkInput} o un DTO
     *            {@link RecoveryBPMfwkInputDto}, en el segundo caso el input se
     *            persiste antes de procesarse. <strong>No puede ser NULL</strong>
     * @return Long
     * 			El id del input persistido
     */
    @BusinessOperationDefinition(PLUGIN_RECOVERYBPMFWK_BO_PROCESA_INPUT)
    Long procesaInput(final RecoveryBPMfwkInputInfo input) throws RecoveryBPMfwkError;

}
