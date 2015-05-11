package es.pfsgroup.recovery.bpmframework.test.datosprc.RecoveryBPMfwkDatosProcedimientoManager;

import static org.mockito.Mockito.*;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoManager;
import es.pfsgroup.recovery.bpmframework.test.AbstractRecoveryBPMFwkTests;

/**
 * Clase abstracta genérica para todos los tests de la clase {@link RecoveryBPMfwkDatosProcedimientoManager}
 * 
 * @author manuel
 * 
 */
public abstract class  AbstractRecoveryBPMfwkDatosProcedimientoManagerTests  extends AbstractRecoveryBPMFwkTests{
	
    /*
     * Mánager bajo test
     */
    @InjectMocks
    protected RecoveryBPMfwkDatosProcedimientoManager manager;
    
    @Mock
    private ApiProxyFactory mockProxyFactory;
    
    @Mock
    private ProcedimientoApi mockProcedimientosManager;    
    
    @Mock
    private GenericABMDao mockGenericDao;
    
    private SimuladorRecoveryBPMfwkDatosProcedimientoManager simulador;
    private VerificadorRecoveryBPMfwkDatosProcedimientoManager verificador;
    
    /*
     * Inicialización genérica de todos los tests
     */
    @Before
    public void before() {
        verificador = new VerificadorRecoveryBPMfwkDatosProcedimientoManager(mockGenericDao);
        simulador = new SimuladorRecoveryBPMfwkDatosProcedimientoManager(mockGenericDao, mockProcedimientosManager);
        random = new Random();
        
        when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientosManager);
        
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
    protected SimuladorRecoveryBPMfwkDatosProcedimientoManager simular() {
        return this.simulador;
    }

    /**
     * Acceso al verificador de interacciones del manager
     * @return
     */
    protected VerificadorRecoveryBPMfwkDatosProcedimientoManager verificar() {
        return this.verificador;
    }    

}
