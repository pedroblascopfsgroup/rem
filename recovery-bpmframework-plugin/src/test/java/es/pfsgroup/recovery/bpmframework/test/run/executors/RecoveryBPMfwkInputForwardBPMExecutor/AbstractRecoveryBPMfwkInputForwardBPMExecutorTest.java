package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputForwardBPMExecutor;

import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi;
import es.pfsgroup.recovery.bpmframework.bpm.RecoveryBPMFwkProcessApi;
import es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputForwardBPMExecutor;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;
import es.pfsgroup.recovery.bpmframework.test.AbstractRecoveryBPMFwkTests;
import es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputAvanzarBPMExecutor.SimuladorRecoveryBPMfwkInputAvanzarBPMExecutor;
import es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputAvanzarBPMExecutor.VerificadorRecoveryBPMfwkInputAvanzarBPMExecutor;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

/**
 * Clase genérica para todos los tests de {@link RecoveryBPMfwkInputInformarDatosExecutor}
 * @author bruno
 *
 */
public abstract class AbstractRecoveryBPMfwkInputForwardBPMExecutorTest extends AbstractRecoveryBPMFwkTests{

    @InjectMocks
    protected RecoveryBPMfwkInputForwardBPMExecutor executor;
    
    @Mock
    protected RecoveryBPMfwkInput mockInput;
    
    @Mock
    private RecoveryBPMfwkDatosProcedimientoApi mockDatosManager;
    
    @Mock
    private ProcedimientoApi mockProcedimientosManager;

    @Mock
    private RecoveryBPMfwkConfigApi mockConfigManager;

    @Mock
    private EXTJBPMProcessApi mockEXTJBPMProcessManager;
    
    @Mock
    private ApiProxyFactory mockProxyFactory;
    
    @Mock
    private RecoveryBPMFwkProcessApi mockBpmFwkProcessManager;
    
    private VerificadorRecoveryBPMfwkInputAvanzarBPMExecutor verificador;

    private SimuladorRecoveryBPMfwkInputAvanzarBPMExecutor simulador;
    
    @Before
    public void before(){
        verificador = new VerificadorRecoveryBPMfwkInputAvanzarBPMExecutor(mockDatosManager, mockEXTJBPMProcessManager, mockBpmFwkProcessManager);
        simulador = new SimuladorRecoveryBPMfwkInputAvanzarBPMExecutor( mockConfigManager,  mockProcedimientosManager, mockEXTJBPMProcessManager);
        random = new Random();
        
        when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientosManager);
        when(mockProxyFactory.proxy(RecoveryBPMfwkConfigApi.class)).thenReturn(mockConfigManager);
        when(mockProxyFactory.proxy(EXTJBPMProcessApi.class)).thenReturn(mockEXTJBPMProcessManager);
        when(mockProxyFactory.proxy(RecoveryBPMFwkProcessApi.class)).thenReturn(mockBpmFwkProcessManager);
        
        childBefore();
    }
    
    @After
    public void after(){
        childAfter();
        executor = null;
        verificador = null;
        random = null;
        simulador = null;
        reset(mockInput);
        reset(mockDatosManager);
        reset(mockProcedimientosManager);
        reset(mockConfigManager);
        reset(mockEXTJBPMProcessManager);
        reset(mockProxyFactory);
        reset(mockBpmFwkProcessManager);
    }

    /**
     * Acceso al verificador de interacciones
     * @return
     */
    protected VerificadorRecoveryBPMfwkInputAvanzarBPMExecutor verificar() {
       return verificador;
    }

    /**
     * Acceso al simulador de interacciones.
     * 
     * @return
     */
    protected SimuladorRecoveryBPMfwkInputAvanzarBPMExecutor simular() {
        return this.simulador;
    }
    
}
