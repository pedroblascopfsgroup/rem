package es.pfsgroup.recovery.bpmframework.test.bpm.RecoveryBPMFwkProcessManager.bo;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Random;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.bpm.ProcessManager;
import es.pfsgroup.recovery.bpmframework.bpm.RecoveryBPMFwkInputJbpmCallback;
import es.pfsgroup.recovery.bpmframework.bpm.RecoveryBPMFwkProcessManager;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

@RunWith(MockitoJUnitRunner.class)
public class SignalProcessTest {

    @InjectMocks
    private RecoveryBPMFwkProcessManager manager;
    
    @Mock
    private RecoveryBPMfwkInput mockInput;
    
    @Mock
    private ProcessManager mockProcessManager;
    
    private Long idProcess;
    private String transitionName;

    private Long idMock;
    
    @Before
    public void before(){
        final Random random = new Random();
        
        idProcess = random.nextLong();
        transitionName = RandomStringUtils.random(10);
        idMock = random.nextLong();
        
        when(mockInput.getId()).thenReturn(idMock);
    }
    
    @After
    public void after(){
        idProcess = null;
        transitionName = null;
        idMock = null;
        
        reset(mockProcessManager);
        reset(mockInput);
    }
    
    
    @Test
    public void testSignaProcess(){
        manager.signalProcess(idProcess, transitionName, mockInput);
        
        final ArgumentCaptor<RecoveryBPMFwkInputJbpmCallback> argumentCaptor  = ArgumentCaptor.forClass(RecoveryBPMFwkInputJbpmCallback.class);
        
        verify(mockProcessManager).execute(argumentCaptor.capture());
        
        final RecoveryBPMFwkInputJbpmCallback argument = argumentCaptor.getValue();
        
        assertEquals(idProcess, argument.getIdProcess());
        
        assertEquals(transitionName, argument.getTransitionName());
        
        assertEquals(mockInput, argument.getInput());
    }
    
    
}
