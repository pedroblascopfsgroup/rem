package es.pfsgroup.recovery.bpmframework.test.run.RecoveryBPMfwkRunManager;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.run.RecoveryBPMfwkRunManager;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputExecutor;
import es.pfsgroup.recovery.bpmframework.run.factory.RecoveryBPMfwkInputExecutorFactory;
import es.pfsgroup.recovery.bpmframework.test.AbstractRecoveryBPMSimulador;

/**
 * Simulador de interacciones del {@link RecoveryBPMfwkRunManager}
 * 
 * @author bruno
 * 
 */
public class SimuladorRecoveryBPMfwkRunManager extends AbstractRecoveryBPMSimulador {

    private RecoveryBPMfwkInputExecutorFactory mockInputExecutorFactory;

    /**
     * Debemos pasar mocks de todos los colaboradores
     * 
     * @param mockInputManager
     * @param mockInputExecutorFactory 
     */
    public SimuladorRecoveryBPMfwkRunManager(RecoveryBPMfwkInputApi mockInputManager, RecoveryBPMfwkInputExecutorFactory mockInputExecutorFactory) {
        this.setMockInputManger(mockInputManager);
        this.mockInputExecutorFactory = mockInputExecutorFactory;
    }

    /**
     * Simula que se obtiene un InputExecutor para procesar el input
     * correspondiente al tipo de input
     * 
     * @param mockInput
     */
    public RecoveryBPMfwkInputExecutor seObtieneUnInputExecutor(RecoveryBPMfwkInput mockInput) {
        RecoveryBPMfwkInputExecutor mockInputExecutor = mock(RecoveryBPMfwkInputExecutor.class);
        try {
			when(mockInputExecutorFactory.getExecutorFor(mockInput)).thenReturn(mockInputExecutor);
		} catch (RecoveryBPMfwkError e) {
			e.printStackTrace();
		}
        return mockInputExecutor;
    }

}
