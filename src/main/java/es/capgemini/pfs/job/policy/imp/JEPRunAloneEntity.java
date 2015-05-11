package es.capgemini.pfs.job.policy.imp;

import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.policy.JobExecutionPolicy;

/**
 * @author lgiavedo
 *
 */
public class JEPRunAloneEntity extends JobExecutionPolicy{

    @Override
    public boolean validatePreRunning() {
        return false;
    }
    
    @Override
    public boolean validateOnRunning(JobInfo newJob) {
        return  false;
    }
    
    @Override
    public boolean validatePreLoad() {
        return true;
    }


}
