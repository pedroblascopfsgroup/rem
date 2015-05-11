package es.pfsgroup.recovery.bpmframework.test.run.factory.RecoveryBPMfwkInputExecutorFactoryImpl;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Map;

import org.springframework.context.ApplicationContext;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputAvanzarBPMExecutor;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputChainBoBPMExecutor;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputExecutor;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputForwardBPMExecutor;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputGenDocExecutor;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;
import es.pfsgroup.recovery.bpmframework.run.factory.RecoveryBPMfwkInputExecutorFactoryImpl;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

/**
 * Simulador para las interacciones de
 * {@link RecoveryBPMfwkInputExecutorFactoryImpl}
 * 
 * @author bruno
 * 
 */
public class SimuladorRecoveryBPMfwkInputExecutorFactoryImpl {

    private ProcedimientoApi mockProcedimientoManager;

    private RecoveryBPMfwkConfigApi mockConfigManager;

    private ApplicationContext mockApplicationContex;
    
    private EXTJBPMProcessApi mockEXTJBPMProcessApi;

    /**
     * Es necesario pasar los mocks de los colaboradores
     * 
     * @param mockProcedimientoManager
     * @param mockConfigManager
     */
    public SimuladorRecoveryBPMfwkInputExecutorFactoryImpl(ProcedimientoApi mockProcedimientoManager, RecoveryBPMfwkConfigApi mockConfigManager, ApplicationContext mockApplicationContex, EXTJBPMProcessApi mockEXTJBPMProcessApi) {
        super();
        this.mockProcedimientoManager = mockProcedimientoManager;
        this.mockConfigManager = mockConfigManager;
        this.mockApplicationContex = mockApplicationContex;
        this.mockEXTJBPMProcessApi = mockEXTJBPMProcessApi;
    }

    /**
     * Simula que se obtiene un procedimiento durante el test
     * 
     * @param idProcedimiento
     * @param codigoTipoProcedimiento
     */
    public void seObtieneElProcedimiento(Long idProcedimiento, String codigoTipoProcedimiento) {
        TipoProcedimiento mockTipo = mock(TipoProcedimiento.class);
        when(mockTipo.getCodigo()).thenReturn(codigoTipoProcedimiento);

        Procedimiento mockProcedimiento = mock(Procedimiento.class);
        when(mockProcedimiento.getId()).thenReturn(idProcedimiento);
        when(mockProcedimiento.getTipoProcedimiento()).thenReturn(mockTipo);

        when(mockProcedimientoManager.getProcedimiento(idProcedimiento)).thenReturn(mockProcedimiento);

    }
    
	/**
	 * Simula que se obtiene el nodo en el que se encuentra un procedimiento.
	 * @param nodoProcedimiento el nombre del nodo
	 */
	public void seObtieneElNodoProcedimiento(List<String> nodosProcedimiento) {

		//when(mockEXTJBPMProcessApi.getActualNode(any(Long.class))).thenReturn(nodoProcedimiento);
		when(mockEXTJBPMProcessApi.getCurrentNodes(any(Long.class))).thenReturn(nodosProcedimiento);
	}

    /**
     * Simula que se obtiene la configuración para el input durante el test
     * 
     * @param codigoTipoProcedimiento
     * @param codigoTipoInput
     * @param codigoTipoAccion
     * @param nodoProcedimiento 
     */
    public void seObtieneLaconfiguracion(String codigoTipoProcedimiento, String codigoTipoInput, String codigoTipoAccion, String nodoProcedimiento) {
        RecoveryBPMfwkCfgInputDto mockDtoConfig = mock(RecoveryBPMfwkCfgInputDto.class);
        when(mockDtoConfig.getCodigoTipoAccion()).thenReturn(codigoTipoAccion);

        try {
            when(mockConfigManager.getInputConfigNodo(codigoTipoInput, codigoTipoProcedimiento, nodoProcedimiento)).thenReturn(mockDtoConfig);
        } catch (RecoveryBPMfwkError e) {
            // No se va a producir ningún error
        }
    }

    /**
     * Simula que se inicializan los beans de spring y el ApplicationContex
     * devuelve los ejecutores.
     * 
     * @param beansMap
     *            mapa con los ejecutores que queremos inicializar.
     */
    public void seInicializanLosBeans(Map<String, RecoveryBPMfwkInputExecutor> beansMap) {

        when(mockApplicationContex.getBean("recoveryBPMfwkInputInformarDatosExecutor")).thenReturn(new RecoveryBPMfwkInputInformarDatosExecutor());
        when(mockApplicationContex.getBean("recoveryBPMfwkInputAvanzarBPMExecutor")).thenReturn(new RecoveryBPMfwkInputAvanzarBPMExecutor());
        when(mockApplicationContex.getBean("recoveryBPMfwkInputForwardBPMExecutor")).thenReturn(new RecoveryBPMfwkInputForwardBPMExecutor());
        when(mockApplicationContex.getBean("recoveryBPMfwkInputGenDocExecutor")).thenReturn(new RecoveryBPMfwkInputGenDocExecutor());
        when(mockApplicationContex.getBean("recoveryBPMfwkInputChainBoBPMExecutor")).thenReturn(new RecoveryBPMfwkInputChainBoBPMExecutor());

        when(mockApplicationContex.getBeansOfType(RecoveryBPMfwkInputExecutor.class)).thenReturn(beansMap);
    }



}
