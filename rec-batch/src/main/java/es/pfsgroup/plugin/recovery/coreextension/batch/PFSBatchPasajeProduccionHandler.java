package es.pfsgroup.plugin.recovery.coreextension.batch;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.BatchPasajeProduccionHandler;

/**
 * Handler genérico para pasajes a producción de ficheros mediante el batch.
 * 
 * @author bruno
 * 
 */
public class PFSBatchPasajeProduccionHandler extends BatchPasajeProduccionHandler{
    

    private String jobName;
    private String chainChannel;

    @Override
    public String getJobName() {
        return this.jobName;
    }

    @Override
    public void fireEndEvent() {
        getEventManager().fireEvent(chainChannel, CHAIN_END);
        
    }

    @Override
    public void sendEndChainEvent() {
        getEventManager().fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento END [" + workingCode + "]");
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(chainChannel, workingCode), CHAIN_END);
    }

    public void setJobName(String jobName) {
        this.jobName = jobName;
    }

    public void setChainChannel(String chainChannel) {
        this.chainChannel = chainChannel;
    }
    
    public void setWorkingCode(String workingCode){
        this.workingCode = workingCode;
    }

}
