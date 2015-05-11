package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputInformarDatosExecutor.methods;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkGrupoDatoDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkConfiguracionError;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;
import es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputInformarDatosExecutor.AbstractRecoveryBPMfwkInputInformarDatosExecutorTest;

/**
 * Prueba el método execute para el
 * {@link RecoveryBPMfwkInputInformarDatosExecutor}
 * 
 * @author bruno
 * 
 */
//TODO programar el caso de pruebas para cuando falle el execute en algún punto
@RunWith(MockitoJUnitRunner.class)
public class ExecuteTest extends AbstractRecoveryBPMfwkInputInformarDatosExecutorTest {

    private RecoveryBPMfwkCfgInputDto mockConfig;

    private DatosEntradaInput datosInput;

    private Map<String, RecoveryBPMfwkGrupoDatoDto> configDatos;

    private String codigoTipoProcedimiento;

    private String codigoTipoInput;
    
    private String nodoProcedimiento;
    
    private List<String> nodosProcedimiento;

    @Override
    public void childBefore() {
        datosInput = new DatosEntradaInput(random);

        codigoTipoProcedimiento = "TP" + random.nextLong();
        codigoTipoInput = datosInput.getCodigoTipoInput();
        nodoProcedimiento = RandomStringUtils.randomAlphanumeric(20);
        
        nodosProcedimiento = new ArrayList<String>();
        nodosProcedimiento.add(nodoProcedimiento);
        nodosProcedimiento.add(RandomStringUtils.randomAlphanumeric(20));
        nodosProcedimiento.add(RandomStringUtils.randomAlphanumeric(20));
        nodosProcedimiento.add(RandomStringUtils.randomAlphanumeric(20));
        
        simular().simulaSeObtieneProcedimiento(codigoTipoProcedimiento, datosInput.getIdProcedimiento());
        simular().simulaSeObtieneNodoProcedimiento(nodosProcedimiento);
        mockConfig = simular().seObtieneLaConfiguracionParaInput(codigoTipoProcedimiento, codigoTipoInput, nodoProcedimiento);
        configDatos = mockConfig.getConfigDatos();

        RecoveryBPMfwkDDTipoInput mockTipoInput = mock(RecoveryBPMfwkDDTipoInput.class);
        when(mockTipoInput.getCodigo()).thenReturn(codigoTipoInput);
        
        when(mockInput.getIdProcedimiento()).thenReturn(datosInput.getIdProcedimiento());
        when(mockInput.getDatos()).thenReturn(datosInput.getDatosInput());
        when(mockInput.getTipo()).thenReturn(mockTipoInput);

        when(mockConfig.getConfigDatos()).thenReturn(configDatos);

        
    }

    @Override
    public void childAfter() {
        mockConfig = null;
        datosInput = null;
        reset(mockInput);
        configDatos = null;
        codigoTipoProcedimiento = null;
        codigoTipoInput = null;
        nodoProcedimiento = null;
        nodosProcedimiento = null;
    }
    
    /**
     * Testea el caso general para el guardado de datos al procedimiento
     * @throws Exception 
     */
    @Test
    public void testCasoGeneralGuardarDatos() throws Exception {

    	executor.execute(mockInput);

        try {
            verificar().seHanGuardadoLosDatos(mockInput, mockConfig);
        } catch (RecoveryBPMfwkConfiguracionError e) {
            fail("No debería haberse lanzado la excepción.");
        }
    }
    
    /**
     * Testea el caso en el que la configuración es nula.
     * @throws Exception 
     */
    @Test
    public void testConfiguracionNula() throws Exception {
    	when(mockConfigManager.getInputConfigNodo(codigoTipoInput, codigoTipoProcedimiento, nodoProcedimiento)).thenReturn(null);
    	executor.execute(mockInput);

        try {
            verificar().noSeHanGuardadoLosDatos(mockInput, mockConfig);
        } catch (RecoveryBPMfwkConfiguracionError e) {
            fail("No debería haberse lanzado la excepción.");
        }
    }    
    
    /**
     * Testea el caso en el que se produzca una excepción al guardar los datos.
     * @throws Exception 
     */
    
	@Test(expected= RecoveryBPMfwkError.class)
	@SuppressWarnings("unchecked")
    public void testSeProduceUnaExcepcion() throws Exception {
    	
    	doThrow(new RuntimeException("mock test exception")).when(mockDatosManager).guardaDatos(any(Long.class), any(Map.class), any(RecoveryBPMfwkCfgInputDto.class));
    	executor.execute(mockInput);
    	
    }
	
    /**
     * Testea el caso en el que se le pasa un valor de entrada nulo.
     * @throws Exception 
     */
    @Test(expected=IllegalArgumentException.class)
    public void testDatoNulo() throws Exception {
    	when(mockInput.getIdProcedimiento()).thenReturn(null);
        executor.execute(mockInput);
        fail("No debería haberse ejecutarse esta línea.");
    }

}
