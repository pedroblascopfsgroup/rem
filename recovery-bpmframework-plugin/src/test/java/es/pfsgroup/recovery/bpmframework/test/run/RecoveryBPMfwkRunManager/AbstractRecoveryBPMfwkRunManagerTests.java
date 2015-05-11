package es.pfsgroup.recovery.bpmframework.test.run.RecoveryBPMfwkRunManager;

import static org.mockito.Mockito.*;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.run.RecoveryBPMfwkRunManager;
import es.pfsgroup.recovery.bpmframework.run.factory.RecoveryBPMfwkInputExecutorFactory;
import es.pfsgroup.recovery.bpmframework.test.AbstractRecoveryBPMFwkTests;

/**
 * Clase genérica de tests {@link RecoveryBPMfwkRunManager}
 * @author bruno
 *
 */
public abstract class AbstractRecoveryBPMfwkRunManagerTests extends AbstractRecoveryBPMFwkTests{
    
    @InjectMocks
    protected RecoveryBPMfwkRunManager manager;
    
    @Mock
    private ApiProxyFactory mockProxyFactory;
    
    @Mock
    private RecoveryBPMfwkInputApi mockInputManager;
    
    @Mock
    protected RecoveryBPMfwkInputExecutorFactory mockInputExecutorFactory;
    
    private VerificadorRecoveryBPMfwkRunManager verificador;

    private SimuladorRecoveryBPMfwkRunManager simulador;
    
    
    @Before
    public void before(){
        random = new Random();
        
        when(mockProxyFactory.proxy(RecoveryBPMfwkInputApi.class)).thenReturn(mockInputManager);
        verificador = new  VerificadorRecoveryBPMfwkRunManager(mockInputManager);
        simulador = new SimuladorRecoveryBPMfwkRunManager(mockInputManager, mockInputExecutorFactory);
   
        childBefore();
    }
    
    @After
    public void after(){
        childAfter();
        verificador = null;
        reset(mockInputManager);
        reset(mockProxyFactory);
        reset(mockInputExecutorFactory);
    }

    /**
     * Acceso al verificador de interacciones del manager
     * @return
     */
    protected VerificadorRecoveryBPMfwkRunManager verificar() {
        return this.verificador;
    }

    /**
     * Acceso al simulador de interacciones
     * @return
     */
    protected SimuladorRecoveryBPMfwkRunManager simular() {
        return this.simulador;
        
    }

}
