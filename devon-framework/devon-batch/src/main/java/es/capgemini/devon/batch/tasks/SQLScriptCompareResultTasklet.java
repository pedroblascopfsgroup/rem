package es.capgemini.devon.batch.tasks;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.devon.batch.BatchException;
import es.capgemini.devon.batch.ParameterBinder;

/**
 * @author Nicolás Cornaglia
 */
public class SQLScriptCompareResultTasklet implements Tasklet, StepExecutionListener {

    private final Log logger = LogFactory.getLog(getClass());

    private String bindings;
    private DataSource dataSource;
    private String script;

    /**
     * Execute the SQL
     * 
     * @see org.springframework.batch.core.step.tasklet.Tasklet#execute()
     */
    public ExitStatus execute() {

        try {
            JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
            jdbcTemplate.execute(script);
        } catch (Exception e) {
            throw new BatchException(e);
        }

        return ExitStatus.FINISHED;
    }

    @Required
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public ExitStatus afterStep(StepExecution stepExecution) {
        return null;
    }

    @Override
    public void beforeStep(StepExecution stepExecution) {
        ParameterBinder.bind(this, bindings, stepExecution.getJobParameters());
    }

    @Override
    public ExitStatus onErrorInStep(StepExecution stepExecution, Throwable e) {
        return null;
    }

    public void setBindings(String bindings) {
        this.bindings = bindings;
    }

    public void setScript(String script) {
        this.script = script;
    }
}
