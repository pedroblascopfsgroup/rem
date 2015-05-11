package es.pfsgroup.recovery.bpmframework.run.factory;

import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputExecutor;

/**
 * Interfaz para la factor�a de InputExecutors. Un input executor se encarga de
 * procesar un input. Esta factor�a devuelve el InputExecutor correcto
 * dependiendo de las caracter�sticas del input a procesar
 * 
 * @author bruno
 * 
 */
public interface RecoveryBPMfwkInputExecutorFactory {

    /**
     * Devuelve un InputExecutor adecuado para procesar un determinado input
     * @param input Input que se quere procesar <strong>no puede ser null</strong>. 
     * @return
     * @throws RecoveryBPMfwkError 
     * 
     * @throws IllegalArgumentException Si el input es null o si no contiene informaci�n necesaria
     * <ul>
     * <li>Tipo de input -> Tipo de accion</li>
     * <li>Si el tipo de acci�n es distinto a INFORMAR_DATOS, AVANCE_BPM o FORWARD</li>
     * <li>Id de procedimiento</li>
     * </ul>
     */
    RecoveryBPMfwkInputExecutor getExecutorFor(RecoveryBPMfwkInput input) throws RecoveryBPMfwkError;

}
