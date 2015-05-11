package es.pfsgroup.recovery.bpmframework.test.tareas.RecoveryBPMfwkInputsTareasManager;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;
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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.tareas.RecoveryBPMfwkInputsTareasManager;
import es.pfsgroup.recovery.bpmframework.tareas.model.RecoveryBPMfwkInputsTareas;

@RunWith(MockitoJUnitRunner.class)
public class GetInputsByTareaTest {

    @InjectMocks
    private RecoveryBPMfwkInputsTareasManager manager;
    
    @Mock
    private TareaExternaApi mockTareaApi;
    
    @Mock
    private TareaExterna mockTarea;
    
    @Mock
    private GenericABMDao mockGenericDao;
        
    
    @Mock
    private  ApiProxyFactory mockProxyFactory;
    
    @Mock
    private  Filter mockFiltro;
    
    private Long idTarea;
   
    @Mock
    private RecoveryBPMfwkInput mockInput;
    
    
    @Before
    public void before(){
        final Random random = new Random();
        
        idTarea = random.nextLong();
        
        when(mockProxyFactory.proxy(TareaExternaApi.class)).thenReturn(mockTareaApi);        
        when(mockTareaApi.get(idTarea)).thenReturn(mockTarea);
        
        
        List<RecoveryBPMfwkInputsTareas> inputsTareas = new ArrayList<RecoveryBPMfwkInputsTareas>();
        
        RecoveryBPMfwkInputsTareas inputTarea = new RecoveryBPMfwkInputsTareas();
        
        inputTarea.setInput(mockInput);        
        inputsTareas.add(inputTarea);
        
        when(mockGenericDao.createFilter(FilterType.EQUALS, "tarea", mockTarea)).thenReturn(mockFiltro);
        when(mockGenericDao.getList(RecoveryBPMfwkInputsTareas.class, mockFiltro)).thenReturn(inputsTareas);
        
    }
    
    @After
    public void after(){
        idTarea = null;
        
        reset(mockGenericDao);
        reset(mockProxyFactory);
        reset(mockTarea);
        reset(mockTareaApi);
        
    }
    
    
    @Test
    public void testGetInputsByTarea(){
    	List<RecoveryBPMfwkInput> inputs = manager.getInputsByTarea(idTarea);
    	assertEquals(mockInput, inputs.get(0));
    }
    
    
}
