package es.capgemini.devon.batch;

import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import es.capgemini.devon.batch.events.BatchEndedEvent;
import es.capgemini.devon.batch.events.BatchStartedEvent;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.exception.FrameworkException;

/**
 * Implementación por defecto de {@link BatchManager}.
 * Obtiene los "jobs" del contexto de Spring, listando todos los beans que implementen la clase {@link Job}
 * 
 * @author Nicolás Cornaglia
 */
@Service("batchManager")
public class BatchManagerImpl implements BatchManager {

    private final Log logger = LogFactory.getLog(getClass());

    //@Autowired(required = false)
    //private Job[] jobs;
    //private final Map<String, Job> jobsCache = new HashMap<String, Job>();

    @Autowired
    @Qualifier("batch.jobLauncher")
    private JobLauncher jobLauncher;

    @Autowired
    private EventManager eventManager;

    @Autowired
    private BeanFactory beanFactory;

    /**
     * @see es.capgemini.devon.batch.BatchManager#run(java.lang.String, java.util.Map)
     */
    public BatchExitStatus run(String jobName, Map<String, Object> jobParameters) throws FrameworkException {
        JobExecution jobExecution = null;
        Job job = (Job) beanFactory.getBean(jobName);
        String result = null;
        Exception exception = null;
        if (job == null) {
            logger.error("[" + jobName + "] not found.");
            return BatchExitStatus.NOOP;
        } else {
            logger.info("Lanzando job [" + jobName + "] con parámetros [" + jobParameters + "]");
            eventManager.fireEvent(BatchManager.BATCH_CHANNEL, new BatchStartedEvent(jobName));
            try {
                jobExecution = jobLauncher.run(job, BatchUtils.getJobParameters(jobParameters));
                result = jobExecution.getExitStatus().getExitCode();
            } catch (Exception e) {
                exception = e;
                result = BatchExitStatus.FAILED.toString();
            }
            if (exception != null) {
                logger.error("Error en job [" + jobName + "] con parámetros [" + jobParameters + "]", new BatchException(exception));
            } else {
                logger.info("Fin " + result + " de job [" + jobName + "] con parámetros [" + jobParameters + "]");
            }
            eventManager.fireEvent(BatchManager.BATCH_CHANNEL, new BatchEndedEvent(jobName, exception));
        }

        return BatchExitStatus.valueOf(result);
    }

    /**
     * Inyección del {@link JobLauncher} para la ejecución de "jobs" de Spring
     * 
     * @param jobLauncher
     */
    public void setJobLauncher(JobLauncher jobLauncher) {
        this.jobLauncher = jobLauncher;
    }

    /**
     * Inyección del {@link EventManager} para gestión de eventos
     * 
     * @param eventManager 
     */
    public void setEventManager(EventManager eventManager) {
        this.eventManager = eventManager;
    }

    public void setBeanFactory(BeanFactory beanFactory) throws BeansException {
        this.beanFactory = beanFactory;
    }

}
