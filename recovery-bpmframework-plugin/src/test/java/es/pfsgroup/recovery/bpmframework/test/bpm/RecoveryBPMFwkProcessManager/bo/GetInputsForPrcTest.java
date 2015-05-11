package es.pfsgroup.recovery.bpmframework.test.bpm.RecoveryBPMFwkProcessManager.bo;

import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.verify;
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

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.bpmframework.bpm.RecoveryBPMFwkProcessManager;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

@RunWith(MockitoJUnitRunner.class)
public class GetInputsForPrcTest {

    @InjectMocks
    private RecoveryBPMFwkProcessManager manager;
    
    @Mock
    private RecoveryBPMfwkInput mockInput;
    
    @Mock
    private GenericABMDao mockGenericDao;
    
    @Mock
    private  Filter mockFiltro;
    
    private Long idProcedimiento;
    
    @Before
    public void before(){
        final Random random = new Random();
        
        idProcedimiento = random.nextLong();
        
        List<RecoveryBPMfwkInput> inputs = new ArrayList<RecoveryBPMfwkInput>();
        inputs.add(mockInput);
        
        when(mockGenericDao.createFilter(FilterType.EQUALS, "idProcedimiento", idProcedimiento)).thenReturn(mockFiltro);
        when(mockGenericDao.getList(RecoveryBPMfwkInput.class, mockFiltro)).thenReturn(inputs);
        
    }
    
    @After
    public void after(){
        idProcedimiento = null;
        
        reset(mockGenericDao);
        reset(mockInput);
        reset(mockFiltro);
    }
    
    
    @Test
    public void testGetInputsForPrc(){
        manager.getInputsForPrc(idProcedimiento);
        verify(mockGenericDao).getList(RecoveryBPMfwkInput.class, mockFiltro);
    }
    
    
}
