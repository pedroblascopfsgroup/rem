package es.capgemini.devon.batch;

import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.springframework.batch.core.BatchStatus;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.JobExecutionException;
import org.springframework.batch.core.JobExecutionListener;
import org.springframework.batch.core.JobInstance;
import org.springframework.batch.core.JobInterruptedException;
import org.springframework.batch.core.StartLimitExceededException;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.UnexpectedJobExecutionException;
import org.springframework.batch.core.job.AbstractJob;
import org.springframework.batch.core.job.SimpleJob;
import org.springframework.batch.core.listener.CompositeExecutionJobListener;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

/**
 * Implementación de {@link Job} para detener el {@link Job} cuando un {@link Step} devuelve "terminateOnly=true".
 * Es una copia de {@link SimpleJob} con el agregado de las líneas:
 * <pre>
 * if (currentStepExecution.isTerminateOnly()) {
 *     break;
 * } 
 * </pre>
 * 
 * @author Nicolás Cornaglia
 */
public class StoppableSimpleJob extends AbstractJob {

    private JobRepository jobRepository;

    private CompositeExecutionJobListener listener = new CompositeExecutionJobListener();

    private PlatformTransactionManager transactionManager;

    private boolean transactional = false;

    /**
     * Public setter for injecting {@link JobExecutionListener}s. They will all
     * be given the listener callbacks at the appropriate point in the job.
     * 
     * @param listeners the listeners to set.
     */
    public void setJobExecutionListeners(JobExecutionListener[] listeners) {
        for (int i = 0; i < listeners.length; i++) {
            this.listener.register(listeners[i]);
        }
    }

    /**
     * Register a single listener for the {@link JobExecutionListener}
     * callbacks.
     * 
     * @param listener a {@link JobExecutionListener}
     */
    public void registerJobExecutionListener(JobExecutionListener listener) {
        this.listener.register(listener);
    }

    /**
     * Run the specified job by looping through the steps and delegating to the
     * {@link Step}.
     * 
     * @see org.springframework.batch.core.Job#execute(org.springframework.batch.core.JobExecution)
     * @throws StartLimitExceededException if start limit of one of the steps
     * was exceeded
     */
    public void execute(JobExecution execution) throws JobExecutionException {

        JobInstance jobInstance = execution.getJobInstance();

        StepExecution currentStepExecution = null;
        int startedCount = 0;
        List steps = getSteps();
        ExitStatus jobStatus = ExitStatus.UNKNOWN;

        TransactionStatus transaction = null;
        if (isTransactional()) {
            transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
        }

        try {

            // The job was already stopped before we even got this far. Deal
            // with it in the same way as any other interruption.
            if (execution.getStatus() == BatchStatus.STOPPING) {
                throw new JobInterruptedException("JobExecution already stopped before being executed.");
            }

            execution.setStartTime(new Date());
            updateStatus(execution, BatchStatus.STARTING);

            listener.beforeJob(execution);

            for (Iterator i = steps.iterator(); i.hasNext();) {

                Step step = (Step) i.next();

                if (shouldStart(jobInstance, step)) {

                    startedCount++;
                    updateStatus(execution, BatchStatus.STARTED);
                    currentStepExecution = execution.createStepExecution(step);

                    StepExecution lastStepExecution = jobRepository.getLastStepExecution(jobInstance, step);

                    boolean isRestart = (jobRepository.getStepExecutionCount(jobInstance, step) > 0 && !lastStepExecution.getExitStatus().equals(
                            ExitStatus.FINISHED)) ? true : false;

                    if (isRestart && lastStepExecution != null) {
                        currentStepExecution.setExecutionContext(lastStepExecution.getExecutionContext());
                    } else {
                        currentStepExecution.setExecutionContext(new ExecutionContext());
                    }

                    step.execute(currentStepExecution);
                    if (currentStepExecution.isTerminateOnly()) {
                        break;
                    }

                }
            }

            updateStatus(execution, BatchStatus.COMPLETED);

            listener.afterJob(execution);

        } catch (JobInterruptedException e) {
            execution.setStatus(BatchStatus.STOPPED);
            listener.onInterrupt(execution);
            if (transaction != null) {
                transactionManager.rollback(transaction);
            }
            rethrow(e);
        } catch (Throwable t) {
            execution.setStatus(BatchStatus.FAILED);
            listener.onError(execution, t);
            if (transaction != null) {
                transactionManager.rollback(transaction);
            }
            rethrow(t);
        } finally {
            jobStatus = ExitStatus.FAILED;
            if (startedCount == 0) {
                if (steps.size() > 0) {
                    jobStatus = ExitStatus.NOOP.addExitDescription("All steps already completed.  No processing was done.");
                } else {
                    jobStatus = ExitStatus.NOOP.addExitDescription("No steps configured for this job.");
                }
            } else if (currentStepExecution != null) {
                jobStatus = currentStepExecution.getExitStatus();
            }

            execution.setEndTime(new Date());
            execution.setExitStatus(jobStatus);
            jobRepository.saveOrUpdate(execution);
        }

        if (transaction != null) {
            try {
                if (jobStatus.equals(ExitStatus.FAILED)) {
                    transactionManager.rollback(transaction);
                } else {
                    transactionManager.commit(transaction);
                }
            } catch (Exception e) {
                throw new RuntimeException("Fatal error detected during commit/rollback", e);
            }
        }

    }

