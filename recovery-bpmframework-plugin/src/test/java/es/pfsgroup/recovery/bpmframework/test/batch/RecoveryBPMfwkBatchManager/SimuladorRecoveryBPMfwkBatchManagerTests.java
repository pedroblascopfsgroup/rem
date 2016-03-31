package es.pfsgroup.recovery.bpmframework.test.batch.RecoveryBPMfwkBatchManager;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.*;

import java.util.List;

import org.mockito.ArgumentCaptor;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkRunApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputInfo;
import es.pfsgroup.recovery.bpmframework.batch.model.RecoveryBPMfwkPeticionBatch;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.test.AbstractRecoveryBPMSimulador;

/**
 * Simulador de interacciones del manager con otros
 * 
 * @author bruno
 * 
 */
public class SimuladorRecoveryBPMfwkBatchManagerTests extends AbstractRecoveryBPMSimulador {

    GenericABMDao mockGenericDao;

    RecoveryBPMfwkPeticionBatch mockPeticionSinCallbacks;

    RecoveryBPMfwkPeticionBatch mockPeticionInicial;

    RecoveryBPMfwkPeticionBatch mockPeticionFinal;

    RecoveryBPMfwkRunApi mockRecoveryBPMRunApi;

    /**
     * Tenemos que pasar los mocks de todos los objetos con los que se
     * interactua
     * 
     * @param mockInputManger
     */
    public SimuladorRecoveryBPMfwkBatchManagerTests(RecoveryBPMfwkInputApi mockInputManger, GenericABMDao mockGenericDao, RecoveryBPMfwkRunApi mockRecoveryBPMRunApi) {
        super();
        this.setMockInputManger(mockInputManger);
        this.mockGenericDao = mockGenericDao;
        this.mockRecoveryBPMRunApi = mockRecoveryBPMRunApi;
        // this.mockExecutor = mockExecutor;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    public void simulaSeGuardaPeticion(Long id, Long idProcess, Long idInput, RecoveryBPMfwkCallback callback) {

        RecoveryBPMfwkPeticionBatch pet = mock(RecoveryBPMfwkPeticionBatch.class);
        when(pet.getId()).thenReturn(id);
        when(pet.getIdToken()).thenReturn(idProcess);

        ArgumentCaptor<Class> argClassCaptor = ArgumentCaptor.forClass(Class.class);
        ArgumentCaptor<RecoveryBPMfwkPeticionBatch> argCaptor = ArgumentCaptor.forClass(RecoveryBPMfwkPeticionBatch.class);
        when(mockGenericDao.save(argClassCaptor.capture(), argCaptor.capture())).thenReturn(pet);

    }

    public void seRecuperaListaPeticionesPendientes_SinCallbacks(List<RecoveryBPMfwkPeticionBatch> listaPeticionesBatch, RecoveryBPMfwkInput mockInput) {

        mockPeticionSinCallbacks = mock(RecoveryBPMfwkPeticionBatch.class);

        when(mockGenericDao.getListOrdered(eq(RecoveryBPMfwkPeticionBatch.class), any(Order.class), any(Filter.class))).thenReturn(listaPeticionesBatch);
        when(listaPeticionesBatch.size()).thenReturn(3);

        when(listaPeticionesBatch.get(0)).thenReturn(mockPeticionSinCallbacks);
        when(listaPeticionesBatch.get(1)).thenReturn(mockPeticionSinCallbacks);
        when(listaPeticionesBatch.get(2)).thenReturn(mockPeticionSinCallbacks);
        when(mockPeticionSinCallbacks.getOnStartBo()).thenReturn(null);
        when(mockPeticionSinCallbacks.getOnSuccessBo()).thenReturn(null);
        when(mockPeticionSinCallbacks.getOnErrorBo()).thenReturn(null);
        when(mockPeticionSinCallbacks.getOnEndBo()).thenReturn(null);

        when(mockPeticionSinCallbacks.getInput()).thenReturn(mockInput);

        when(mockRecoveryBPMRunApi.procesaInput(any(RecoveryBPMfwkInputInfo.class))).thenReturn(1L);
        
//        try {
//            doNothing().when(mockRecoveryBPMRunApi).procesaInput(any(RecoveryBPMfwkInputInfo.class));        	
//        } catch (RecoveryBPMfwkError e) {
//            // No se va a producir nunca un error aqu�
//        }

    }

