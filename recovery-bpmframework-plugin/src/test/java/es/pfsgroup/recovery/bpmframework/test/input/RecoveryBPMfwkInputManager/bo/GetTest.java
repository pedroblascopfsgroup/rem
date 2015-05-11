package es.pfsgroup.recovery.bpmframework.test.input.RecoveryBPMfwkInputManager.bo;

import static org.junit.Assert.assertEquals;
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

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputManager;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

@RunWith(MockitoJUnitRunner.class)
public class GetTest {

    @InjectMocks
    private RecoveryBPMfwkInputManager manager;
    
    @Mock
    private RecoveryBPMfwkInput mockInput;
    
    @Mock
    private GenericABMDao mockGenericDao;
    
    @Mock
    private  Filter mockFiltro;
    
    private Long idInput;
    
    @Before
    public void before(){
        final Random random = new Random();
        
        idInput = random.nextLong();
                        
        when(mockGenericDao.createFilter(FilterType.EQUALS, "id", idInput)).thenReturn(mockFiltro);
        when(mockGenericDao.get(RecoveryBPMfwkInput.class, mockFiltro)).thenReturn(mockInput);
        
    }
    
    @After
    public void after(){
        idInput = null;
        
        reset(mockGenericDao);
        reset(mockInput);
        reset(mockFiltro);
    }
    
    
    @Test
    public void testGet(){
    	RecoveryBPMfwkInput inputRet = manager.get(idInput);
        verify(mockGenericDao).get(RecoveryBPMfwkInput.class, mockFiltro);
        
        assertEquals(mockInput, inputRet);
    }
    
    
}
