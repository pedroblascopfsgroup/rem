package es.capgemini.pfs.batch;

import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.batch.StoppableSimpleJob;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * TODO FO.
 */
public class PFSStoppableSimpleJob extends StoppableSimpleJob {

    //@Autowired
    //private JbpmConfiguration jbpmConfiguration;
    
    @Autowired
    private JBPMProcessManager jbpmProcessManager;

    private static long jobsRunning = 0;

    /**
     * Ejecución del job.
     * @param execution JobExecution
     * @throws JobExecutionException cualquier error
     */
    @Override
    public void execute(JobExecution execution) throws JobExecutionException {
        bpmStop();
        try {
            super.execute(execution);
        } finally {
            bpmStart();
        }
    }

    private void bpmStart() {
        decrementJobsRunning();
        if (noJobsRunning()) {
            //jbpmConfiguration.getJobExecutor().start();
            jbpmProcessManager.startJobExecutor();
        }
    }

    private void bpmStop() {
        //jbpmConfiguration.getJobExecutor().stop();
        jbpmProcessManager.stopJobExecutor();
        incrementJobsRunning();
    }

    /**
     * Incrementa en 1 la cantidad de jobs ejecutandose.
     */
    public static synchronized void incrementJobsRunning() {
        jobsRunning++;
    }

    /**
     * Reduce en 1 la cantidad de jobs ejecutandose.
     */
    public static synchronized void decrementJobsRunning() {
        if (jobsRunning > 0){
        	jobsRunning--;
        }
    }

    /**
     * Setea a 0 la cantidad de jobs ejecutandose.
     * @return boolean
     */
    public static synchronized boolean noJobsRunning() {
        return jobsRunning == 0;
    }

}
