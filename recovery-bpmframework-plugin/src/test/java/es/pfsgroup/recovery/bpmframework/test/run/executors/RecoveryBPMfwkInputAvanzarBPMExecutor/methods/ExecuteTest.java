package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputAvanzarBPMExecutor.methods;

import static org.junit.Assert.fail;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkGrupoDatoDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;
import es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputAvanzarBPMExecutor.AbstractRecoveryBPMfwkInputAvanzarBPMExecutorTest;

/**
 * Prueba el método execute para el
 * {@link RecoveryBPMfwkInputInformarDatosExecutor}
 * 
 * @author bruno
 * 
 */

@RunWith(MockitoJUnitRunner.class)
public class ExecuteTest extends AbstractRecoveryBPMfwkInputAvanzarBPMExecutorTest {

    private RecoveryBPMfwkCfgInputDto mockConfig;

    private DatosEntradaInput datosInput;

    private Map<String, RecoveryBPMfwkGrupoDatoDto> configDatos;

    private String codigoTipoProcedimiento;

    private String codigoTipoInput;

    private Long processBPM;

    private String nombreTransicion;

    private List<String> nodosProcedimiento;

    private String nodoProcedimiento;

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
     * 
     * @throws Exception
     */
    @Test
    public void testCasoGeneralAvanzarBPM() throws Exception {

        executor.execute(mockInput);

        try {
            verificar().seHanGuardadoLosDatos(mockInput, mockConfig);
            verificar().seAvanzaBPM(processBPM, mockConfig.getNombreTransicion(), mockInput);
        } catch (RecoveryBPMfwkError e) {
            fail("No debería haberse lanzado la excepción.");
        }
    }

    /**
     * Testea el caso en el que se le pasa un nombre de transición nula.
     * 
     * @throws Exception
     */
    @Test
    public void testTransicionNula() throws Exception {

        when(mockConfig.getNombreTransicion()).thenReturn(null);

        executor.execute(mockInput);

        verificar().noSeAvanzaBPM(processBPM, mockConfig.getNombreTransicion());
    }

    /**
     * Testea el caso en el que se produzca una excepción al avanzar BMP
     * 
     * @throws Exception
     */

    @Test(expected = RecoveryBPMfwkError.class)
    public void testSeProduceUnaExcepcion() throws Exception {

        doThrow(new RuntimeException("mock test exception")).when(mockBpmFwkProcessManager).signalProcess(any(Long.class), any(String.class), any(RecoveryBPMfwkInput.class));
        executor.execute(mockInput);

    }

}
