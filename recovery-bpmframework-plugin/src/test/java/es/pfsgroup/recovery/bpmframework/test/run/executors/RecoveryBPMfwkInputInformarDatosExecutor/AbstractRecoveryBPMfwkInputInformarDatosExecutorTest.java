package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;

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
import es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;
import es.pfsgroup.recovery.bpmframework.test.AbstractRecoveryBPMFwkTests;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

/**
 * Clase gen�rica para todos los tests de {@link RecoveryBPMfwkInputInformarDatosExecutor}
 * @author bruno
 *
 */
public abstract class AbstractRecoveryBPMfwkInputInformarDatosExecutorTest extends AbstractRecoveryBPMFwkTests{

    @InjectMocks
    protected RecoveryBPMfwkInputInformarDatosExecutor executor;
    
    @Mock
    protected RecoveryBPMfwkInput mockInput;
    
    @Mock
    protected RecoveryBPMfwkDatosProcedimientoApi mockDatosManager;
    
    @Mock
    private ProcedimientoApi mockProcedimientosManager;

    @Mock
    protected RecoveryBPMfwkConfigApi mockConfigManager;
    
    @Mock
    private ApiProxyFactory mockProxyFactory;
    
    @Mock
    private EXTJBPMProcessApi mockEXTJBPMProcessApi;
    
    private VerificadorRecoveryBPMfwkInputInformarDatosExecutor verificador;

    private SimuladorRecoveryBPMfwkInputInformarDatosExecutor simulador;
    
    @Before
    public void before(){
        verificador = new VerificadorRecoveryBPMfwkInputInformarDatosExecutor(mockDatosManager);
        simulador = new SimuladorRecoveryBPMfwkInputInformarDatosExecutor( mockConfigManager,  mockProcedimientosManager, mockEXTJBPMProcessApi);
        random = new Random();
        
        when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientosManager);
        when(mockProxyFactory.proxy(RecoveryBPMfwkConfigApi.class)).thenReturn(mockConfigManager);
        when(mockProxyFactory.proxy(EXTJBPMProcessApi.class)).thenReturn(mockEXTJBPMProcessApi);
        
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
        reset(mockEXTJBPMProcessApi);
    }

    /**
     * Acceso al verificador de interacciones
     * @return
     */
    protected VerificadorRecoveryBPMfwkInputInformarDatosExecutor verificar() {
       return verificador;
    }

    /**
     * Acceso al simulador de interacciones.
     * 
     * @return
     */
    protected SimuladorRecoveryBPMfwkInputInformarDatosExecutor simular() {
        return this.simulador;
    }
    
}
