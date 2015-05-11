package es.capgemini.pfs.job;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * @author lgiavedo
 *
 */
@Component("JobExecutor")
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class JobExecutor extends Thread {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private JobController jobManager;
    @Autowired
    private JBPMProcessManager jbpmUtils;
    
    private JobInfo job;

    public JobExecutor(JobInfo job) {
        this.job = job;
    }

    public JobExecutor() {
    }

    @Override
    public void run() {
        logger.info(job+ ": START");
        job.setStartTime(new Date());
        try {
            job.getJobRunner().run();
            /**
             * TODO: Mejorar para evitar problemas de concurrencia
             * Esperamos x segs para dar tiempo a que se genere el evento en caso de ser un proceso de carga
             */
            sleep(jobManager.getWaitAfterExecution());
        } catch (Exception e) {
            logger.error("Error en la ejecución del Job [" + job + "] -->" + e.getStackTrace(), e);
        } finally {
            try {
                job.setFinishTime(new Date());
                logger.info(job+ ": END [" + (job.getTotalExecutionTime()/1000) + " segs]");
                //Remove for JobManager
                if(!jobManager.getJobsRunning().remove(job)){
                    logger.error("Error al eliminar el Job [" + job + "]");
                }
                //Clear JobRunner
                job.setJobRunner(null);
                //Put in the history
                jobManager.getJobsHistory().add(job);
                //Veririficamos si no hay nada en ejecución o esperando volvemos a inicar JBPM
                if (jobManager.getNumberOfProcessRunning() + jobManager.getNumberOfProcessWaiting() == 0) jbpmUtils.startJobExecutor();
            } catch (Exception e) {
                logger.error("Error al finalizar el Job [" + job + "] -->" + e.getStackTrace(), e);
            }
        }
    }

    /**
     * @param job the job to set
     */
    public void setJob(JobInfo job) {
        this.job = job;
    }

}
