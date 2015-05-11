package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputAvanzarBPMExecutor;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.util.Map;

import org.mockito.ArgumentCaptor;

import es.pfsgroup.recovery.api.JBPMProcessApi;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.bpm.RecoveryBPMFwkProcessApi;
import es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkConfiguracionError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;

/**
 * Verificador de interacciones para
 * {@link RecoveryBPMfwkInputInformarDatosExecutor}
 * 
 * @author bruno
 * 
 */
public class VerificadorRecoveryBPMfwkInputAvanzarBPMExecutor {

    private final RecoveryBPMfwkDatosProcedimientoApi mockDatosManager;

    private final JBPMProcessApi mockJBPMProcessManager;

    private final RecoveryBPMFwkProcessApi mockBpmFwjProcessManager;

    /**
     * Hay que pasarle mocks de todos los colaboradores
     * 
     * @param mockDatosManager
     */
    public VerificadorRecoveryBPMfwkInputAvanzarBPMExecutor(final RecoveryBPMfwkDatosProcedimientoApi mockDatosManager, final JBPMProcessApi mockJBPMProcessManager,
            final RecoveryBPMFwkProcessApi mockBpmFwjProcessManager) {
        super();
        this.mockDatosManager = mockDatosManager;
        this.mockJBPMProcessManager = mockJBPMProcessManager;
        this.mockBpmFwjProcessManager = mockBpmFwjProcessManager;
    }

    /**
     * Verifica que se hayan guardado los datos al procedimiento
     * 
     * @param input
     * @param config
     * @throws RecoveryBPMfwkConfiguracionError
     *             Se lanza esta excepción si durante la simulación se programa
     *             que falle el manager
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public void seHanGuardadoLosDatos(final RecoveryBPMfwkInput input, final RecoveryBPMfwkCfgInputDto config) throws RecoveryBPMfwkConfiguracionError {
        Long idProcedimiento = input.getIdProcedimiento();
        ArgumentCaptor<Map> datosCaptor = ArgumentCaptor.forClass(Map.class);
        ArgumentCaptor<RecoveryBPMfwkCfgInputDto> configCaptor = ArgumentCaptor.forClass(RecoveryBPMfwkCfgInputDto.class);
        verify(mockDatosManager, times(1)).guardaDatos(eq(idProcedimiento), datosCaptor.capture(), configCaptor.capture());
        assertEquals("El mapa de datos no es el esperado", input.getDatos(), datosCaptor.getValue());
        assertEquals("La configuración no es la esperada", config, configCaptor.getValue());
    }

    /**
     * Verifica que se ejecute el método que avanza un BPM.
     * 
     * @param processBPM
     * @param nombreTransicion
     * @param mockInput
     */
    public void seAvanzaBPM(final Long processBPM, final String nombreTransicion, final RecoveryBPMfwkInput mockInput) {

        //verify(mockJBPMProcessManager, times(1)).signalProcess(eq(processBPM), eq(nombreTransicion));
        // Se deja de usar el prcessManager estándar para usar el nuevo que prové compatibilidad con los Inputs
        verify(mockBpmFwjProcessManager, times(1)).signalProcess(eq(processBPM), eq(nombreTransicion), eq(mockInput));

    }

    public void noSeAvanzaBPM(Long processBPM, String nombreTransicion) {
        verify(mockJBPMProcessManager, times(0)).signalProcess(eq(processBPM), eq(nombreTransicion));
    }

}
