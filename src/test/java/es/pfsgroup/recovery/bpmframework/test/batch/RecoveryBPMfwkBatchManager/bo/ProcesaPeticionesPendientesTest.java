package es.pfsgroup.recovery.bpmframework.test.batch.RecoveryBPMfwkBatchManager.bo;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.batch.model.RecoveryBPMfwkPeticionBatch;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.test.batch.RecoveryBPMfwkBatchManager.AbstractRecoveryBPMfwkBatchManagerTests;

/**
 * Suite de pruebas para el procesado de inputs en diferido
 * 
 * @author pedro
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class ProcesaPeticionesPendientesTest extends
		AbstractRecoveryBPMfwkBatchManagerTests {

	public final static String BO_ON_START_PROCESS = "BO_ON_START_PROCESS";
	public final static String BO_ON_SUCCESS = "BO_ON_SUCCESS";
	public final static String BO_ON_ERROR = "BO_ON_ERROR";
	public final static String BO_ON_END_PROCESS = "BO_ON_END_PROCESS";

	public final static String MENSAJE_ERROR = "MENSAJE_ERROR";
	
	/*
	 * Variables del test
	 */
	@Mock
	private List<RecoveryBPMfwkPeticionBatch> listaPeticionesBatch;

	@Mock
	private RecoveryBPMfwkInput mockInput;

	@Override
	public void childBefore() {
		when(mockExecutor.execute(null)).thenReturn(null);
	}

	@Override
	public void childAfter() {
		listaPeticionesBatch = null;
	}

	/**
	 * Probar que se ejecutan todas las peticiones pendientes y se marcan como procesadas.
	 * <p>
	 * Cuando una petici�n se procese se debe marcar un flag de procesada en el mismo objeto petici�n. Tenemos que
	 * guardarnos tambi�n la fecha de procesado.
	 * </p>
	 * <p>
	 * En este caso de pruebas el callback de las peticiones son NULL, <strong>hay que comprobar que no se ejecuta
	 * ning�n callback</strong>
	 * </p>
	 * <p>
	 * Comprobar que se realiza, por cada input la petici�n de procesado de la RunApi
	 * </p>
	 * @throws RecoveryBPMfwkError 
	 */
	@SuppressWarnings("deprecation")
	@Test
	public void testProcesaTodasPeticiones_SinCallbacks() throws RecoveryBPMfwkError {

		simular().seRecuperaListaPeticionesPendientes_SinCallbacks(
				listaPeticionesBatch, mockInput);

		manager.ejecutaPeticionesBatchPendientes();

		verificar().seHanMarcadoComoProcesadasTodasLasPeticionesPendientes(
				listaPeticionesBatch);
		verificar().seHaEjecutadoRunDePeticionesPendientes(
				listaPeticionesBatch, mockInput);
		verificar().noSeEjecutaNingunCallback(listaPeticionesBatch);

	}

	/**
	 * Probar que se procesan de forma agrupada por el token idProceso y que por cada token distinto se hace una llamada
	 * al callback onStart y otra al onEnd.
	 * <p>
	 * Comprobar que se realiza, por cada input la petici�n de procesado de la RunApi
	 * </p>
	 * @throws RecoveryBPMfwkError 
	 */
	@Test
	@SuppressWarnings("deprecation")
	public void testProcesaTodasPeticiones_startAndEndCallbacks() throws RecoveryBPMfwkError {

		simular().seRecuperanPeticionesAgrupadasPorToken(listaPeticionesBatch,
				mockInput);

		manager.ejecutaPeticionesBatchPendientes();

		verificar().seHaEjecutadoRunDePeticionesPendientes(
				listaPeticionesBatch, mockInput);
		verificar().seEjecutaCallbackOnStartYOnEndDeCadaToken(
				listaPeticionesBatch);

	}

	/**
	 * Prueba que se llame al callback onSuccess.
	 * <p>
	 * Comprobar que se realiza, por cada input la petici�n de procesado de la RunApi
	 * </p>
	 * @throws RecoveryBPMfwkError 
	 */
	@Test
	@SuppressWarnings("deprecation")
	public void testProcesaTodasPeticiones_onSuccessCallback() throws RecoveryBPMfwkError {

		simular()
				.seRecuperanPeticionesConExito(listaPeticionesBatch, mockInput);

		manager.ejecutaPeticionesBatchPendientes();

		verificar().seHanMarcadoComoProcesadasTodasLasPeticionesPendientes(
				listaPeticionesBatch);
		verificar().seHaEjecutadoRunDePeticionesPendientes(
				listaPeticionesBatch, mockInput);
		verificar().seEjecutaCallbackOnSuccessDeCadaToken(listaPeticionesBatch);
	}

	/**
	 * Simula que han ocurrido errores y comprueba que se llame al callback del error.
	 * <p>
	 * Comprobar que se realiza, por cada input la petici�n de procesado de la RunApi
	 * </p>
	 * @throws RecoveryBPMfwkError 
	 */
	@Test
	@SuppressWarnings("deprecation")
	public void testProcesaTodasPeticiones_onErrorCallback() throws RecoveryBPMfwkError {

		simular().seRecuperanPeticionesConError(listaPeticionesBatch, mockInput);

		manager.ejecutaPeticionesBatchPendientes();

		verificar().seHanMarcadoComoProcesadasErrorTodasLasPeticionesPendientes(
				listaPeticionesBatch);
		verificar().seHaEjecutadoRunDePeticionesPendientes(
				listaPeticionesBatch, mockInput);
		verificar().seEjecutaCallbackOnErrorDeCadaToken(listaPeticionesBatch);
	}
	
	/**
	 * Lanza un error interno. Comprueba que la excepci�n que se recibe es correcta.
	 * @throws RecoveryBPMfwkError
	 */
	@Test(expected = RecoveryBPMfwkError.class)
	@SuppressWarnings("deprecation")
	public void testProcesaTodasPeticiones_Error() throws RecoveryBPMfwkError {
		
		simular().seLanzaUnaExcepcion();
		
		manager.ejecutaPeticionesBatchPendientes();
		
		fail("No se ha lanzado la excepci�n.");
		
	}
}
