package es.pfsgroup.recovery.bpmframework.test;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

/**
 * Clase genérica con código compartido entre todos los simuladores de interacciones
 * @author bruno
 *
 */
public class AbstractRecoveryBPMSimulador {
    
    private RecoveryBPMfwkInputApi mockInputManager;

    /**
     * Simula que se guarda un input a través del manager y que se devuelve el manager guardado
     * @param idInput
     * @return 
     */
    public RecoveryBPMfwkInput simulaSeGuardaInput(Long idInput) {
        RecoveryBPMfwkInput mockInput = mock(RecoveryBPMfwkInput.class);
        when(mockInput.getId()).thenReturn(idInput);
        
        try {
            when(mockInputManager.saveInput(any(RecoveryBPMfwkInputDto.class))).thenReturn(mockInput);
        } catch (RecoveryBPMfwkError e) {
            // No se va a producir ningún error
        }
        return mockInput;
    }

    public void setMockInputManger(RecoveryBPMfwkInputApi mockInputManager) {
        this.mockInputManager = mockInputManager;
    }
    
	public void seLanzaUnError() throws RecoveryBPMfwkError {

		doThrow(new RuntimeException("")).when(mockInputManager).saveInput(any(RecoveryBPMfwkInputDto.class));
		
	}

}
