package es.capgemini.pfs.batch.common;

import javax.sql.DataSource;

import org.springframework.batch.core.StepExecution;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;

/**
 * TaskLet que valida un record count de una tabla dada.
 * @author jbosnjak
 *
 */
public class RecordCountValidatorTasklet implements ValidationTasklet {

    private static final String COUNT_QUERY = "select count(*) from ${table}";
    private static final String TABLE_NAME_PLACEHOLDER = "${table}";

    private String tableName;
    private String expectedRecords;
    private DataSource dataSource;
    private String bindings;
    private String message;
    private String severidad;

    /**
     * Metodo de ejecucion de la clase.
     * @return ExitStatus
     */
    @Override
    public ExitStatus execute() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(getDataSource());
        String query = COUNT_QUERY.replace(TABLE_NAME_PLACEHOLDER, tableName);
        long recordCount = jdbcTemplate.queryForLong(query);
        if (recordCount == Long.parseLong(expectedRecords)) { return ExitStatus.FINISHED; }
        Object[] params = new Object[] { expectedRecords, "" + recordCount };
        EventBatchUtil.getInstance().throwEventErrorChannel(getMessage(), getSeveridad(), false, params);
        if (severidad != null && "error".equalsIgnoreCase(severidad)) {
            ExitStatus exit = new ExitStatus(false, ExitStatus.FAILED.getExitCode(), getMessage());
            return exit;
        }
        return ExitStatus.FINISHED;

    }

    /**
     * afterStep.
     * @param stepExecution StepExecution
     * @return ExistStatus
     */
    @Override
    public ExitStatus afterStep(StepExecution stepExecution) {
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
     * @param arg0 SteoExecution
     * @param arg1 Throwable
     * @return ExistStatus
     */
    @Override
    public ExitStatus onErrorInStep(StepExecution arg0, Throwable arg1) {
        EventBatchUtil.getInstance().throwEventErrorChannel(arg1, getSeveridad(), getMessage());
        return null;
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
     * @return the expectedRecords
     */
    public String getExpectedRecords() {
        return expectedRecords;
    }

    /**
     * @param expectedRecords the expectedRecords to set
     */
    public void setExpectedRecords(String expectedRecords) {
        this.expectedRecords = expectedRecords;
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
}
