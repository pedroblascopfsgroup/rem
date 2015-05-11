package es.capgemini.pfs.batch.common;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.devon.batch.BatchException;
import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.devon.batch.tasks.BatchValidationException;
import es.capgemini.devon.events.ErrorEvent;
import es.capgemini.devon.events.EventManager;

/**
 * Esta Clase es la encagar de realizar validaciones de integridad.
 * @author jbosnjak
 *
 */
public class IntegrityValidatorTasklet implements ValidationTasklet {

    /**
     * logger.
     */
    private final Log logger = LogFactory.getLog(getClass());

    private String query;
    private String tableName;
    private String expectedNumber;
    private DataSource dataSource;
    private String bindings;
    private String message;
    private String severidad;

    /**
     * EventManager.
     */
    @Autowired
    private EventManager eventManager;

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
     * Este metodo evalua que la query devuelva el valor esperado.
     * @return ExistStatus
     * @throws Exception e
     */
    @Override
    public ExitStatus execute() throws Exception {
        JdbcOperations jdbcTemplate = new JdbcTemplate(getDataSource());
        long recordCount = jdbcTemplate.queryForLong(query);
        if (recordCount != Long.parseLong(expectedNumber)) {
            logger.debug("Falló la validación porque hay una persona sin relaciones");
            ErrorEvent ev = new ErrorEvent(new BatchValidationException(getMessage(), getSeveridad()));
            eventManager.fireEvent(BatchException.ERROR_CHANNEL, ev);
            if (severidad != null && severidad.equals("error")) {
                ExitStatus exit = new ExitStatus(false, ExitStatus.FAILED.getExitCode(), getMessage());
                return exit;
            }
        }
        return ExitStatus.FINISHED;
    }

    /**
     * afterStep.
     * @param arg0 StepExecution
     * @return ExistStatus
     */
    @Override
    public ExitStatus afterStep(StepExecution arg0) {
        // TODO Implementar este método
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
        ErrorEvent ev = new ErrorEvent(new BatchValidationException(getMessage(), getSeveridad()));
        eventManager.fireEvent(BatchException.ERROR_CHANNEL, ev);
        return null;
    }

    /**
     * getSeveridad.
     * @return severidad
     */
    public String getSeveridad() {
        return severidad;
    }

    /**
     * setSeveridad.
     * @param severida severidad to set
     */
    public void setSeveridad(String severida) {
        this.severidad = severida;
    }

    /**
     * Inyección del {@link EventManager} para gestión de eventos.
     * @param eventManager EventManager
     */
    public void setEventManager(EventManager eventManager) {
        this.eventManager = eventManager;
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
     * @return the eventManager
     */
    public EventManager getEventManager() {
        return eventManager;
    }

}
