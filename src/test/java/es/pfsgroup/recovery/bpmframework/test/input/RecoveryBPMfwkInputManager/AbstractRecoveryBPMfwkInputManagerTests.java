package es.pfsgroup.recovery.bpmframework.test.input.RecoveryBPMfwkInputManager;

import static org.mockito.Mockito.*;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputManager;
import es.pfsgroup.recovery.bpmframework.test.AbstractRecoveryBPMFwkTests;

/**
 * Clase abstracta genérica para todos los tests con el código de inicialización
 * general
 * 
 * @author bruno
 * 
 */
public abstract class AbstractRecoveryBPMfwkInputManagerTests extends AbstractRecoveryBPMFwkTests{
   
    
    /*
     * Mánager bajo test
     */
    @InjectMocks
    protected RecoveryBPMfwkInputManager manager;
    
    @Mock
    private GenericABMDao mockGenericDao;
    
    private SimuladorRecoveryBPMfwkInputManager simulador;
    private VerificadorRecoveryBPMfwkInputManager verificador;
    

    /*
     * Inicialización genérica de todos los tests
     */
    @Before
    public void before() {
        verificador = new VerificadorRecoveryBPMfwkInputManager(mockGenericDao);
        simulador = new SimuladorRecoveryBPMfwkInputManager(mockGenericDao);
        random = new Random();
        childBefore();
    }

    @After
    public void after() {
        childAfter();
        random = null;
        verificador = null;
        simulador = null;
        reset(mockGenericDao);
    }

    /**
     * Acceso al simulador de interacciones para el manager
     * @return
     */
    protected SimuladorRecoveryBPMfwkInputManager simular() {
        return this.simulador;
    }

    /**
     * Acceso al verificador de interacciones del manager
     * @return
     */
    protected VerificadorRecoveryBPMfwkInputManager verificar() {
        return this.verificador;
    }

}
