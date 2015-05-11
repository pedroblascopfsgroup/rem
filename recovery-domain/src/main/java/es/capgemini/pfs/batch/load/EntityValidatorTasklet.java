package es.capgemini.pfs.batch.load;

import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.sql.DataSource;

import org.springframework.batch.core.StepExecution;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;
import es.capgemini.pfs.batch.common.ValidationTasklet;

/**
 * Valida la entidad.
 * @author jbosnjak
 *
 */
public class EntityValidatorTasklet implements ValidationTasklet {

    private String entidad;
    private String query;
    private DataSource dataSource;
    private String bindings;
    private String message;
    private String severidad;
    /**
     * Se hace un autowired del appProperties.
     */
    @Resource
    private Properties appProperties;

    /**
     * @return the entidad
     */
    public String getEntidad() {
        return entidad;
    }

    /**
     * @param entidad the entidad to set
     */
    public void setEntidad(String entidad) {
        this.entidad = entidad;
    }

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

    /**
     * valida que la entidad sea correcta.
     * @return ExitStatus
     */
    @SuppressWarnings("unchecked")
    @Override
    public ExitStatus execute() {
        JdbcOperations jdbcTemplate = new JdbcTemplate(getDataSource());
        List<Map> result = jdbcTemplate.queryForList(query, new Object[] { entidad });
        if (result.isEmpty()) { return ExitStatus.FINISHED; }
        int cantidadDeErrores = 0;
        int maximaCantidadDeErrores = new Integer(appProperties.get("batch.validation.maxQuantityError").toString());
        for (Map record : result) {
            if (maximaCantidadDeErrores < cantidadDeErrores) {
                break;
            }
            String codigoValor = "" + record.get(ERROR_FIELD);
            String codigoEntidad = "" + record.get(ENTITY_CODE);
            Object[] params = new Object[] { codigoValor, codigoEntidad };
            EventBatchUtil.getInstance().throwEventErrorChannel(getMessage(), getSeveridad(), false, params);
            cantidadDeErrores++;
        }
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
}
