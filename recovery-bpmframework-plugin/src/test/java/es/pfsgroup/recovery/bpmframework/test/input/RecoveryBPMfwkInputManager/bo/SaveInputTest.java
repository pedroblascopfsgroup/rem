package es.pfsgroup.recovery.bpmframework.test.input.RecoveryBPMfwkInputManager.bo;

import static org.junit.Assert.assertEquals;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.test.input.RecoveryBPMfwkInputManager.AbstractRecoveryBPMfwkInputManagerTests;

/**
 * Pruebas de la operación de negocio de guardar un input
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class SaveInputTest extends AbstractRecoveryBPMfwkInputManagerTests {
    
    private DatosEntradaInput entradaInput; 

    private Long idInputPersisitdo;

    RecoveryBPMfwkInputDto dtoInput;

    @Override
    public void childBefore() {
        entradaInput = new DatosEntradaInput(random);
      
        idInputPersisitdo = random.nextLong();

        dtoInput = generaDTOInput(entradaInput);

        simular().seObtieneTipoDeInput(entradaInput.getCodigoTipoInput());
        simular().seObtieneUnInputDespuesDeGuardar(dtoInput, idInputPersisitdo);
    }

    @Override
    public void childAfter() {
        dtoInput = null;
        idInputPersisitdo = null;
    }

    /**
     * Prueba el caso general de guardado de un input
     * @throws RecoveryBPMfwkError 
     */
    @Test(expected = RecoveryBPMfwkError.class)
    public void testInputNoGuardado() throws RecoveryBPMfwkError {

   	 	simular().seObtieneUnInputDespuesDeGuardar(dtoInput, null);
    	manager.saveInput(dtoInput);

    }
    
    /**
     * Prueba el caso general de guardado de un input
     */
    @Test
    public void testCasoGeneral() throws RecoveryBPMfwkError{
        RecoveryBPMfwkInput input = manager.saveInput(dtoInput);

        verificar().seHaGuardadoElInput(dtoInput);
        verificar().seHanGuardadoLosDatos(entradaInput.getDatosInput());

        assertEquals("No coincide el tipo de input", entradaInput.getCodigoTipoInput(), input.getTipo().getCodigo());
        assertEquals("No coincide el tipo de procedimiento", entradaInput.getIdProcedimiento(), input.getIdProcedimiento());
        assertEquals("No coincide el adjutno", entradaInput.getAdjuntoInput(), input.getAdjunto());
    }

}
