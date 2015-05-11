package es.pfsgroup.recovery.bpmframework.test.batch.RecoveryBPMfwkBatchManager.bo;


import static org.junit.Assert.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.test.batch.RecoveryBPMfwkBatchManager.AbstractRecoveryBPMfwkBatchManagerTests;

/**
 * Suite de pruebas de la BO para la programación del procesado de un input.
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class ProgramaProcesadoInputTest extends AbstractRecoveryBPMfwkBatchManagerTests {

	/*
     * Variables del test
     */
    private RecoveryBPMfwkCallback callback;
    private RecoveryBPMfwkInputDto input;
    private Long idProcess;
    private String bonameOnSuccess;
    private String bonameEndProcess;
    private String bonameOnError;
    private String bonameStartProcess;

    private DatosEntradaInput entradaInput;

    private Long idInput;

    @Override
    public void childBefore() {
        idProcess = random.nextLong();

        entradaInput = new DatosEntradaInput(random);

        bonameStartProcess = "Start-" + random.nextLong();
        bonameEndProcess = "End-" + random.nextLong();
        bonameOnSuccess = "Success-" + random.nextLong();
        bonameOnError = "Error-" + random.nextLong();

        

        input = generaDTOInput(entradaInput);
        callback = generaCallback(bonameStartProcess, bonameEndProcess, bonameOnSuccess, bonameOnError);

        idInput = random.nextLong();

        simular().simulaSeGuardaInput(idInput);
        //simular().simulaSeGuardaPeticion(idProcess, idInput, callback);
    }

    @Override
    public void childAfter() {
        idProcess = null;
        bonameStartProcess = null;
        bonameEndProcess = null;
        bonameOnSuccess = null;
        bonameOnError = null;
        callback = null;
        input = null;
        entradaInput = null;
        idInput = null;
    }

    /**
     * Test del caso general
     * @throws RecoveryBPMfwkError 
     */
    @Test
    public void testCasoGeneral() throws RecoveryBPMfwkError {
        manager.programaProcesadoInput(idProcess, input, callback);

        verificar().seHaGuardadoElInput(input);
        verificar().seHaGuardadoLaPeticionDeProcesado(idProcess, idInput, callback);
    }
    
    /**
     * Test del caso en el que se produce un error interno.
     * @throws RecoveryBPMfwkError 
     */
    @Test(expected = RecoveryBPMfwkError.class)
    public void testLanzarError() throws RecoveryBPMfwkError {
    	
    	simular().seLanzaUnError();
    	
        manager.programaProcesadoInput(idProcess, input, callback);

        fail("No se ha lanzado la excepción.");
    }
}
