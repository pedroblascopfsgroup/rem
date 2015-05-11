package es.pfsgroup.recovery.bpmframework.test.run.factory.RecoveryBPMfwkInputExecutorFactoryImpl.methods;

import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkDDTipoAccion;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.run.executors.*;
import es.pfsgroup.recovery.bpmframework.test.run.factory.RecoveryBPMfwkInputExecutorFactoryImpl.AbstractRecoveryBPMfwkInputExecutorFactoryImplTests;

/**
 * Prueba el método getExecutorFor
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class GetExecutorForTest extends AbstractRecoveryBPMfwkInputExecutorFactoryImplTests {

    private String codigoTipoAccionDesconocida;
    private Long idInput;
    private Long idProcedimiento;
    private String codigoTipoProcedimiento;
    private String codigoTipoInput;
    private String nodoProcedimiento;
    private List<String> nodosProcedimiento;
    private Map<String, RecoveryBPMfwkInputExecutor> beansMap;
    @Override
    public void childBefore() {
        codigoTipoAccionDesconocida = random.nextLong() + "aaf½&/·";
        idInput = random.nextLong();
        idProcedimiento = random.nextLong();
        codigoTipoProcedimiento = RandomStringUtils.randomAlphanumeric(50);
        codigoTipoInput = RandomStringUtils.randomAlphanumeric(50);
        nodoProcedimiento = RandomStringUtils.randomAlphanumeric(50);
        
        nodosProcedimiento = new ArrayList<String>();
        nodosProcedimiento.add(nodoProcedimiento);
        nodosProcedimiento.add(RandomStringUtils.randomAlphanumeric(50));
        nodosProcedimiento.add(RandomStringUtils.randomAlphanumeric(50));
        nodosProcedimiento.add(RandomStringUtils.randomAlphanumeric(50));

        beansMap = new HashMap<String, RecoveryBPMfwkInputExecutor>();
        beansMap.put("recoveryBPMfwkInputInformarDatosExecutor", new RecoveryBPMfwkInputInformarDatosExecutor());
        beansMap.put("recoveryBPMfwkInputAvanzarBPMExecutor", new RecoveryBPMfwkInputAvanzarBPMExecutor());
        beansMap.put("recoveryBPMfwkInputForwardBPMExecutor", new RecoveryBPMfwkInputForwardBPMExecutor());
        beansMap.put("recoveryBPMfwkInputGenDocExecutor", new RecoveryBPMfwkInputGenDocExecutor());
        beansMap.put("recoveryBPMfwkInputChainBoBPMExecutor", new RecoveryBPMfwkInputChainBoBPMExecutor());
        
        simular().seObtieneElProcedimiento(idProcedimiento, codigoTipoProcedimiento);
        simular().seObtieneElNodoProcedimiento(nodosProcedimiento);
        simular().seInicializanLosBeans(beansMap);
        
        //Simulamos que se ejecuta el setApplicationContext antes de las pruebas.
        executorFactory.setApplicationContext(mockApplicatioContext);
    }

    @Override
    public void childAfter() {
        codigoTipoAccionDesconocida = null;
        idInput = null;
        idProcedimiento = null;
        codigoTipoProcedimiento = null;
        codigoTipoInput = null;
        beansMap = null;
    }
    
    /**
     * Comprueba que pasa si el mapa de beans está vacío.
     * produzca un IllegalArgumentException
     * @throws RecoveryBPMfwkError 
     */
    @Test(expected = Error.class)
    public void bensMapVacio() throws RecoveryBPMfwkError {
    	
    	beansMap = new HashMap<String, RecoveryBPMfwkInputExecutor>();
    	simular().seInicializanLosBeans(beansMap);
        //Simulamos que se ejecuta el setApplicationContext antes de las pruebas.
        executorFactory.setApplicationContext(mockApplicatioContext);
        
    	simular().seObtieneLaconfiguracion(codigoTipoProcedimiento, codigoTipoInput, codigoTipoAccionDesconocida, nodoProcedimiento);
        
        executorFactory.getExecutorFor(configuraInput(idInput, idProcedimiento, codigoTipoInput));
    }

    /**
     * Comprueba qué pasa si la configuración es nula, es decir, 
     * no existe configuración para ese tipo de acción - tipo input - tipo procedimiento en base de datos.
     * produzca un IllegalArgumentException
     */
    @Test(expected = IllegalArgumentException.class)
    public void configuracionNula() throws RecoveryBPMfwkError{
        
        executorFactory.getExecutorFor(configuraInput(idInput, idProcedimiento, codigoTipoInput));
    }
    
    /**
     * Comprueba que si se pasa un input con un tipo de acción desconocido se
     * produzca un IllegalArgumentException
     */
    //TODO: Se quita este test porque siempre devuelve una configuración.
    //@Test(expected = IllegalArgumentException.class)
    public void tipoAccionDesconocido() throws RecoveryBPMfwkError{
        simular().seObtieneLaconfiguracion(codigoTipoProcedimiento, codigoTipoInput, codigoTipoAccionDesconocida, nodoProcedimiento);
        
        executorFactory.getExecutorFor(configuraInput(idInput, idProcedimiento, codigoTipoInput));
    }

    /**
     * Comprueba que se devuelve el executor correcto para un tipo de acción de
     * informar datos
     */
    @Test
    public void testTipoAccionInformarDatos() throws RecoveryBPMfwkError{
        simular().seObtieneLaconfiguracion(codigoTipoProcedimiento, codigoTipoInput, RecoveryBPMfwkDDTipoAccion.INFORMAR_DATOS, nodoProcedimiento);
        
        RecoveryBPMfwkInputExecutor executor = executorFactory.getExecutorFor(configuraInput( idInput, idProcedimiento, codigoTipoInput));
        assertTrue("No se ha devuelto un tipo de executor adecuado para la acción de informar datos", executor instanceof RecoveryBPMfwkInputInformarDatosExecutor);
    }

    /**
     * Comprueba que se devuelve el executor correcto para un tipo de tipo
     * Avanzar el BPM
     */
    @Test
    public void testTipoAccionAvanzarBPM() throws RecoveryBPMfwkError{
        simular().seObtieneLaconfiguracion(codigoTipoProcedimiento, codigoTipoInput, RecoveryBPMfwkDDTipoAccion.AVANZAR_BPM, nodoProcedimiento);
        
        RecoveryBPMfwkInputExecutor executor = executorFactory.getExecutorFor(configuraInput( idInput, idProcedimiento, codigoTipoInput));
        assertTrue("No se ha devuelto un tipo de executor adecuado para la acción de avanzar el BPM", executor instanceof RecoveryBPMfwkInputAvanzarBPMExecutor);
    }

    /**
     * Comprueba que se devuelve el executor correcto para un tipo de tipo
     * Avanzar el BPM
     */
    @Test
    public void testTipoAccionForward() throws RecoveryBPMfwkError{
        simular().seObtieneLaconfiguracion(codigoTipoProcedimiento, codigoTipoInput, RecoveryBPMfwkDDTipoAccion.FORWARD, nodoProcedimiento);
        
        RecoveryBPMfwkInputExecutor executor = executorFactory.getExecutorFor(configuraInput(idInput, idProcedimiento, codigoTipoInput));
        assertTrue("No se ha devuelto un tipo de executor adecuado para la acción de tipo Forward", executor instanceof RecoveryBPMfwkInputForwardBPMExecutor);
    }

    /**
     * Comprueba que se devuelve el executor correcto para un tipo de tipo
     * (re)generar documentación
     */
    @Test
    public void testTipoAccionGenerarDocumentacion() throws RecoveryBPMfwkError{
        simular().seObtieneLaconfiguracion(codigoTipoProcedimiento, codigoTipoInput, RecoveryBPMfwkDDTipoAccion.GEN_DOC, nodoProcedimiento);
        
        RecoveryBPMfwkInputExecutor executor = executorFactory.getExecutorFor(configuraInput( idInput, idProcedimiento, codigoTipoInput));
        assertTrue("No se ha devuelto un tipo de executor adecuado para la acción de tipo (re)generar documentación", executor instanceof RecoveryBPMfwkInputGenDocExecutor);
    }

    /**
     * Crea un input configurado para que tenga asociada un tipo de acción
     * determinada
     * 
     * @param idInput
     * @param idProcedimiento 
     * @param codigoTipoInput 
     * @return
     */
    private RecoveryBPMfwkInput configuraInput(Long idInput, Long idProcedimiento, String codigoTipoInput) {
        RecoveryBPMfwkDDTipoInput mockTipoInput = mock(RecoveryBPMfwkDDTipoInput.class);
        when(mockTipoInput.getCodigo()).thenReturn(codigoTipoInput);

        RecoveryBPMfwkInput mockInput = mock(RecoveryBPMfwkInput.class);
        when(mockInput.getId()).thenReturn(idInput);
        when(mockInput.getTipo()).thenReturn(mockTipoInput);
        when(mockInput.getIdProcedimiento()).thenReturn(idProcedimiento);
        return mockInput;
    }

}
