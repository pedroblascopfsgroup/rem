package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Map;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkGrupoDatoDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

/**
 * Simulador de interacciones para
 * {@link RecoveryBPMfwkInputInformarDatosExecutor}
 * 
 * @author bruno
 * 
 */
public class SimuladorRecoveryBPMfwkInputInformarDatosExecutor {

    final private RecoveryBPMfwkConfigApi mockConfigManager;

    final private ProcedimientoApi mockProcedimientosManager;
    
    final private EXTJBPMProcessApi mockEXTJBPMProcessApi;

    /**
     * Tenemos que pasar los mocks de los colaboraores
     * 
     * @param mockConfigManager
     * @param mockProcedimientosManager
     */
    public SimuladorRecoveryBPMfwkInputInformarDatosExecutor(RecoveryBPMfwkConfigApi mockConfigManager, ProcedimientoApi mockProcedimientosManager, EXTJBPMProcessApi mockEXTJBPMProcessApi) {
        super();
        this.mockConfigManager = mockConfigManager;
        this.mockProcedimientosManager = mockProcedimientosManager;
        this.mockEXTJBPMProcessApi = mockEXTJBPMProcessApi;
    }

    /**
     * Simula que se obtiene una determinada configuración para el tipo de Input
     * 
     * @param codigoTipoProcedimiento
     * @param codigoTipoInput
     * @return
     */
    public RecoveryBPMfwkCfgInputDto seObtieneLaConfiguracionParaInput(String codigoTipoProcedimiento, String codigoTipoInput, String nodoProcedimiento) {
        @SuppressWarnings("unchecked")
        Map<String, RecoveryBPMfwkGrupoDatoDto> configDatos = mock(Map.class);

        RecoveryBPMfwkCfgInputDto config = mock(RecoveryBPMfwkCfgInputDto.class);
        when(config.getConfigDatos()).thenReturn(configDatos);

        try {
            when(mockConfigManager.getInputConfigNodo(codigoTipoInput, codigoTipoProcedimiento, nodoProcedimiento)).thenReturn(config);
        } catch (RecoveryBPMfwkError e) {
            // No se va a producir ningún error
        }
        return config;
    }

    /**
     * Simula que se obtiene un procedimiento del tipo determinado
     * 
     * @param codigoTipoProcedimiento
     * @param idProcedimiento
     */
    public void simulaSeObtieneProcedimiento(String codigoTipoProcedimiento, Long idProcedimiento) {
        TipoProcedimiento mockTipo = mock(TipoProcedimiento.class);
        when(mockTipo.getCodigo()).thenReturn(codigoTipoProcedimiento);

        Procedimiento mockProcedimiento = mock(Procedimiento.class);
        when(mockProcedimiento.getTipoProcedimiento()).thenReturn(mockTipo);

        when(mockProcedimientosManager.getProcedimiento(idProcedimiento)).thenReturn(mockProcedimiento);

    }

	public void simulaSeObtieneNodoProcedimiento(List<String> nodosProcedimiento) {
		when(mockEXTJBPMProcessApi.getCurrentNodes(any(Long.class))).thenReturn(nodosProcedimiento);
	}

}
