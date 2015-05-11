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
public class onStartProcessTest extends AbstractMSVProcedimientoBackOfficeBOCallbackTests {

	@Override
	protected void beforeChild() {

	}

	@Override
	protected void afterChild() {

	}
	
	@Test
	public void testOnStartProcess() {
		manager.onStartProcess(token);
		manager.onStartProcess(token2);
		
		int invocaciones = 2;
		
		verificarInteracciones().isCorrectSize(manager, invocaciones);
		
		try {
			verificarInteracciones().verifyModificarProcesoMasivo(mockApiProxy, mockMSVProcesoApi, dtoUpdateEstado, invocaciones);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
		
}
