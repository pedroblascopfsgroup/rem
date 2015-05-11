package es.pfsgroup.recovery.bpmframework.test.tareas.RecoveryBPMfwkInputsTareasManager;

import static org.mockito.Matchers.any;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.tareas.RecoveryBPMfwkInputsTareasManager;
import es.pfsgroup.recovery.bpmframework.tareas.model.RecoveryBPMfwkInputsTareas;

@RunWith(MockitoJUnitRunner.class)
public class SaveTest {

    @InjectMocks
    private RecoveryBPMfwkInputsTareasManager manager;
    
    @Mock
    private RecoveryBPMfwkInput mockInput;
    
    @Mock
    private RecoveryBPMfwkInputApi mockInputApi;
    
    @Mock
    private TareaExternaApi mockTareaApi;
    
    @Mock
    private TareaExterna mockTarea;
    
    @Mock
    private GenericABMDao mockGenericDao;
    
    @Mock
    private  ApiProxyFactory mockProxyFactory;
    
    private Long idInput;
    private Long idTarea;
    
    @Before
    public void before(){
        final Random random = new Random();
        
        idInput = random.nextLong();
        idTarea = random.nextLong();
        
        when(mockProxyFactory.proxy(RecoveryBPMfwkInputApi.class)).thenReturn(mockInputApi);
        when(mockProxyFactory.proxy(TareaExternaApi.class)).thenReturn(mockTareaApi);
        
        when(mockInputApi.get(idInput)).thenReturn(mockInput);
        when(mockTareaApi.get(idTarea)).thenReturn(mockTarea);
        
    }
    
    @After
    public void after(){
        idInput = null;
        idTarea = null;
        
        reset(mockGenericDao);
        reset(mockInput);
        reset(mockInputApi);
        reset(mockProxyFactory);
        reset(mockTarea);
        reset(mockTareaApi);
        
    }
    
    
    @Test
    public void testSave(){
        manager.save(idInput, idTarea);
        verify(mockGenericDao).save(eq(RecoveryBPMfwkInputsTareas.class), any(RecoveryBPMfwkInputsTareas.class));
    }
    
    
}
