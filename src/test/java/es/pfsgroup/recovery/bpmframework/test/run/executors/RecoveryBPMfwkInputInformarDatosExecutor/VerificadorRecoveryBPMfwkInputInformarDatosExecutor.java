package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.util.Map;

import org.mockito.ArgumentCaptor;

import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
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
public class VerificadorRecoveryBPMfwkInputInformarDatosExecutor {

    private RecoveryBPMfwkDatosProcedimientoApi mockDatosManager;

    /**
     * Hay que pasarle mocks de todos los colaboradores
     * 
     * @param mockDatosManager
     */
    public VerificadorRecoveryBPMfwkInputInformarDatosExecutor(RecoveryBPMfwkDatosProcedimientoApi mockDatosManager) {
        super();
        this.mockDatosManager = mockDatosManager;
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
    @SuppressWarnings({ "rawtypes", "unchecked" })
	public void seHanGuardadoLosDatos(final RecoveryBPMfwkInput input, final RecoveryBPMfwkCfgInputDto config) throws RecoveryBPMfwkConfiguracionError {
        Long idProcedimiento = input.getIdProcedimiento();
        ArgumentCaptor<Map> datosCaptor = ArgumentCaptor.forClass(Map.class);
        ArgumentCaptor<RecoveryBPMfwkCfgInputDto> configCaptor = ArgumentCaptor.forClass(RecoveryBPMfwkCfgInputDto.class);
        verify(mockDatosManager, times(1)).guardaDatos(eq(idProcedimiento), datosCaptor.capture(), configCaptor.capture());
        assertEquals("El mapa de datos no es el esperado", input.getDatos(), datosCaptor.getValue());
        assertEquals("La configuración no es la esperada", config, configCaptor.getValue());
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
	public void noSeHanGuardadoLosDatos(RecoveryBPMfwkInput input,	RecoveryBPMfwkCfgInputDto config) {
		
        Long idProcedimiento = input.getIdProcedimiento();
        ArgumentCaptor<Map> datosCaptor = ArgumentCaptor.forClass(Map.class);
        ArgumentCaptor<RecoveryBPMfwkCfgInputDto> configCaptor = ArgumentCaptor.forClass(RecoveryBPMfwkCfgInputDto.class);
        verify(mockDatosManager, times(0)).guardaDatos(eq(idProcedimiento), datosCaptor.capture(), configCaptor.capture());
        
		
	}

}
