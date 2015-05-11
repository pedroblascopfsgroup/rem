package es.pfsgroup.plugin.recovery.masivo.test.callbacks.bpmBO.api.MSVProcedimientoBackOfficeBOCallback.bo;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.test.callbacks.bpmBO.api.MSVProcedimientoBackOfficeBOCallback.AbstractMSVProcedimientoBackOfficeBOCallbackTests;


/**
 * Esta es la suite de test para probar el método onStartProcess
 * 
 * @author carlos
 *
 */

@RunWith(MockitoJUnitRunner.class)
public class onError extends AbstractMSVProcedimientoBackOfficeBOCallbackTests {

	
	@Override
	protected void beforeChild() {
		
		
	}

	@Override
	protected void afterChild() {
		
	}
	
	@Test
	public void testOnError() {
		manager.onStartProcess(token2);
				
		manager.onError(token2, input, "error1");
		manager.onError(token2, input2, "error2");
		
		//Verificamos que inserta dos mensajes de error
		verificarInteracciones().verifyInsertError(manager, token2, 2);
		
		
	}
	
	
	
}
