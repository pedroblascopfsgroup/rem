package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputAvanzarBPMExecutor;

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
public class SimuladorRecoveryBPMfwkInputAvanzarBPMExecutor {

    final private RecoveryBPMfwkConfigApi mockConfigManager;

    final private ProcedimientoApi mockProcedimientosManager;
    
    final private EXTJBPMProcessApi mockEXTJBPMProcessApi;

    /**
     * Tenemos que pasar los mocks de los colaboraores
     * 
     * @param mockConfigManager
     * @param mockProcedimientosManager
     * @param mockJBPMProcessManager 
     * @param mockJBPMProcessManager
     */
    public SimuladorRecoveryBPMfwkInputAvanzarBPMExecutor(RecoveryBPMfwkConfigApi mockConfigManager, ProcedimientoApi mockProcedimientosManager, EXTJBPMProcessApi mockEXTJBPMProcessApi) {
        super();
        this.mockConfigManager = mockConfigManager;
        this.mockProcedimientosManager = mockProcedimientosManager;
        this.mockEXTJBPMProcessApi = mockEXTJBPMProcessApi;
    }

    /**
     * Simula que se obtiene una determinada configuraci�n para el tipo de Input
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
            // No se va a producir ning�n error
        }
        return config;
    }

    /**
     * Simula que se obtiene un procedimiento del tipo determinado
     * 
     * @param codigoTipoProcedimiento
     * @param idProcedimiento
     * @param processBPM
     */
    public void simulaSeObtieneProcedimiento(String codigoTipoProcedimiento, Long idProcedimiento, Long processBPM) {
        TipoProcedimiento mockTipo = mock(TipoProcedimiento.class);
        when(mockTipo.getCodigo()).thenReturn(codigoTipoProcedimiento);

        Procedimiento mockProcedimiento = mock(Procedimiento.class);
        when(mockProcedimiento.getTipoProcedimiento()).thenReturn(mockTipo);
        when(mockProcedimiento.getProcessBPM()).thenReturn(processBPM);

        when(mockProcedimientosManager.getProcedimiento(idProcedimiento)).thenReturn(mockProcedimiento);

    }
    
    /**
     * Simula se obtiene el nodo del procedimiento.
     * @param nodoProcedimiento nombre del nodo.
     */
    public void simulaSeObtieneNodoProcedimiento(List<String> nodosProcedimiento){
    	//when(mockJBPMProcessApi.getActualNode(any(Long.class))).thenReturn(nodoProcedimiento);
    	when(mockEXTJBPMProcessApi.getCurrentNodes(any(Long.class))).thenReturn(nodosProcedimiento);
    }

    /**
     * Simula que se avanza el BMP.
     */
    public void simulaSeAvanzaBPM() {
        // no se hace nada porque el m�todo devuelve void.
    }

}
