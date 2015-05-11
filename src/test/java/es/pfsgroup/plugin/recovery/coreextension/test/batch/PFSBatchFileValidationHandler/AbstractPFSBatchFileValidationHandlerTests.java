package es.pfsgroup.plugin.recovery.coreextension.test.batch.PFSBatchFileValidationHandler;

import static org.junit.Assert.assertEquals;

import java.util.Date;
import java.util.Map;
import java.util.Random;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.capgemini.devon.events.EventManager;
import es.capgemini.pfs.batch.load.BatchLoadConstants;
import es.pfsgroup.plugin.recovery.coreextension.batch.PFSBatchFileValidationHandler;
import es.pfsgroup.plugin.recovery.coreextension.test.batch.AbstractPFSBatchHandlersTests;

/**
 * Clase base para los tests de {@link PFSBatchFileValidationHandler}
 * 
 * @author bruno
 * 
 */
public abstract class AbstractPFSBatchFileValidationHandlerTests extends AbstractPFSBatchHandlersTests {

    @InjectMocks
    protected PFSBatchFileValidationHandler handler;

    @Mock
    protected EventManager mockEventManager;

    protected String fileName;
    protected String workingCode;
    protected Date extractTime;
    protected Random random;

    protected String jobName;

    protected String chainChannel;

    @Before
    public final void before() {
        random = new Random();
        
        fileName = RandomStringUtils.random(100);
        workingCode = RandomStringUtils.random(5);
        extractTime = new Date(random.nextLong());
        jobName = RandomStringUtils.random(100);
        chainChannel = RandomStringUtils.random(100);

        handler.setJobName(jobName);
        handler.setChainChannel(chainChannel);
        handler.setEventManager(mockEventManager);
        childBefore();
    }

    @After
    public final void after() {
        childAfter();
        fileName = null;
        workingCode = null;
        extractTime = null;
        random = null;
        jobName = null;
        chainChannel = null;
    }

    protected abstract void childBefore();

    protected abstract void childAfter();

    protected void basicAsserts(Map<String, Object> result) {
        assertEquals("No coincide el jobname devuelto al seteado en el handler", jobName, handler.getJobName());
        
        assertEquals("El filename no coincide", fileName, result.get(BatchLoadConstants.FILENAME));
        assertEquals("El código de entidad no coincide", workingCode, result.get(BatchLoadConstants.ENTIDAD));
        assertEquals("La fecha de extracción no coincide", extractTime, result.get(BatchLoadConstants.EXTRACTTIME));
    }
}
