package es.capgemini.pfs.batch.common;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.lang.time.StopWatch;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;

/**
 * clase que ejecuta multiples scripts.
 * @author jbosnjak
 *
 */
public class MultipleSqlScriptTasklet implements Tasklet, StepExecutionListener {

    private final Log logger = LogFactory.getLog(getClass());

    private String bindings;
    private DataSource dataSource;
    private List<Map<String, String>> scripts;

    /**
     * Execute the multiples SQL.
     * @return exit status
     * @see org.springframework.batch.core.step.tasklet.Tasklet#execute()
     */
    public ExitStatus execute() {
        for (Map<String, String> unScript : scripts) {
            String script = unScript.get("sql");
            String message = unScript.get("message");
            String error = unScript.get("severidad");
            try {
            	if (logger.isDebugEnabled()) {
                    logger.debug("SQL: " + message + " START");
                }
                StopWatch stopWatch = new StopWatch();
                stopWatch.start();
                JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
                jdbcTemplate.execute(script);
                stopWatch.stop();
                if (logger.isDebugEnabled()) {
                    logger.debug("SQL: " + message + " STOP -> " + stopWatch.getTime() + " ms.");
                }
            } catch (Exception e) {
                EventBatchUtil.getInstance().throwEventErrorChannel(e, error, message);
                return ExitStatus.FAILED;
            }
        }

        return ExitStatus.FINISHED;
    }

    /**
     * set de datasourse.
     * @param dataSource datasource
     */
    @Required
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * after step.
     * @param stepExecution stepExecution
     * @return exit
     */
    @Override
    public ExitStatus afterStep(StepExecution stepExecution) {
        return null;
    }

    /**
     * beforeStep.
     * @param stepExecution stepExecution
     */
    @Override
    public void beforeStep(StepExecution stepExecution) {
        ParameterBinder.bind(this, bindings, stepExecution.getJobParameters());
    }

    /**
     * onErrorInStep.
     * @param stepExecution stepExecution
     * @param e error
     * @return exit
     */
    @Override
    public ExitStatus onErrorInStep(StepExecution stepExecution, Throwable e) {
        return ExitStatus.FAILED;
    }

    /**
     * set de bindings.
     * @param bindings params
     */
    public void setBindings(String bindings) {
        this.bindings = bindings;
    }

    /**
     * @return the scripts
     */
    public List<Map<String, String>> getScripts() {
        return scripts;
    }

    /**
     * @param scripts the scripts to set
     */
    public void setScripts(List<Map<String, String>> scripts) {
        this.scripts = scripts;
    }

    /**
     * @return the bindings
     */
    public String getBindings() {
        return bindings;
    }
}
