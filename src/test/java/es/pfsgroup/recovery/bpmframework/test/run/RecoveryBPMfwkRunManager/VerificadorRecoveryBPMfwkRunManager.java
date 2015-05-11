package es.pfsgroup.recovery.bpmframework.test.run.RecoveryBPMfwkRunManager;

import static org.mockito.Mockito.*;

import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.run.RecoveryBPMfwkRunManager;

/**
 * Verificador de interacciones del {@link RecoveryBPMfwkRunManager}
 * @author bruno
 *
 */
public class VerificadorRecoveryBPMfwkRunManager {
    
    private RecoveryBPMfwkInputApi mockInputManager;
    
    /**
     * Es necesario pasar los mocks de todos los colaboradores del manager
     * @param mockInputManager
     */
    public VerificadorRecoveryBPMfwkRunManager(RecoveryBPMfwkInputApi mockInputManager) {
        super();
        this.mockInputManager = mockInputManager;
    }

    /**
     * Verifica que se haya persistido el input
     * @param dtoInput
     */
    public void seHaGuardadoElInput(RecoveryBPMfwkInputDto dtoInput) {
        try {
            verify(mockInputManager, times(1)).saveInput(dtoInput);
        } catch (RecoveryBPMfwkError e) {
            // No se va a producir ningún error aquí
        }
    }

    /**
     * Comprueba que no se haga ningún  guardado del input
     */
    public void noSeHaGuardadoElInput() {
        verifyZeroInteractions(mockInputManager);
        
    }

    

}
