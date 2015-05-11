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
        return jobManager.getNumberOfProcessRunningEntity(jobInfo.getJobEntity())>0 ? false : true;
    }
    
    @Override
    public boolean validateOnRunning(JobInfo newJob) {
        return  jobInfo.getJobEntity().equals(newJob.getJobEntity())? false : true;
    }
    
    @Override
    public boolean validatePreLoad() {
        return true;
    }


}
