package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputForwardBPMExecutor.methods;

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
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;
import es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputForwardBPMExecutor.AbstractRecoveryBPMfwkInputForwardBPMExecutorTest;

/**
 * Prueba el método execute para el
 * {@link RecoveryBPMfwkInputInformarDatosExecutor}
 * 
 * @author bruno
 * 
 */
//TODO programar el caso de pruebas para cuando falle el execute en algún punto
@RunWith(MockitoJUnitRunner.class)
public class ExecuteTest extends AbstractRecoveryBPMfwkInputForwardBPMExecutorTest {

    private RecoveryBPMfwkCfgInputDto mockConfig;

    private DatosEntradaInput datosInput;

    private Map<String, RecoveryBPMfwkGrupoDatoDto> configDatos;

    private String codigoTipoProcedimiento;

    private String codigoTipoInput;
    
    private String nodoProcedimiento;
    
    private List<String> nodosProcedimiento;

	private Long processBPM;

	private String nombreTransicion; 

    @Override
    public void childBefore() {
        datosInput = new DatosEntradaInput(random);

        codigoTipoProcedimiento = "TP" + random.nextLong();
        codigoTipoInput = datosInput.getCodigoTipoInput();
        processBPM = random.nextLong();
        nombreTransicion = RandomStringUtils.randomAlphanumeric(20);
        nodoProcedimiento = RandomStringUtils.randomAlphanumeric(20);
        
        nodosProcedimiento = new ArrayList<String>();
        nodosProcedimiento.add(nodoProcedimiento);
        nodosProcedimiento.add(RandomStringUtils.randomAlphanumeric(20));
        nodosProcedimiento.add(RandomStringUtils.randomAlphanumeric(20));
        nodosProcedimiento.add(RandomStringUtils.randomAlphanumeric(20));
        
        simular().simulaSeObtieneProcedimiento(codigoTipoProcedimiento, datosInput.getIdProcedimiento(), processBPM);
        simular().simulaSeObtieneNodoProcedimiento(nodosProcedimiento);
        mockConfig = simular().seObtieneLaConfiguracionParaInput(codigoTipoProcedimiento, codigoTipoInput, nodoProcedimiento);
        when(mockConfig.getNombreTransicion()).thenReturn(nombreTransicion);
        
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
        processBPM = null;
        nombreTransicion = null;
        

    }

    /**
     * Testea el caso general para el guardado de datos al procedimiento
     */
    @Test
    public void testCasoGeneralForwardBPM()  throws Exception {
        executor.execute(mockInput);
        //proc.getProcessBPM(), config.getNombreTransicion()
        try {
            verificar().seHanGuardadoLosDatos(mockInput, mockConfig);
            verificar().seAvanzaBPM(processBPM, mockConfig.getNombreTransicion(), mockInput);
        } catch (RecoveryBPMfwkConfiguracionError e) {
            fail("No debería haberse lanzado la excepción.");
        }
    }

}
