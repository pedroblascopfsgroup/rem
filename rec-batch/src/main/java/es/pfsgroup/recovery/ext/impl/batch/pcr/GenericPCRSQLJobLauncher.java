package es.pfsgroup.recovery.ext.impl.batch.pcr;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.BatchPasajeProduccionHandler;
import es.capgemini.pfs.batch.load.pcr.BatchPCRConstantes;

public class GenericPCRSQLJobLauncher extends BatchPasajeProduccionHandler implements BatchPCRConstantes {

    /**
     * Se hace un autowired del eventManager.
     */
    @Autowired
    private EventManager eventManager;

    private String jobName;

    /**
     * {@inheritDoc}
     */
    @Override
    public void fireEndEvent() {
        getEventManager().fireEvent(PCR_CHAIN_CHANNEL, CHAIN_END);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void sendEndChainEvent() {
        eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento END [" + workingCode + "]");
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(PCR_CHAIN_CHANNEL, workingCode), CHAIN_END);
    }

    public String getJobName() {
        return jobName;
    }

    public void setJobName(String jobName) {
        this.jobName = jobName;
    }

}
