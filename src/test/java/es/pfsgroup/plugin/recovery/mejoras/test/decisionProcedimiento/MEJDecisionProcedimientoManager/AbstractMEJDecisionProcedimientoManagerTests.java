package es.pfsgroup.plugin.recovery.mejoras.test.decisionProcedimiento.MEJDecisionProcedimientoManager;

import java.util.ArrayList;
import java.util.Random;

import static org.mockito.Mockito.*;

import org.hibernate.proxy.ProxyFactory;
import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.context.ApplicationContext;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.MEJDecisionProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJConfiguracionDerivacionProcedimiento;
import groovy.mock.interceptor.MockProxyMetaClass;

/**
 * Clase gen�rica a todas las suites de pruebas para
 * MEJDecisionProcedimientoManager
 * 
 * @author bruno
 * 
 */
public abstract class AbstractMEJDecisionProcedimientoManagerTests {

    /**
     * Clase para falsear el HibernateUtils del commons-java
     * @author bruno
     *
     */
    public class DummyHibernateUtils extends HibernateUtils{

        @Override
        public <T> T mergeObject(T o) {
            return o;
        }

    }

    @InjectMocks
    protected MEJDecisionProcedimientoManager manager;

    protected Random random;

    private SimuladorInteraccionesMEJDecisionProcedimientoManager simuladorInteracciones;

    @Mock
    private Executor mockExecutor;

    @Mock
    private ApiProxyFactory mockProxyFactory;

    @Mock
    private FuncionManager mockFuncionManager;

    @Mock
    private GenericABMDao mockGenericDao;

    @Mock
    private JBPMProcessManager mockJbpmUtil;

    @Mock
    private TareaNotificacionApi mockTareaNotificacionManager;

    @Mock
    private ApplicationContext mockSpringApplicationContext;
    
    @Mock
    private MEJConfiguracionDerivacionProcedimiento mockConfiguracionDerivacionProcedimiento;

    private VerificadorInteraccionesMEJDecisionProcedimientoManager verificador;

    @Before
    public void before() {
        random = new Random();
        simuladorInteracciones = new SimuladorInteraccionesMEJDecisionProcedimientoManager(mockExecutor, mockProxyFactory, mockFuncionManager, mockGenericDao, mockTareaNotificacionManager, mockConfiguracionDerivacionProcedimiento);
        verificador = new VerificadorInteraccionesMEJDecisionProcedimientoManager(mockGenericDao, mockExecutor, mockJbpmUtil);
        
        when(mockProxyFactory.proxy(TareaNotificacionApi.class)).thenReturn(mockTareaNotificacionManager);

        new HibernateUtils().setApplicationContext(mockSpringApplicationContext);
        when(mockSpringApplicationContext.getBean("hibernateUtils")).thenReturn(new DummyHibernateUtils());
        
        setUpChildTest();
    }

    @After
    public void after() {
        tearDownChildTest();
        random = null;
        verificador = null;
        simuladorInteracciones = null;
        reset(mockExecutor);
        reset(mockProxyFactory);
        reset(mockFuncionManager);
        reset(mockTareaNotificacionManager);
        reset(mockSpringApplicationContext);
        reset(mockGenericDao);
        reset(mockConfiguracionDerivacionProcedimiento);
    }

    /**
     * C�digo de inicializaci�n pre-test de cada hijo
     */
    public abstract void setUpChildTest();

    /**
     * C�digo de limpieza post-tet de cada hijo
     */
    public abstract void tearDownChildTest();

    /**
     * M�todo que sirve para simular interacciones
     * 
     * @return Devuelve un simulador de interacciones con un m�todo por cada
     *         interacci�n del manager
     */
    protected SimuladorInteraccionesMEJDecisionProcedimientoManager simularInteracciones() {
        return this.simuladorInteracciones;
    }

    /**
     * Acceso al verificador de interacciones
     * @return
     */
    protected VerificadorInteraccionesMEJDecisionProcedimientoManager verifica() {
        return this.verificador;
    }

    /**
     * Inicializa un array para los id de las derivaciones de procedimientos. A
     * usar si queremos probar que se derivan.
     * 
     * @param numPrcDerivar
     * @return
     */
    protected Long[] initArray(int numPrcDerivar) {
        ArrayList<Long> list = new ArrayList<Long>();
        for (int i = 0; i < Math.abs(numPrcDerivar); i++){
            list.add(random.nextLong());
        }
        return list.toArray(new Long[]{});
    }

}
