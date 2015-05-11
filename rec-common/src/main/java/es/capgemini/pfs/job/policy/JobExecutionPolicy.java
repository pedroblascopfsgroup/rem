package es.capgemini.pfs.job.policy;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobInfo;

/**
 * @author lgiavedo
 *
 */

public abstract class JobExecutionPolicy {

    protected JobInfo jobInfo;
    @Autowired
    protected JobController jobManager;

    private final Log logger = LogFactory.getLog(getClass());

    public JobExecutionPolicy() {
        try {
            if (jobManager == null) {
                if (ApplicationContextUtil.getApplicationContext() != null)
                    jobManager = (JobController) ApplicationContextUtil.getApplicationContext().getBean(JobController.BEAN_KEY);
                else
                    logger.warn("No se ha seteado el appContectUtil! ApplicationContextUtil.getApplicationContext() = null ");
            }
        } catch (Exception e) {
            logger.error(e);
        }
    }

    /**
     * Validación de las reglas para poder entrar en la cola de espera
     * En caso de no ser validado correctamente se descarta el job
     * 
     * @return boolean
     */
    public boolean validatePreLoad(){
        return true;
    }

    /**
     * Validación de las reglas para poder entrar en ejecución
     * @return boolean
     */
    public boolean validatePreRunning(){
        return true;
    }

    /**
     * Validación de las reglas una vez que se esta ejecutando y alguien mas quiere entrar
     * @return boolean
     */
    public boolean validateOnRunning(JobInfo newJob){
        return true;
    }

    /**
     * @param jobInfo the jobInfo to set
     */
    public void setJobInfo(JobInfo jobInfo) {
        this.jobInfo = jobInfo;
    }

}
