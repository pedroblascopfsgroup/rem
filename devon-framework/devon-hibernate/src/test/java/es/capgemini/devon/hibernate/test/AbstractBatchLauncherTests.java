//package es.capgemini.devon.hibernate.test;
//
//import java.util.Map;
//
//import org.springframework.batch.core.Job;
//import org.springframework.batch.core.JobExecution;
//import org.springframework.batch.core.JobParameters;
//import org.springframework.batch.core.launch.JobLauncher;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.test.context.ContextConfiguration;
//
//import es.capgemini.devon.batch.BatchUtils;
//
///**
// * @author Nicol�s Cornaglia
// */
//@ContextConfiguration(locations = { "classpath:ac-devon-batch-test.xml" })
//public abstract class AbstractBatchLauncherTests extends AbstractLauncherTests {
//
//    @Autowired
//    private JobLauncher launcher;
//
//    @Autowired
//    private Job job;
//
//    private JobParameters jobParameters = new JobParameters();
//    protected JobExecution jobExecution;
//
//    /**
//     * Lanza un job con los par�metros establecidos en setJobParameters()
//     * 
//     * @throws Exception
//     * @return JobExecution
//     * 
//     */
//    public JobExecution launchJob() throws Exception {
//        return launchJob(this.jobParameters);
//    }
//
//    /**
//     * Lanza un job con los par�metros establecidos en jobParameters
//     * 
//     * @param jobParameters JobParameters
//     * @throws Exception
//     * @return JobExecution
//     */
//    public JobExecution launchJob(JobParameters jobParameters) throws Exception {
//        return launcher.run(job, jobParameters);
//    }
//
//    /**
//     * Lanza un job con los par�metros establecidos en jobParameters
//     * 
//     * @param jobParameters Map<String, Object>
//     * @return
//     * @throws Exception
//     */
//    public JobExecution launchJob(Map<String, Object> jobParameters) throws Exception {
//        return launcher.run(job, BatchUtils.getJobParameters(jobParameters));
//    }
//
//    public void setLauncher(JobLauncher bootstrap) {
//        this.launcher = bootstrap;
//    }
//
//    public void setJob(Job job) {
//        this.job = job;
//    }
//
//    public Job getJob() {
//        return job;
//    }
//
//    protected String getJobName() {
//        return job.getName();
//    }
//
//    public void setJobParameters(JobParameters jobParameters) {
//        this.jobParameters = jobParameters;
//    }
//
//}
