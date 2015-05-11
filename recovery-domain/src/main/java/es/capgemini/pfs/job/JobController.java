package es.capgemini.pfs.job;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.pfs.job.policy.JobExecutionPolicy;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * @author lgiavedo
 *
 */
public class JobController extends Thread {

    public static final String BEAN_KEY = "jobController";

    private List<JobInfo> jobsWaiting;
    private List<JobInfo> jobsRunning;
    private List<JobInfo> jobsHistory;

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ApplicationContext context;
    /*@Autowired(required=false)
    private JBPMProcessManager jbpmUtils;*/

    //Numero maximo de procesos ejecutandose de forma simultanea
    private long maxProcessRunning = 3;
    //Cada cuanto tiempo (ms) se verifica si hay nuevos jobs
    private long sleepTime = 5000;
    //Cuanto tiempo se espera (una vez que ha finalizado el job) para liberarlo
    private long waitAfterExecution = 5000;

    private boolean run = true;

    public JobController() {
        setName(toString());
        //Create a synchronized map
        jobsWaiting = Collections.synchronizedList(new ArrayList<JobInfo>());
        jobsRunning = Collections.synchronizedList(new ArrayList<JobInfo>());
        jobsHistory = Collections.synchronizedList(new ArrayList<JobInfo>());

        this.start();
    }

    public synchronized boolean addJob(JobInfo jobI) {
        //Validamos el Job antes de ser cargado
        if (!jobI.validatePreLoad()) {
            //El job no ha sido validado correctamente
            logger.info("Rejected job: " + jobI);
            return false;
        }
        logger.info("Add job: " + jobI);
        jobsWaiting.add(jobI);
        return true;
    }

    public synchronized boolean addJob(String jobName, String jobEntity, JobRunner jRunner) {
        return addJob(jobName, jobEntity, jRunner, null);
    }

    public synchronized boolean addJob(String jobName, String jobEntity, JobRunner jRunner, JobExecutionPolicy[] policies) {

        JobInfo jobInfo = new JobInfo(jobName, jobEntity, jRunner);
        if (policies != null) for (JobExecutionPolicy jobExecutionPolicy : policies) {
            jobInfo.addExecutionPolicies(jobExecutionPolicy);
        }

        return addJob(jobInfo);
    }

    @Override
    public void run() {
        while (true) {
            try {
                //Sleep
                sleep(sleepTime);
                //Controlamos que este en modo run
                if (!run) continue;
                //Sort
                Object[] jobInfos;
                synchronized (jobsWaiting) {
                    Collections.sort(jobsWaiting);
                    jobInfos = jobsWaiting.toArray();
                }

                for (int i = 0; i < jobInfos.length; i++) {
                    JobInfo jobInfo = (JobInfo) jobInfos[i];
                    //Exec the jobs
                    //verificamos que no se ha superado el limite
                    if (jobsRunning.size() >= maxProcessRunning) {
                        break;
                    }
                    //Check pre rules
                    if (jobInfo.validatePreRunning()) {
                        //Check post rules
                        if (validateOnRunning(jobInfo)) {
                            //Si hay algun job en ejecución intento pararlo
                            ((JBPMProcessManager)ApplicationContextUtil.getBean(JBPMProcessManager.BEAN_KEY)).stopJobExecutor();
                            //Remove for waiting
                            jobsWaiting.remove(jobInfo);
                            //Put in running
                            jobsRunning.add(jobInfo);
                            //Starting thread
                            getNewJobExecutor(jobInfo).start();
                        }
                    }
                }
            } catch (Exception e) {
                logger.error(e);
            }
        }
    }

    private JobExecutor getNewJobExecutor(JobInfo jobInfo) {
        JobExecutor je = (JobExecutor) context.getBean("JobExecutor");
        je.setJob(jobInfo);
        return je;
    }

    /**
     * @return the jobs
     */
    protected final List<JobInfo> getJobsWaiting() {
        return jobsWaiting;
    }

    /**
     * @return the jobsRunning
     */
    protected final List<JobInfo> getJobsRunning() {
        return jobsRunning;
    }

    public final List<JobInfo> getJobsWaitingEntity(String entity) {
        Object[] jobInfos;
        List<JobInfo> result = new ArrayList<JobInfo>();
        synchronized (jobsWaiting) {
            jobInfos = jobsWaiting.toArray();
        }
        for (int i = 0; i < jobInfos.length; i++) {
            if (entity.equals(((JobInfo)jobInfos[i]).getJobEntity())) 
                result.add((JobInfo) jobInfos[i]);
        }
        return result;
    }

    public String getAction() {
        return null;
    }

    /**
     * @return the jobsHistory
     */
    protected final List<JobInfo> getJobsHistory() {
        return jobsHistory;
    }

    /**
     * @return the sleepTime
     */
    public long getSleepTime() {
        return sleepTime;
    }

    /**
     * @param sleepTime the sleepTime to set
     */
    public void setSleepTime(long sleepTime) {
        this.sleepTime = sleepTime;
    }

    /**
    * @return the waitAfterExecution
    */
    public long getWaitAfterExecution() {
        return waitAfterExecution;
    }

    /**
     * @param waitAfterExecution the waitAfterExecution to set
     */
    public void setWaitAfterExecution(long waitAfterExecution) {
        this.waitAfterExecution = waitAfterExecution;
    }

    /**
     * @return the maxProcessRunning
     */
    public long getMaxProcessRunning() {
        return maxProcessRunning;
    }

    /**
     * @param maxProcessRunning the maxProcessRunning to set
     */
    public void setMaxProcessRunning(long maxProcessRunning) {
        this.maxProcessRunning = maxProcessRunning;
    }

    public synchronized int getNumberOfProcessRunning() {
        return jobsRunning.size();
    }

    public synchronized int getNumberOfProcessWaiting() {
        return jobsWaiting.size();
    }

    public synchronized int getNumberOfProcessHistory() {
        return jobsHistory.size();
    }

    public int getNumberOfProcessRunningEntity(String entity) {
        int reslt = 0;
        Object[] jobInfos;
        synchronized (jobsRunning) {
            jobInfos = jobsRunning.toArray();
        }
        for (int i = 0; i < jobInfos.length; i++) {
            if (entity.equals(((JobInfo) jobInfos[i]).getJobEntity())) reslt++;
        }
        return reslt;
    }

    /**
     * Validación de las reglas.
     * Los jobRunners que estan en ejecucción aceptan al nuevo?
     * 
     * @return boolean
     */
    private boolean validateOnRunning(JobInfo newJobInfo) {
        Object[] jobInfos;
        synchronized (jobsRunning) {
            jobInfos = jobsRunning.toArray();
        }
        for (int i = 0; i < jobInfos.length; i++) {
            if (!((JobInfo) jobInfos[i]).validateOnRunning(newJobInfo)) return false;
        }
        return true;
    }

    /**
     * @return the run
     */
    public boolean isRun() {
        return run;
    }

    /**
     * @param run the run to set
     */
    public void setRun(boolean run) {
        this.run = run;
    }

    /* (non-Javadoc)
     * @see java.lang.Thread#toString()
     */
    @Override
    public String toString() {
        return "JobManager(Control de turnos)";
    }

}
