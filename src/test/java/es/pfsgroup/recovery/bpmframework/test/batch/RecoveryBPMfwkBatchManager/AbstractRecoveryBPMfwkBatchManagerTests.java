package es.pfsgroup.recovery.bpmframework.test.batch.RecoveryBPMfwkBatchManager;

import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.capgemini.devon.bo.Executor;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkRunApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;
import es.pfsgroup.recovery.bpmframework.batch.RecoveryBPMfwkBatchManager;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.test.AbstractRecoveryBPMFwkTests;


/**
 * Clase genérica para todos los tests del {@link RecoveryBPMfwkBatchManager}
 * @author bruno
 *
 */
public abstract class AbstractRecoveryBPMfwkBatchManagerTests extends AbstractRecoveryBPMFwkTests{   
    /*
     * Manager bajo test
     */
    @InjectMocks
    protected RecoveryBPMfwkBatchManager manager;
    
    @Mock
    private RecoveryBPMfwkInputApi mockInputManager;
    
    @Mock
    private ApiProxyFactory mockProxyFactory;

    @Mock
    private GenericABMDao mockGenericDao;

	@Mock
	private RecoveryBPMfwkRunApi mockRecoveryBPMRunApi;

	@Mock
	protected Executor mockExecutor;
	
    private VerificadorRecoveryBPMfwkBatchManagerTests verificador;

    private SimuladorRecoveryBPMfwkBatchManagerTests simulador;

    /*
     * Inicialización genérica de todos los tests
     */
    @Before
    public void before(){
        random = new Random();
        verificador = new VerificadorRecoveryBPMfwkBatchManagerTests(mockInputManager, mockGenericDao, mockRecoveryBPMRunApi, mockExecutor);
        simulador = new SimuladorRecoveryBPMfwkBatchManagerTests(mockInputManager, mockGenericDao, mockRecoveryBPMRunApi);
        when(mockProxyFactory.proxy(RecoveryBPMfwkInputApi.class)).thenReturn(mockInputManager);
		when(mockProxyFactory.proxy(RecoveryBPMfwkRunApi.class)).thenReturn(mockRecoveryBPMRunApi);
        childBefore();
    }
    
    @After
    public void after(){
        childAfter();
        manager = null;
        random = null;
        verificador = null;
        simulador = null;
        reset(mockProxyFactory);
        reset(mockGenericDao);
        reset(mockInputManager);
        reset(mockRecoveryBPMRunApi);
        reset(mockExecutor);
    }

    /**
     * Cra un objeto callback para usarlo en los tests
     * 
     * @param bonameStartProcess
     * @param bonameEndProcess
     * @param bonameOnSuccess
     * @param bonameOnError
     * @return
     */
    protected RecoveryBPMfwkCallback generaCallback(final String bonameStartProcess, final String bonameEndProcess, final String bonameOnSuccess, final String bonameOnError) {
        return new RecoveryBPMfwkCallback() {
    
            @Override
            public String onSuccess() {
                return bonameOnSuccess;
            }
    
            @Override
            public String onProcessStart() {
                return bonameStartProcess;
            }
    
            @Override
            public String onProcessEnd() {
                return bonameEndProcess;
            }
    
            @Override
            public String onError() {
                return bonameOnError;
            }
        };
    }

    /**
     * Acceso al verificador de interacciones del manager
     * @return
     */
    protected VerificadorRecoveryBPMfwkBatchManagerTests verificar() {
       return verificador;
    }
    
    /**
     * Acceso al simulador de interacciones del manager
     * @return
     */
    protected SimuladorRecoveryBPMfwkBatchManagerTests simular() {
        return this.simulador;
    }
}
