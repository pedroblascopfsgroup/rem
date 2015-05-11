package es.pfsgroup.recovery.bpmframework.test.api.dto.RecoveryBPMfwCallbackBOTemplate;

import static org.junit.Assert.*;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.pfsgroup.recovery.bpmframework.api.AbstractRecoveryBPMfwCallbackBOTemplate;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputInfo;

/**
 * Esta suite prueba que se pueda implementar correctamente la plantilla
 * 
 * @author bruno
 * 
 */
public class ImplementTemplateTest {

	private AbstractRecoveryBPMfwCallbackBOTemplate anoCallbacks;

	private String onSuccessString;
	
	private String onSuccessStringExpectec;
	
	private String onStartString;
	
	private String onStartStringExpected;
	
	private String onErrorString;
	
	private String onErrorStringExpected;
	
	private String onEndString;
	
	private String onEndStringExpected;
	
	private Long idProcess;
	
	private Random random = new Random();


	/**
	 * Crea una clase anónima implementando la clase abstracta.Este método
	 * fallaría si se modifica la visibilidad o se marca como final algún método
	 */
	@Before
	public void before() {
		random = new  Random();
		idProcess = random.nextLong();
		
		onSuccessStringExpectec = "Success-" + random.nextLong();
		onStartStringExpected = "Start-" + random.nextLong();
		onErrorStringExpected = "Error-" + random.nextLong();
		onEndStringExpected = "End-" + random.nextLong();
		
		anoCallbacks = new AbstractRecoveryBPMfwCallbackBOTemplate() {
			

			@Override
			public void onSuccess(Long idProcess, RecoveryBPMfwkInputInfo input) {
				onSuccessString = onSuccessStringExpectec + "-" + idProcess;
			}
			@Override
			public void onStartProcess(Long idProcess) {
				onStartString = onStartStringExpected + "-" + idProcess;

			}
			@Override
			public void onError(Long idProcess, RecoveryBPMfwkInputInfo input, String errorMessage) {
				onErrorString = onErrorStringExpected + "-" + idProcess;

			}
			@Override
			public void onEndProcess(Long idProcess) {
				onEndString = onEndStringExpected + "-" + idProcess;
			}
		};
	}
	
	@After
	public void after(){
		random = null;
		idProcess = null;
		anoCallbacks = null;
		onSuccessString = null;
		onSuccessStringExpectec = null;
		onEndString = null;
		onErrorStringExpected = null;
		onStartString = null;
		onStartStringExpected = null;
		onEndString = null;
		onEndStringExpected = null;
	}

	/**
	 * Verifica que todos los métodos funcionen correcamente
	 */
	@Test
	public void testAnoClass() {
		anoCallbacks.onEndProcess(idProcess);
		anoCallbacks.onError(idProcess, null, null);
		anoCallbacks.onStartProcess(idProcess);
		anoCallbacks.onSuccess(idProcess, null);
		
		assertEquals("El método onEndProcess no se ha ejecutado correctamente", onEndStringExpected + "-" + idProcess, onEndString);
		assertEquals("El método onError no se ha ejecutado correctamente", onErrorStringExpected + "-" + idProcess, onErrorString);
		assertEquals("El método onStartProcess no se ha ejecutado correctamente", onStartStringExpected + "-" + idProcess, onStartString);
		assertEquals("El método onSuccess no se ha ejecutado correctamente", onSuccessStringExpectec + "-" + idProcess, onSuccessString);
	}

}
