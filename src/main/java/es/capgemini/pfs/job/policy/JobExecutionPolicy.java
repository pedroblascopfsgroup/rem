package es.capgemini.pfs.job.policy;

import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobInfo;

/**
 * @author lgiavedo
 *
 */

public abstract class JobExecutionPolicy {
	
	protected JobInfo jobInfo;
    protected JobController jobManager;

    
    public JobExecutionPolicy() {
       
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
    }

}
