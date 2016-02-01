package es.capgemini.devon.batch;

import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.AbstractStep;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.util.Assert;

/**
 * @author Nicolás Cornaglia
 */
public class StoppableTaskletStep extends AbstractStep {

    private Tasklet tasklet;

    /**
     * Check mandatory properties.
     * @see org.springframework.beans.factory.InitializingBean#afterPropertiesSet()
     */
    @Override
    public void afterPropertiesSet() throws Exception {
        super.afterPropertiesSet();
        Assert.notNull(tasklet, "Tasklet is mandatory for TaskletStep");
        if (tasklet instanceof StepExecutionListener) {
            registerStepExecutionListener((StepExecutionListener) tasklet);
        }
    }

    /**
     * Default constructor is useful for XML configuration.
     */
    public StoppableTaskletStep() {
        super();
    }

    /**
     * Creates a new <code>Step</code> for executing a <code>Tasklet</code>
     * 
     * @param tasklet The <code>Tasklet</code> to execute
     * @param jobRepository The <code>JobRepository</code> to use for
     * persistence of incremental state
     */
    public StoppableTaskletStep(Tasklet tasklet, JobRepository jobRepository) {
        this();
        this.tasklet = tasklet;
        setJobRepository(jobRepository);
    }

    /**
     * Public setter for the {@link Tasklet}.
     * @param tasklet the {@link Tasklet} to set
     */
    public void setTasklet(Tasklet tasklet) {
        this.tasklet = tasklet;
    }

    /**
     * Delegate to tasklet.
     */
    @Override
    protected ExitStatus doExecute(StepExecution stepExecution) throws Exception {
        ExitStatus status = tasklet.execute();
        if (status.getExitCode().equals(ExitStatus.FAILED.getExitCode())) {
            stepExecution.setTerminateOnly();
        }
        return status;
    }

    @Override
    protected void close(ExecutionContext ctx) throws Exception {
    }

    @Override
    protected void open(ExecutionContext ctx) throws Exception {
    }

}
