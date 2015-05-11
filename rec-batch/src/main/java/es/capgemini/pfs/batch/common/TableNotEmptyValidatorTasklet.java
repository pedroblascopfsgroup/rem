package es.capgemini.pfs.batch.common;

import javax.sql.DataSource;

import org.springframework.batch.core.StepExecution;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;

/**
 * TaskLet que valida que una tabla este vacia.
 * @author jbosnjak
 */
public class TableNotEmptyValidatorTasklet implements ValidationTasklet {

    private static final String QUERY = "select count(*) from ${table}";
    private static final String TABLE_PLACEHOLDER = "${table}";
    private String tableName;
    private DataSource dataSource;
    private String message;
    private String severidad;

    /**
     * Metodo de ejecucion principal de la clase.
     * @return ExitStatus
     */
    @Override
    public ExitStatus execute() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(getDataSource());
        long recordCount = jdbcTemplate.queryForLong(QUERY.replace(TABLE_PLACEHOLDER, tableName));
        if (recordCount > 0) { return ExitStatus.FINISHED; }
        /*EventBatchUtil eUtil = new EventBatchUtil();
        eUtil.throwEventErrorChannel(getMessage(), getSeveridad());*/
        EventBatchUtil.getInstance().throwEventErrorChannel(getMessage(), getSeveridad(), false);
        return ExitStatus.FAILED;

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
}
