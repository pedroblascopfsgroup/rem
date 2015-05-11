package es.pfsgroup.recovery.bpmframework.test.run.factory.RecoveryBPMfwkInputExecutorFactoryImpl;

import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.context.ApplicationContext;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi;
import es.pfsgroup.recovery.bpmframework.run.factory.RecoveryBPMfwkInputExecutorFactoryImpl;
import es.pfsgroup.recovery.bpmframework.test.AbstractRecoveryBPMFwkTests;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

/**
 * Clase genérica para todos los tests de la factoría
 * {@link RecoveryBPMfwkInputExecutorFactoryImpl}
 * 
 * @author bruno
 * 
 */
public abstract class AbstractRecoveryBPMfwkInputExecutorFactoryImplTests extends AbstractRecoveryBPMFwkTests {

    @InjectMocks
    protected RecoveryBPMfwkInputExecutorFactoryImpl executorFactory;
    
    @Mock
    private ApiProxyFactory mockProxyFactory;
    
    @Mock
    private ProcedimientoApi mockProcedimientosManager;
    
    @Mock
    private RecoveryBPMfwkConfigApi mockConfigManager;
    
    @Mock
    protected ApplicationContext mockApplicatioContext;
    
    @Mock
    protected EXTJBPMProcessApi mockEXTJBPMProcessApi;
    
    private SimuladorRecoveryBPMfwkInputExecutorFactoryImpl simulador;

	
    

    @Before
    public void before() {
        random = new Random();
        
        
        
        when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientosManager);
        when(mockProxyFactory.proxy(RecoveryBPMfwkConfigApi.class)).thenReturn(mockConfigManager);
        when(mockProxyFactory.proxy(EXTJBPMProcessApi.class)).thenReturn(mockEXTJBPMProcessApi);
        
        simulador = new SimuladorRecoveryBPMfwkInputExecutorFactoryImpl(mockProcedimientosManager, mockConfigManager, mockApplicatioContext, mockEXTJBPMProcessApi);
        childBefore();
    }

    @After
    public void after() {
        childAfter();
        random = null;
        reset(mockProcedimientosManager);
        reset(mockConfigManager);
        reset(mockProxyFactory);
        reset(mockApplicatioContext);
        reset(mockEXTJBPMProcessApi);
    }

    /**
     * Acceso al simulador de interacciones
     * 
     * @return
     */
    protected SimuladorRecoveryBPMfwkInputExecutorFactoryImpl simular() {
        return this.simulador;
    }

}
