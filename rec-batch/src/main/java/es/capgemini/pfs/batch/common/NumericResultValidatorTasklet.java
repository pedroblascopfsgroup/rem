package es.capgemini.pfs.batch.common;

import javax.sql.DataSource;

import org.springframework.batch.core.StepExecution;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;

/**
 * Tasklet que compara un resultado numerico.
 * @author jbosnjak
 *
 */
public class NumericResultValidatorTasklet implements ValidationTasklet {

    private String query;
    private String tableName;
    private String expectedNumber;
    private DataSource dataSource;
    private String bindings;
    private String message;
    private String severidad;

    /**
     * @return the query
     */
    public String getQuery() {
        return query;
    }

    /**
     * @param query the query to set
     */
    public void setQuery(String query) {
        this.query = query;
    }

    /**
     * @return the tableName
     */
    public String getTableName() {
        return tableName;
    }

    /**
     * @param tableName the tableName to set
     */
    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    /**
     * @return the expectedNumber
     */
    public String getExpectedNumber() {
        return expectedNumber;
    }

    /**
     * @param expectedNumber the expectedNumber to set
     */
    public void setExpectedNumber(String expectedNumber) {
        this.expectedNumber = expectedNumber;
    }

    /**
     * @return the dataSource
     */
    public DataSource getDataSource() {
        return dataSource;
    }

    /**
     * @param dataSource the dataSource to set
     */
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * @return the message
     */
    public String getMessage() {
        return message;
    }

    /**
     * @param message the message to set
     */
    public void setMessage(String message) {
        this.message = message;
    }

    /**
     * @return the severidad
     */
    public String getSeveridad() {
        return severidad;
    }

    /**
     * @param severidad the severidad to set
     */
    public void setSeveridad(String severidad) {
        this.severidad = severidad;
    }

    /**
     * Metodo de ejecucion de la clase.
     * @return ExitStatus
     */
    @Override
    public ExitStatus execute() {

        JdbcOperations jdbcTemplate = new JdbcTemplate(getDataSource());
        // long recordCount = jdbcTemplate.queryForLong(query);
        Double value = (Double) jdbcTemplate.queryForObject(query, Double.class);
        if (value.doubleValue() == Double.parseDouble(expectedNumber)) { return ExitStatus.FINISHED; }
        EventBatchUtil.getInstance().throwEventErrorChannel(getMessage(), getSeveridad(), false);
        if (severidad != null && "error".equalsIgnoreCase(severidad)) {
            ExitStatus exit = new ExitStatus(false, ExitStatus.FAILED.getExitCode(), getMessage());
            return exit;
        }
        return ExitStatus.FINISHED;

    }

    /**
     * afterStep.
     * @param arg0 StepExecution
     * @return ExitStatus
     */
    @Override
    public ExitStatus afterStep(StepExecution arg0) {
        return null;
    }

    /**
     * beforeStep.
     * @param stepExecution StepExecution
     */
    @Override
    public void beforeStep(StepExecution stepExecution) {
        ParameterBinder.bind(this, bindings, stepExecution.getJobParameters());
    }

    /**
     * onErrorInStep.
     * @param arg0 StepExecution
     * @param arg1 Throwable
     * @return ExitStatus
     */
    @Override
    public ExitStatus onErrorInStep(StepExecution arg0, Throwable arg1) {
        EventBatchUtil.getInstance().throwEventErrorChannel(arg1, getSeveridad(), getMessage());
        return null;
    }

    /**
     * @return the bindings
     */
    public String getBindings() {
        return bindings;
    }

    /**
     * @param bindings the bindings to set
     */
    public void setBindings(String bindings) {
        this.bindings = bindings;
    }
}
