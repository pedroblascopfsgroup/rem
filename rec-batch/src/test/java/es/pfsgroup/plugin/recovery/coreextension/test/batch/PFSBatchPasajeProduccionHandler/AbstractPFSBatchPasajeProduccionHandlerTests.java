package es.pfsgroup.plugin.recovery.coreextension.test.batch.PFSBatchPasajeProduccionHandler;

import static org.mockito.Mockito.*;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.capgemini.devon.events.EventManager;
import es.pfsgroup.plugin.recovery.coreextension.batch.PFSBatchPasajeProduccionHandler;
import es.pfsgroup.plugin.recovery.coreextension.test.batch.AbstractPFSBatchHandlersTests;

public abstract class AbstractPFSBatchPasajeProduccionHandlerTests extends AbstractPFSBatchHandlersTests{

    @InjectMocks
    protected PFSBatchPasajeProduccionHandler handler;
    
    @Mock
    protected EventManager mockEventManager;
    
    protected String chainChannel;
    
    protected String workingCode;

    private String jobName;
    
    @Before
    public void before(){
        chainChannel = RandomStringUtils.random(100);
        workingCode = RandomStringUtils.random(40);
        jobName = RandomStringUtils.random(100);
        
        handler.setChainChannel(chainChannel);
        handler.setWorkingCode(workingCode);
        handler.setJobName(jobName);
        childBefore();
    }
    
    @After
    public void after(){
        childAfter();
        chainChannel = null;
        workingCode = null;
        jobName = null;
        
        reset(mockEventManager);
    }
    
    public abstract void childBefore();
    
    public abstract void childAfter();
}
