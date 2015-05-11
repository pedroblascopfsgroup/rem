package es.pfsgroup.procedimientos.test.PROBaseActionHandler;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.jbpm.graph.exe.ExecutionContext;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.ArgumentMatcher;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.procedimientos.PROBPMContants;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;

@RunWith(MockitoJUnitRunner.class)
public class LanzaNuevoBPMHijoTest {

    @InjectMocks
    private PROBaseActionHandler handler;

    @Mock
    private ExecutionContext mockExecutionContext;

    @Mock
    private EXTTareaProcedimiento mockTareaProcedimiento;

    @Mock
    private ApiProxyFactory mockProxyFactory;

    @Mock
    private Procedimiento mockProcedimiento;

    @Mock
    private Procedimiento mockProcedimientoHijo;

    @Mock
    private JBPMProcessApi mockJbpmProcessApi;

    @Mock
    private Executor mockExecutor;

    @Mock
    private TipoProcedimiento mockTipoProcedimientoHijo;
    
    @Mock
    private GenericABMDao mockGenericDao;

    private PROBaseActionHandler spy;

    private Long idProcedimientoHijo;

    private Long idToken;

    private List<Persona> listaDemandados;

    @Before
    public void before() {
        Random random = new Random();

        spy = spy(handler);
        idProcedimientoHijo = random.nextLong();
        idToken = random.nextLong();

        doReturn(mockTareaProcedimiento).when(spy).getTareaProcedimiento(mockExecutionContext);
        doReturn(mockProcedimiento).when(spy).getProcedimiento(mockExecutionContext);
        when(mockTareaProcedimiento.getTipoProcedimientoBPMHijo()).thenReturn(mockTipoProcedimientoHijo);

        when(mockProxyFactory.proxy(JBPMProcessApi.class)).thenReturn(mockJbpmProcessApi);
        when(mockJbpmProcessApi.creaProcedimientoHijo(mockTipoProcedimientoHijo, mockProcedimiento)).thenReturn(mockProcedimientoHijo);
        when(mockProcedimientoHijo.getId()).thenReturn(idProcedimientoHijo);

        doReturn(idToken).when(spy).getTokenId(mockExecutionContext);

        listaDemandados = new ArrayList<Persona>();
        listaDemandados.add(new Persona());
        listaDemandados.add(new Persona());
        listaDemandados.add(new Persona());
        listaDemandados.add(new Persona());
        listaDemandados.add(new Persona());
    }

    @After
    public void after() {
        spy = null;
        idProcedimientoHijo = null;
        idToken = null;
        listaDemandados = null;

        reset(mockExecutionContext);
        reset(mockTareaProcedimiento);
        reset(mockProcedimiento);
        reset(mockProxyFactory);
        reset(mockJbpmProcessApi);
        reset(mockTipoProcedimientoHijo);
        reset(mockProcedimientoHijo);
        reset(mockExecutor);
        reset(mockGenericDao);
    }

    @Test
    public void testCreaBpmHijo_sinBucle() {

        when(mockTareaProcedimiento.getExpresionBucleBPM()).thenReturn(null);

        spy.lanzaNuevoBpmHijo(mockExecutionContext);

        verificaCreacionNuevoProcedimiento(1);

    }

    @Test
    public void testCreaBpmHijo_conBucle() {
        when(mockTareaProcedimiento.getExpresionBucleBPM()).thenReturn("personasAfectadas");
        when(mockProcedimiento.getPersonasAfectadas()).thenReturn(listaDemandados);

        spy.lanzaNuevoBpmHijo(mockExecutionContext);

        verificaCreacionNuevoProcedimiento(listaDemandados.size());
        
        verify(mockProcedimientoHijo, times(listaDemandados.size())).setPersonasAfectadas(argThat(new ArgumentMatcher<List>() {

            @Override
            public boolean matches(Object argument) {
                if (!(argument instanceof List)) return false;
                List list = (List) argument;
                return list.size() == 1;
            }
        }));
    }

    private void verificaCreacionNuevoProcedimiento(int count) {
        verify(mockJbpmProcessApi, times(count)).creaProcedimientoHijo(mockTipoProcedimientoHijo, mockProcedimiento);
        verify(mockExecutor, times(count)).execute(ComunBusinessOperation.BO_JBPM_MGR_LANZAR_BPM_ASOC_PROC, idProcedimientoHijo, idToken);
        verify(spy, times(count)).setVariable(PROBPMContants.PROCEDIMIENTO_HIJO, idProcedimientoHijo, mockExecutionContext);

        verifyNoMoreInteractions(mockExecutor);
        verifyNoMoreInteractions(mockJbpmProcessApi);
    }
}
