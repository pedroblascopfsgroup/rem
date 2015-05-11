package es.capgemini.pfs.job;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jmx.export.annotation.ManagedAttribute;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.stereotype.Component;


/**
 * @author lgiavedo
 *
 */
@Component
@ManagedResource("devon:type=Jobs")
public class JobConsolePlugin{
    
    @Autowired
    private JobController jobManager;
    
    @ManagedAttribute
    public String getJobsWaitingNamesList() {
        return jobManager.getJobsWaiting().toString();
    }
    
    @ManagedAttribute
    public String getJobsRunningNamesList() {
        return jobManager.getJobsRunning().toString();
    }
    
    @ManagedAttribute
    public String getJobsHistoryNamesList() {
        return jobManager.getJobsHistory().toString();
    }
    
   /**
     * @return the maxProcesRunning
     */
    @ManagedAttribute
    public long getMaxProcesRunning() {
        return jobManager.getMaxProcessRunning();
    }

    /**
     * @param maxProcesRunning the maxProcesRunning to set
     */
    @ManagedAttribute
    public void setMaxProcesRunning(long maxProcesRunning) {
        jobManager.setMaxProcessRunning(maxProcesRunning);
    }
    
    @ManagedOperation
    public void stop() {
        jobManager.setRun(false);
    }
    
    @ManagedOperation
    public void start() {
        jobManager.setRun(true);
    }


}
