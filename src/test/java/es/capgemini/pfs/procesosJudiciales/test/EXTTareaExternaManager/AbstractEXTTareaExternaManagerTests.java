package es.capgemini.pfs.procesosJudiciales.test.EXTTareaExternaManager;

import static org.mockito.Mockito.*;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.capgemini.pfs.procesosJudiciales.EXTTareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.dao.EXTTareaExternaDao;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

/**
 * Clase genérica para los tests de {@link EXTTareaExternaManager}
 * @author bruno
 *
 */
public abstract class AbstractEXTTareaExternaManagerTests {
    
    @InjectMocks
    protected EXTTareaExternaManagerForTesting manager;
   
    protected EXTTareaExternaManagerForTesting managerSpy;
    
    protected Random random;
    
    private SimuadorInteraccionesEXTTareaExternaManager simulador;
    


    @Mock
    private ApiProxyFactory mockProxyFactory;
    
    @Mock
    private EXTTareaExternaDao mockTareaExternaDao;

    @Before
    public void before(){
        random = new Random();
        simulador = new SimuadorInteraccionesEXTTareaExternaManager(mockProxyFactory, mockTareaExternaDao);
        managerSpy = spy(manager);
        
        doReturn(null).when(managerSpy).getListadoTareasSinOptimizar(any(Long.class));
        doReturn(null).when(managerSpy).obtenerTareasDeUsuarioPorProcedimientoConOptimizacion(any(Long.class));
        
        childBefore();
    }
    
    @After
    public void after(){
        childAfter();
        simulador = null;
        managerSpy = null;
        random = null;
        
        reset(mockProxyFactory);
        reset(mockTareaExternaDao);
    }
    
    public abstract void childBefore();
    
    public abstract void childAfter();

    protected SimuadorInteraccionesEXTTareaExternaManager simular() {
        return this.simulador;
    }
    
}
