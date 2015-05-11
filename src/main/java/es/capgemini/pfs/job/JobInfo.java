package es.capgemini.pfs.job;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import es.capgemini.pfs.job.policy.JobExecutionPolicy;

/**
 * @author lgiavedo
 *
 */
public/*abstract*/class JobInfo implements Comparable<JobInfo>, Serializable {

    private static final long serialVersionUID = 1L;

    public static final int PRIORIDAD_ALTA = 1;
    public static final int PRIORIDAD_MEDIA = 5;
    public static final int PRIORIDAD_BAJA = 10;

    private Date createdTime = null;
    private Date startTime = null;
    private Date finishTime = null;
    private String jobName;
    private String jobEntity;
    private int priority = PRIORIDAD_MEDIA;
    private JobRunner jobRunner;
    private List<JobExecutionPolicy> executionPolicies = new ArrayList<JobExecutionPolicy>();
    private final String ID = "T" + Thread.currentThread().getId() + "-D" + System.currentTimeMillis() + "-O" + this.hashCode();

    public JobInfo(String name, String entity, JobRunner jobRunner) {
        super();
        this.jobName = name;
        this.jobEntity = entity;
        this.jobRunner = jobRunner;
        setCreatedTime(new Date());
    }

    public JobInfo() {
    }

    /**
     * @return the name
     */
    public String getJobName() {
        return jobName;
    }

    /**
     * @param name the name to set
     */
    public void setJobName(String name) {
        this.jobName = name;
    }

    /**
     * @return the createdTime
     */
    public Date getCreatedTime() {
        return createdTime;
    }

    /**
     * @param createdTime the createdTime to set
     */
    public void setCreatedTime(Date createdTime) {
        this.createdTime = createdTime;
    }

    /**
     * @return the startTime
     */
    public Date getStartTime() {
        return startTime;
    }

    /**
     * @param startTime the startTime to set
     */
    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    /**
     * @return the finishTime
     */
    public Date getFinishTime() {
        return finishTime;
    }

    /**
     * @param finishTime the finishTime to set
     */
    public void setFinishTime(Date finishTime) {
        this.finishTime = finishTime;
    }
    
    public long getTotalExecutionTime(){
        if(startTime!=null && finishTime !=null)
            return finishTime.getTime() - startTime.getTime();
        return 0;
    }

    /**
     * @param priority the priority to set
     */
    public void setPriority(int priority) {
        this.priority = priority;
    }

    /**
     * @return the priority
     */
    public int getPriority() {
        return priority;
    }

    /**
     * @return the jobEntity
     */
    public String getJobEntity() {
        return jobEntity;
    }

    /**
     * @param jobEntity the jobEntity to set
     */
    public void setJobEntity(String jobEntity) {
        this.jobEntity = jobEntity;
    }

    /**
     * @return the jobRunner
     */
    public JobRunner getJobRunner() {
        return jobRunner;
    }

    /**
     * @param jobRunner the jobRunner to set
     */
    public void setJobRunner(JobRunner jobRunner) {
        this.jobRunner = jobRunner;
    }

    /**
     * @param executionPolicies the executionPolicies to set
     */
    public void addExecutionPolicies(JobExecutionPolicy ep) {
        ep.setJobInfo(this);
        executionPolicies.add(ep);
    }

    public boolean validatePreRunning() {
        for (Iterator<JobExecutionPolicy> iterator = executionPolicies.iterator(); iterator.hasNext();) {
            if (!((JobExecutionPolicy) iterator.next()).validatePreRunning()) return false;
        }
        return true;
    }

    public boolean validateOnRunning(JobInfo newJobInfo) {
        for (Iterator<JobExecutionPolicy> iterator = executionPolicies.iterator(); iterator.hasNext();) {
            if (!((JobExecutionPolicy) iterator.next()).validateOnRunning(newJobInfo)) return false;
        }
        return true;
    }

    public boolean validatePreLoad() {
        for (Iterator<JobExecutionPolicy> iterator = executionPolicies.iterator(); iterator.hasNext();) {
            if (!((JobExecutionPolicy) iterator.next()).validatePreLoad()) return false;
        }
        return true;
    }

    @Override
    public int compareTo(JobInfo job) {
        if (this.ID.equals(job.ID)) return 0;
        if (this.getPriority() == job.getPriority()) {
            // Tienen la misma prioridad
            // Gana el que esta esperando hace mas tiempo
            return (int) (this.getCreatedTime().getTime() - job.getCreatedTime().getTime());
        } else {
            /**
             * Las prioridades son distintas
             * Gana el de mayor prioridad (Menor numero)
            */
            return this.getPriority() - job.getPriority();
        }
    }

    /* (non-Javadoc)
     * @see java.lang.Object#equals(java.lang.Object)
     */
    @Override
    public boolean equals(Object obj) {
        return ID.equals(((JobInfo) obj).ID) ? true : false;
    }

    /* (non-Javadoc)
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return jobName + "["+ jobEntity +"]";
    }

}
