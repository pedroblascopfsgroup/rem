package es.pfsgroup.recovery.bpmframework.api;

import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputInfo;

/**
 * Plantilla de operaciones de negocio de callback para procesado batch
 * 
 * @author bruno
 * 
 */
public abstract class AbstractRecoveryBPMfwCallbackBOTemplate {

    /**
     * Operación de negocio que debe ejecutarse al iniciarse el procesado de un
     * conjunto de inputs.
     * 
     * @param idProcess
     *            Identificador del conjunto de inputs
     */
    public abstract void onStartProcess(Long idProcess);

    /**
     * Operación de negocio que debe ejecutarse al terminar el procesado de un
     * conjunto de inputs
     * 
     * @param idProcess
     *            Identificador del conjunto de inputs
     */
    public abstract void onEndProcess(Long idProcess);

    /**
     * Operación de negocio que debe ejecutarse cuando el procesado de un input
     * tiene éxito.
     * 
     * @param idProcess
     *            Identificador del conjunto de inputs
     * @param input
     *            Input pocesado.
     */
    public abstract void onSuccess(Long idProcess, RecoveryBPMfwkInputInfo input);

    /**
     * Operación de negocio a ejecutar cuando el procesado de un input falla
     * 
     * @param idProcess
     *            Identificador del conjunto de inputs
     * @param input
     *            Input procesado
     * @param errorMessage
     *            Mensaje de error
     */
    public abstract void onError(Long idProcess, RecoveryBPMfwkInputInfo input, String errorMessage);

}