    private void updateStatus(JobExecution jobExecution, BatchStatus status) {
        jobExecution.setStatus(status);
        jobRepository.saveOrUpdate(jobExecution);
    }

    /*
     * Given a step and configuration, return true if the step should start,
     * false if it should not, and throw an exception if the job should finish.
     */
    private boolean shouldStart(JobInstance jobInstance, Step step) throws JobExecutionException {

        BatchStatus stepStatus;
        // if the last execution is null, the step has never been executed.
        StepExecution lastStepExecution = jobRepository.getLastStepExecution(jobInstance, step);
        if (lastStepExecution == null) {
            stepStatus = BatchStatus.STARTING;
        } else {
            stepStatus = lastStepExecution.getStatus();
        }

        if (stepStatus == BatchStatus.UNKNOWN) {
            throw new JobExecutionException("Cannot restart step from UNKNOWN status.  "
                    + "The last execution ended with a failure that could not be rolled back, " + "so it may be dangerous to proceed.  "
                    + "Manual intervention is probably necessary.");
        }

        if (stepStatus == BatchStatus.COMPLETED && step.isAllowStartIfComplete() == false) {
            // step is complete, false should be returned, indicating that the
            // step should not be started
            return false;
        }

        if (jobRepository.getStepExecutionCount(jobInstance, step) < step.getStartLimit()) {
            // step start count is less than start max, return true
            return true;
        } else {
            // start max has been exceeded, throw an exception.
            throw new StartLimitExceededException("Maximum start limit exceeded for step: " + step.getName() + "StartMax: " + step.getStartLimit());
        }
    }

    /**
     * @param t
     */
    private static void rethrow(Throwable t) throws RuntimeException {
        if (t instanceof RuntimeException) {
            throw (RuntimeException) t;
        } else if (t instanceof Error) {
            throw (Error) t;
        } else {
            throw new UnexpectedJobExecutionException("Unexpected checked exception in job execution", t);
        }
    }

    /**
     * Public setter for the {@link JobRepository} that is needed to manage the
     * state of the batch meta domain (jobs, steps, executions) during the life
     * of a job.
     * 
     * @param jobRepository
     */
    public void setJobRepository(JobRepository jobRepository) {
        this.jobRepository = jobRepository;
    }

    /**
     * Public setter for the {@link PlatformTransactionManager}.
     * 
     * @param transactionManager the transaction manager to set
     */
    public void setTransactionManager(PlatformTransactionManager transactionManager) {
        this.transactionManager = transactionManager;
    }

    /**
     * @return the transactional
     */
    public boolean isTransactional() {
        return transactional;
    }

    /**
     * @param transactional the transactional to set
     */
    public void setTransactional(boolean transactional) {
        this.transactional = transactional;
    }

}