    public void seRecuperanPeticionesAgrupadasPorToken(List<RecoveryBPMfwkPeticionBatch> listaPeticionesBatch, RecoveryBPMfwkInput mockInput) {

        // Recuperamos una lista con 3 inputs para el primer token y 2 inputs
        // para el segundo
        // solo con los callbacks de inicio y fin de proceso

        mockPeticionInicial = mock(RecoveryBPMfwkPeticionBatch.class);
        mockPeticionFinal = mock(RecoveryBPMfwkPeticionBatch.class);

        when(mockGenericDao.getListOrdered(eq(RecoveryBPMfwkPeticionBatch.class), any(Order.class), any(Filter.class))).thenReturn(listaPeticionesBatch);
        when(listaPeticionesBatch.size()).thenReturn(5);
        when(listaPeticionesBatch.get(0)).thenReturn(mockPeticionInicial);
        when(listaPeticionesBatch.get(1)).thenReturn(mockPeticionInicial);
        when(listaPeticionesBatch.get(2)).thenReturn(mockPeticionInicial);
        when(listaPeticionesBatch.get(3)).thenReturn(mockPeticionFinal);
        when(listaPeticionesBatch.get(4)).thenReturn(mockPeticionFinal);

        Long idToken1 = 1000L;
        when(mockPeticionInicial.getIdToken()).thenReturn(idToken1);
        when(mockPeticionInicial.getOnSuccessBo()).thenReturn(null);
        when(mockPeticionInicial.getOnErrorBo()).thenReturn(null);
        when(mockPeticionInicial.getInput()).thenReturn(mockInput);

        Long idToken2 = 2000L;
        when(mockPeticionFinal.getIdToken()).thenReturn(idToken2);
        when(mockPeticionFinal.getOnSuccessBo()).thenReturn(null);
        when(mockPeticionFinal.getOnErrorBo()).thenReturn(null);
        when(mockPeticionFinal.getInput()).thenReturn(mockInput);

        when(mockRecoveryBPMRunApi.procesaInput(any(RecoveryBPMfwkInputInfo.class))).thenReturn(1L);
//        try {
//            doNothing().when(mockRecoveryBPMRunApi).procesaInput(any(RecoveryBPMfwkInputInfo.class));
//        } catch (RecoveryBPMfwkError e) {
//            // No se va a producir nunca un error aqu�
//        }

    }

    public void seRecuperanPeticionesConExito(List<RecoveryBPMfwkPeticionBatch> listaPeticionesBatch, RecoveryBPMfwkInput mockInput) {

        // Recuperamos una lista con 2 inputs correctos
        // se ejecutar� el onSuccess

        mockPeticionInicial = mock(RecoveryBPMfwkPeticionBatch.class);

        when(mockGenericDao.getListOrdered(eq(RecoveryBPMfwkPeticionBatch.class), any(Order.class), any(Filter.class))).thenReturn(listaPeticionesBatch);
        when(listaPeticionesBatch.size()).thenReturn(1);
        when(listaPeticionesBatch.get(0)).thenReturn(mockPeticionInicial);
        when(listaPeticionesBatch.get(1)).thenReturn(mockPeticionInicial);

        Long idToken1 = 1000L;
        when(mockPeticionInicial.getIdToken()).thenReturn(idToken1);
        when(mockPeticionInicial.getOnErrorBo()).thenReturn(null);
        when(mockPeticionInicial.getInput()).thenReturn(mockInput);

        when(mockRecoveryBPMRunApi.procesaInput(any(RecoveryBPMfwkInputInfo.class))).thenReturn(1L);
        
//        try {
//            doNothing().when(mockRecoveryBPMRunApi).procesaInput(any(RecoveryBPMfwkInputInfo.class));        	
//        } catch (RecoveryBPMfwkError e) {
//            // No se va a producir nunca un error aqu�
//        }

    }

    public void seRecuperanPeticionesConError(List<RecoveryBPMfwkPeticionBatch> listaPeticionesBatch, RecoveryBPMfwkInput mockInput) {

        // Recuperamos una lista con 2 inputs err�neos
        // se ejecutar� el onSuccess

        mockPeticionInicial = mock(RecoveryBPMfwkPeticionBatch.class);

        when(mockGenericDao.getListOrdered(eq(RecoveryBPMfwkPeticionBatch.class), any(Order.class), any(Filter.class))).thenReturn(listaPeticionesBatch);
        when(listaPeticionesBatch.size()).thenReturn(1);
        when(listaPeticionesBatch.get(0)).thenReturn(mockPeticionInicial);
        when(listaPeticionesBatch.get(1)).thenReturn(mockPeticionInicial);

        Long idToken1 = 1000L;
        when(mockPeticionInicial.getInput()).thenReturn(mockInput);

        try {
            doThrow(new RuntimeException("")).when(mockRecoveryBPMRunApi).procesaInput(any(RecoveryBPMfwkInputInfo.class));
        } catch (RecoveryBPMfwkError e) {
            // No se va a producir nunca un error aqu�
        }

    }

	public void seLanzaUnaExcepcion() {
		
		doThrow(new RuntimeException("")).when(mockGenericDao).createFilter(FilterType.EQUALS, "procesado", RecoveryBPMfwkPeticionBatch.NO_PROCESADO);
		
	}


}
