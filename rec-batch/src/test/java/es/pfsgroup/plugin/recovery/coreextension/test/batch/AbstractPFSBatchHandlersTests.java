package es.pfsgroup.plugin.recovery.coreextension.test.batch;

import static org.mockito.Matchers.any;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.inOrder;

import org.mockito.InOrder;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.BatchLoadConstants;

public class AbstractPFSBatchHandlersTests {

    public AbstractPFSBatchHandlersTests() {
        super();
    }

    protected void assertSendEndChainEvents(EventManager mockEventManager, String chainChannel, String workingCode) {
        InOrder events = inOrder(mockEventManager);
        events.verify(mockEventManager).fireEvent(eq(EventManager.GENERIC_CHANNEL), any(String.class));
        events.verify(mockEventManager).fireEvent(QueueUtils.getQueueNameForEntity(chainChannel, workingCode), BatchLoadConstants.CHAIN_END);
    }

}