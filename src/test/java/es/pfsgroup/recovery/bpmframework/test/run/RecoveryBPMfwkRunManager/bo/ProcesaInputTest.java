package es.pfsgroup.recovery.bpmframework.test.run.RecoveryBPMfwkRunManager.bo;


import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyZeroInteractions;
import static org.mockito.Mockito.when;

import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputInfo;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputExecutor;
import es.pfsgroup.recovery.bpmframework.test.run.RecoveryBPMfwkRunManager.AbstractRecoveryBPMfwkRunManagerTests;

/**
 * Conjunto de pruebas para la operación de negocio de procesado de inputs
 * 
 * @author bruno
 * 
 */

@RunWith(MockitoJUnitRunner.class)
public class ProcesaInputTest extends AbstractRecoveryBPMfwkRunManagerTests {

    private RecoveryBPMfwkInputDto dtoInput;

    private DatosEntradaInput entradaInput;

    
    @Mock
    private RecoveryBPMfwkInput mockBadInput;

    private Long idInputPersistido;

    private RecoveryBPMfwkInputExecutor mockInputExecutor;
    
    private RecoveryBPMfwkInput mockInput;

    @Override
    public void childBefore() {
        entradaInput = new DatosEntradaInput(random);
        dtoInput = generaDTOInput(entradaInput);
        idInputPersistido = random.nextLong();
        
        when(mockBadInput.getId()).thenReturn(null);
        
        mockInput = simular().simulaSeGuardaInput(idInputPersistido);
        
        mockInputExecutor = simular().seObtieneUnInputExecutor(mockInput);
    }

    @Override
    public void childAfter() {
        dtoInput = null;
        entradaInput = null;
        idInputPersistido = null;
        mockInput = null;
        mockInputExecutor = null;
        reset(mockBadInput);
    }

    /**
     * Comprobamos el caso en el que se recibe un DTO y por lo tanto se guarda
     * antes el input
     * @throws Exception 
     */
    @Test
    public void testProcesaYGuarda() throws Exception {
        manager.procesaInput(dtoInput);
        
        verificar().seHaGuardadoElInput(dtoInput);
        
        verify(mockInputExecutor,times(1)).execute(mockInput);
        
    }

    /**
     * Comprueba el caso en el que se recibe un input ya persistio y que por lo
     * tanto no se llega nunca a guardar
     * @throws Exception 
     */
    @Test
    public void testSoloProcesa() throws Exception {
        manager.procesaInput(mockInput);
        
        verificar().noSeHaGuardadoElInput();
        
        verify(mockInputExecutor,times(1)).execute(mockInput);

    }

    /**
     * Comprueba el caso en el que se pasa un objeto de tipo
     * {@link RecoveryBPMfwkInput}, pero este no está correectamente persistido
     * @throws RecoveryBPMfwkError 
     */
    @Test(expected = RecoveryBPMfwkError.class)
    public void testSoloProcesa_noPersistido() throws RecoveryBPMfwkError {
        manager.procesaInput(mockBadInput);
        
        verificar().noSeHaGuardadoElInput();
        
        verifyZeroInteractions(mockInputExecutor);
    }
    

    /**
     * Comprueba el caso en el que se produce un error en la ejecución.
     * Se debe recuperar una excepción de tipo {@link RecoveryBPMfwkError} con la excepción original dentro.
     */
    @Test
    public void testSeProduceUnError()  throws Exception {
        
    	final String EXPECTED_TEXT = "mock test exception";
    	
		doThrow(new RuntimeException(EXPECTED_TEXT)).when(mockInputExecutor).execute(mockInput);
    	
    	try{
    		manager.procesaInput(mockInput);
    	}catch(RecoveryBPMfwkError error){
    		assertEquals(EXPECTED_TEXT, error.getExcepcionOriginal().getMessage());
    	}
    	
    	verify(mockInputExecutor,times(1)).execute(mockInput);
        
    }
    
    /**
     * Comprueba el caso en el que se pasa un objeto 
     * que implementa {@link RecoveryBPMfwkInputInfo} desconocido
     */
    @Test(expected=RecoveryBPMfwkError.class)
    public void testInputInfoDesconocido()  throws Exception {
        
    	manager.procesaInput(RecoveryBPMfwkInputInfoTest.getInstance());
        
    }
    
    static class RecoveryBPMfwkInputInfoTest implements RecoveryBPMfwkInputInfo{

		public static RecoveryBPMfwkInputInfo getInstance() {
			return new RecoveryBPMfwkInputInfoTest();
		}
    	
    	@Override
		public FileItem getAdjunto() {
			return null;
		}

		@Override
		public Map<String, Object> getDatos() {
			return null;
		}

		@Override
		public String getCodigoTipoInput() {
			return null;
		}

		@Override
		public Long getIdProcedimiento() {
			return null;
		}
    	
    }

}
