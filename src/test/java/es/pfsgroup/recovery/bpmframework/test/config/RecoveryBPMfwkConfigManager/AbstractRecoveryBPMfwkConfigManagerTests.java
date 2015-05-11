package es.pfsgroup.recovery.bpmframework.test.config.RecoveryBPMfwkConfigManager;

import static org.mockito.Mockito.reset;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.bpmframework.config.RecoveryBPMfwkConfigManager;
import es.pfsgroup.recovery.bpmframework.test.AbstractRecoveryBPMFwkTests;

/**
 * Clase abstracta genérica para todos los tests de la clase RecoveryBPMfwkConfigManager
 * 
 * @author manuel
 * 
 */
public abstract class  AbstractRecoveryBPMfwkConfigManagerTests  extends AbstractRecoveryBPMFwkTests{
	
    /*
     * Mánager bajo test
     */
    @InjectMocks
    protected RecoveryBPMfwkConfigManager manager;
    
    @Mock
    private GenericABMDao mockGenericDao;
    
    private SimuladorRecoveryBPMfwkConfigManager simulador;
    private VerificadorRecoveryBPMfwkConfigManager verificador;
    
    /*
     * Inicialización genérica de todos los tests
     */
    @Before
    public void before() {
        verificador = new VerificadorRecoveryBPMfwkConfigManager(mockGenericDao);
        simulador = new SimuladorRecoveryBPMfwkConfigManager(mockGenericDao);
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
    protected SimuladorRecoveryBPMfwkConfigManager simular() {
        return this.simulador;
    }

    /**
     * Acceso al verificador de interacciones del manager
     * @return
     */
    protected VerificadorRecoveryBPMfwkConfigManager verificar() {
        return this.verificador;
    }    

}
