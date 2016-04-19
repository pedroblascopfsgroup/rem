package es.pfsgroup.recovery.bpmframework.test.batch.RecoveryBPMfwkBatchManager;

import static org.mockito.Matchers.any;
import static org.mockito.Matchers.argThat;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.atLeast;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

import java.util.List;

import es.capgemini.devon.bo.Executor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkRunApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.batch.model.RecoveryBPMfwkPeticionBatch;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.test.matchers.RecoveryBPMfwkInputPeticionBatchArgumentMatcher;

/**
 * Utilidad para verificar que han tenido lugar las interacciones correctas del
 * manager con otros componentes
 * 
 * @author bruno
 * 
 */
public class VerificadorRecoveryBPMfwkBatchManagerTests {

    private RecoveryBPMfwkInputApi mockInputManager;

    private GenericABMDao mockGenericDao;

    private RecoveryBPMfwkRunApi mockRecoveryBPMRunApi;

    private Executor mockExecutor;

    /**
     * Debemos pasarle los mocks de todos los colaboradores del manager
     * 
     * @param mockInputManager
     * @param mockGenericDao
     * @param mockRecoveryBPMRunApi
     */
    public VerificadorRecoveryBPMfwkBatchManagerTests(RecoveryBPMfwkInputApi mockInputManager, GenericABMDao mockGenericDao, RecoveryBPMfwkRunApi mockRecoveryBPMRunApi, Executor mockExecutor) {
        super();
        this.mockInputManager = mockInputManager;
        this.mockGenericDao = mockGenericDao;
        this.mockRecoveryBPMRunApi = mockRecoveryBPMRunApi;
        this.mockExecutor = mockExecutor;
    }

    /**
     * Verifica que se haya guardado el input correctamente
     * 
     * @param input
     */
    public void seHaGuardadoElInput(RecoveryBPMfwkInputDto input) {
        try {
            verify(mockInputManager).saveInput(input);
        } catch (RecoveryBPMfwkError e) {
            // No se va a producir ning�n error aqu�
        }
    }

    /**
     * Verifica que se ha guardado correctamente la petici�n para procesar un
     * input
     * 
     * @param idProcess
     * @param idInput
     * @param callback
     */
    public void seHaGuardadoLaPeticionDeProcesado(Long idProcess, Long idInput, RecoveryBPMfwkCallback callback) {
        verify(mockGenericDao).save(eq(RecoveryBPMfwkPeticionBatch.class), argThat(new RecoveryBPMfwkInputPeticionBatchArgumentMatcher(idProcess, idInput, callback)));
    }

    public void seHanMarcadoComoProcesadasTodasLasPeticionesPendientes(List<RecoveryBPMfwkPeticionBatch> listaPeticionesBatch) {

        // Comprobamos que todos los elementos de la lista de peticiones
        // pendientes han sido puestos marcados como
        // procesados
        int numElementos = listaPeticionesBatch.size();

        verify(mockGenericDao, atLeast(1)).getListOrdered(eq(RecoveryBPMfwkPeticionBatch.class), any(Order.class), any(Filter.class));

        verify(listaPeticionesBatch, atLeast(numElementos)).get(any(Integer.class));
        verify(listaPeticionesBatch.get(any(Integer.class)), times(numElementos)).setProcesado(eq(RecoveryBPMfwkPeticionBatch.PROCESADO_OK));
        verify(listaPeticionesBatch.get(any(Integer.class)), times(numElementos)).setFechaProcesado(any(java.util.Date.class));

        verify(mockGenericDao, times(numElementos)).save(eq(RecoveryBPMfwkPeticionBatch.class), any(RecoveryBPMfwkPeticionBatch.class));

    }

    public void seHanMarcadoComoProcesadasErrorTodasLasPeticionesPendientes(List<RecoveryBPMfwkPeticionBatch> listaPeticionesBatch) {

        // Comprobamos que todos los elementos de la lista de peticiones
        // pendientes han sido puestos marcados como
        // procesados
        int numElementos = listaPeticionesBatch.size();

        verify(mockGenericDao, atLeast(1)).getListOrdered(eq(RecoveryBPMfwkPeticionBatch.class), any(Order.class), any(Filter.class));

        verify(listaPeticionesBatch, atLeast(numElementos)).get(any(Integer.class));
        verify(listaPeticionesBatch.get(any(Integer.class)), times(numElementos)).setProcesado(eq(RecoveryBPMfwkPeticionBatch.PROCESADO_ERROR));
        verify(listaPeticionesBatch.get(any(Integer.class)), times(numElementos)).setFechaProcesado(any(java.util.Date.class));

        verify(mockGenericDao, times(numElementos)).save(eq(RecoveryBPMfwkPeticionBatch.class), any(RecoveryBPMfwkPeticionBatch.class));

    }

    public void noSeEjecutaNingunCallback(List<RecoveryBPMfwkPeticionBatch> listaPeticionesBatch) {

        // N�mero de bloques de peticiones con el mismo token
        int diferentesTokens = 1;

        // Comprobamos que se buscan las funciones de callback:
        // (diferentesTokens) veces las de inicio y fin
        // (numElementos) veces las de �xito
        int numElementos = listaPeticionesBatch.size();

        verify(listaPeticionesBatch.get(any(Integer.class)), times(diferentesTokens)).getOnStartBo();
        verify(listaPeticionesBatch.get(any(Integer.class)), times(numElementos)).getOnSuccessBo();
        verify(listaPeticionesBatch.get(any(Integer.class)), times(diferentesTokens)).getOnEndBo();

        // Comprobamos que no se ha invocado ning�n callback
        verify(mockExecutor, never()).execute(any(String.class), any(Long.class));
        verify(mockExecutor, never()).execute(any(String.class), any(Long.class), any(RecoveryBPMfwkInput.class));
        verify(mockExecutor, never()).execute(any(String.class), any(Long.class), any(RecoveryBPMfwkInput.class), any(String.class));

    }

    public void seHaEjecutadoRunDePeticionesPendientes(List<RecoveryBPMfwkPeticionBatch> listaPeticionesBatch, RecoveryBPMfwkInput mockInput) {

        // Comprobamos que se buscan las funciones de callback:
        // (numElementos) veces las de �xito
        int numElementos = listaPeticionesBatch.size();

        // Verificar que se invoca el n�mero correcto de veces el runner
        try {
            verify(mockRecoveryBPMRunApi, times(numElementos)).procesaInput(mockInput);
        } catch (RecoveryBPMfwkError e) {
            // No se va a producir nunca un error aqu�
        }

    }

    public void seEjecutaCallbackOnStartYOnEndDeCadaToken(List<RecoveryBPMfwkPeticionBatch> listaPeticionesBatch) {

        // N�mero de bloques de peticiones con el mismo token
        int diferentesTokens = 2;

        // Comprobamos que se buscan las funciones de callback:
        // (numElementos) veces las de �xito
        int numElementos = listaPeticionesBatch.size();

        // N�mero de veces que se invoca a getIdToken (como m�nimo, numElementos)
        verify(listaPeticionesBatch.get(any(Integer.class)), atLeast(numElementos)).getIdToken();

        // Comprobar el n�mero de veces que se invoca a executor.execute
        // con las correspondientes operaciones de negocio
        verify(mockExecutor, never()).execute(any(String.class), any(Long.class), any(RecoveryBPMfwkInput.class));
    }
}
