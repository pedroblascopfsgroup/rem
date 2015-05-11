package es.pfsgroup.recovery.bpmframework.test.batch.RecoveryBPMfwkBatchManager.bo;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.batch.dao.RecoveryBPMfwkPeticionBatchDao;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.test.batch.RecoveryBPMfwkBatchManager.AbstractRecoveryBPMfwkBatchManagerTests;

/**
 * Pruebas del método {@link RecoveryBPMfwkBatchManager.getTest()}
 * Como el test es muy sencillo no se han utilizado las clases auxiliares
 * de simulación y verificación.
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class GetTokenTest extends AbstractRecoveryBPMfwkBatchManagerTests{

	private final static String MENSAJE_ERROR = "MENSAJE_ERROR";
	
	private Long token;
	
	@Mock
	RecoveryBPMfwkPeticionBatchDao mockRecoveryBPMfwkPeticionBatchDao; 

	@Override
	public void childBefore() {
		
		token = random.nextLong();
		when(mockRecoveryBPMfwkPeticionBatchDao.getToken()).thenReturn(token);
	}

	@Override
	public void childAfter() {
		token = null;
		reset(mockRecoveryBPMfwkPeticionBatchDao);
		
	}
	
    /**
     * Test del caso general
     * @throws RecoveryBPMfwkError 
     * 
     */
    @Test
    public void testCasoGeneral() throws RecoveryBPMfwkError {
        
    	Long idToken = manager.getToken();

    	assertEquals("la generación del token no es correcta.", token, idToken);
    }
    
    /**
     * Test se lanza una excepción.
     * @throws RecoveryBPMfwkError
     */
    @Test(expected = RecoveryBPMfwkError.class)
    public void testLanzarExcepcion() throws RecoveryBPMfwkError {
    	
    	doThrow(new RuntimeException(GetTokenTest.MENSAJE_ERROR)).when(mockRecoveryBPMfwkPeticionBatchDao).getToken();
    	
    	manager.getToken();

    	fail("No se ha lanzado la excepción.");
    }

}
