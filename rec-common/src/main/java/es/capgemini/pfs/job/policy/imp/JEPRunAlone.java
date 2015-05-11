package es.capgemini.pfs.job.policy.imp;

import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.policy.JobExecutionPolicy;

/**
 * @author lgiavedo
 * Politica: Solo se puede ejecutar este job. 
 *
 */
public class JEPRunAlone extends JobExecutionPolicy{

    @Override
    public boolean validatePreRunning() {
        return jobManager.getNumberOfProcessRunning()>0 ? false : true;
    }
    
    @Override
    public boolean validateOnRunning(JobInfo jobInfo) {
        return false;
    }
    
    @Override
    public boolean validatePreLoad() {
        return true;
    }

}
