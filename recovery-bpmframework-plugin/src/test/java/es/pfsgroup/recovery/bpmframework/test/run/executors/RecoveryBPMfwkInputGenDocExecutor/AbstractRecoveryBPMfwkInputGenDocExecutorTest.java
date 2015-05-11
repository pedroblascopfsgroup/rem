package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputGenDocExecutor;

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
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputGenDocExecutor;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;
import es.pfsgroup.recovery.bpmframework.test.AbstractRecoveryBPMFwkTests;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;

/**
 * Clase genérica para todos los tests de {@link RecoveryBPMfwkInputInformarDatosExecutor}
 * @author bruno
 *
 */
public abstract class AbstractRecoveryBPMfwkInputGenDocExecutorTest extends AbstractRecoveryBPMFwkTests{

    @InjectMocks
    protected RecoveryBPMfwkInputGenDocExecutor executor;
    
    @Mock
    protected RecoveryBPMfwkInput mockInput;
    
    @Mock
    private ProcedimientoApi mockProcedimientosManager;

    @Mock
    private RecoveryBPMfwkConfigApi mockConfigManager;

    @Mock
    protected GENINFInformesApi mockGENINFInformesManager;
    
    @Mock
    private ApiProxyFactory mockProxyFactory;
    
    @Mock
    private RecoveryBPMfwkDatosProcedimientoApi datosProcedimientoManager;

    @Mock
    private EXTJBPMProcessApi mockEXTJBPMProcessApi;
    
    private VerificadorRecoveryBPMfwkInputGenDocExecutor verificador;

    private SimuladorRecoveryBPMfwkInputGenDocExecutor simulador;

    
    @Before
    public void before(){
        verificador = new VerificadorRecoveryBPMfwkInputGenDocExecutor(mockGENINFInformesManager);
        simulador = new SimuladorRecoveryBPMfwkInputGenDocExecutor(mockConfigManager, mockProcedimientosManager, mockEXTJBPMProcessApi);
        random = new Random();
        
        when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientosManager);
        when(mockProxyFactory.proxy(RecoveryBPMfwkConfigApi.class)).thenReturn(mockConfigManager);
        when(mockProxyFactory.proxy(GENINFInformesApi.class)).thenReturn(mockGENINFInformesManager);
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
        reset(mockProcedimientosManager);
        reset(mockConfigManager);
        reset(mockGENINFInformesManager);
        reset(mockProxyFactory);
        reset(datosProcedimientoManager);
        reset(mockEXTJBPMProcessApi);
    }

    /**
     * Acceso al verificador de interacciones
     * @return
     */
    protected VerificadorRecoveryBPMfwkInputGenDocExecutor verificar() {
       return this.verificador;
    }

    /**
     * Acceso al simulador de interacciones.
     * 
     * @return
     */
    protected SimuladorRecoveryBPMfwkInputGenDocExecutor simular() {
        return this.simulador;
    }
    
}
