package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputGenDocExecutor;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.List;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputGenDocExecutor;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

/**
 * Simulador de interacciones para {@link RecoveryBPMfwkInputGenDocExecutor}
 * 
 * @author manuel
 * 
 */
public class SimuladorRecoveryBPMfwkInputGenDocExecutor {

    final private RecoveryBPMfwkConfigApi mockConfigManager;

    final private ProcedimientoApi mockProcedimientosManager;
    
    final private EXTJBPMProcessApi mockEXTJBPMProcessApi;

    /**
     * Tenemos que pasar los mocks de los colaboraores
     * 
     * @param mockConfigManager
     * @param mockProcedimientosManager
     */
    public SimuladorRecoveryBPMfwkInputGenDocExecutor(RecoveryBPMfwkConfigApi mockConfigManager, ProcedimientoApi mockProcedimientosManager, EXTJBPMProcessApi mockEXTJBPMProcessApi) {
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
    public RecoveryBPMfwkCfgInputDto simulaSeObtieneLaConfiguracionParaInput(String codigoTipoProcedimiento, String codigoTipoInput, String codigoPlantilla, String nodoProcedimiento) {

        RecoveryBPMfwkCfgInputDto config = mock(RecoveryBPMfwkCfgInputDto.class);
        when(config.getCodigoPlantilla()).thenReturn(codigoPlantilla);

        try {
            when(mockConfigManager.getInputConfigNodo(codigoTipoInput, codigoTipoProcedimiento, nodoProcedimiento)).thenReturn(config);
        } catch (RecoveryBPMfwkError e) {
            // No se va a producir ningún error
        }
        return config;
    }

    /**
     * Simula que se obtiene un procedimiento con el asunto adecuado.
     * 
     * @param idAsunto
     * @param idProcedimiento
     * @param codigoTipoProcedimiento
     */
    public void simulaSeObtieneProcedimiento(Long idProcedimiento, Long idAsunto, String codigoTipoProcedimiento) {
        Asunto mockAsunto = mock(Asunto.class);
        when(mockAsunto.getId()).thenReturn(idAsunto);

        TipoProcedimiento mockTipo = mock(TipoProcedimiento.class);
        when(mockTipo.getCodigo()).thenReturn(codigoTipoProcedimiento);

        Procedimiento mockProcedimiento = mock(Procedimiento.class);
        when(mockProcedimiento.getTipoProcedimiento()).thenReturn(mockTipo);
        when(mockProcedimiento.getAsunto()).thenReturn(mockAsunto);
        when(mockProcedimiento.getId()).thenReturn(idProcedimiento);

        when(mockProcedimientosManager.getProcedimiento(idProcedimiento)).thenReturn(mockProcedimiento);
    }

    /**
     * Simula que se obtiene el nodo en el que se encuenta un procedimiento.
     * @param nodoProcedimiento nombre de nodo.
     */
    public void simulaSeObtieneElNodoProcedimiento(List<String> nodosProcedimiento) {
    	
    	//when(mockJBPMProcessApi.getActualNode(any(Long.class))).thenReturn(nodoProcedimiento);
    	when(mockEXTJBPMProcessApi.getCurrentNodes(any(Long.class))).thenReturn(nodosProcedimiento);
    }
    
    /**
     * Simula que se genera la Documentación.
     */
    public void simulaSeGeneraDocumentacion() {
        // no se hace nada porque el método devuelve void.
    }

}
