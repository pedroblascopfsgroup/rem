package es.capgemini.pfs.batch.common;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.devon.batch.ParameterBinder;

/**
 * @author Andrés Esteban
 */
public class ActualizarFicheroCargadoTasklet implements Tasklet, StepExecutionListener {

    private DataSource dataSource;
    private String bindings;
    private String desmarcarScript;
    private String insertarScript;
    private Date fechaExtraccion;
    private String codigoFichero;
    private String updateRegistroScript;
    private String ultimoIdScript;

    /**
     * @param updateRegistroScript the updateRegistroScript to set
     */
    public void setUpdateRegistroScript(String updateRegistroScript) {
        this.updateRegistroScript = updateRegistroScript;
    }

    /**
     * @param ultimoIdScript the ultimoIdScript to set
     */
    public void setUltimoIdScript(String ultimoIdScript) {
        this.ultimoIdScript = ultimoIdScript;
    }

    /**
     * Actualiza la tabla de archivos cargados.
     * @return ExitStatus
     * @throws Exception e
     */
    @SuppressWarnings("unchecked")
    @Override
    public ExitStatus execute() throws Exception {

        JdbcOperations jdbcTemplate = new JdbcTemplate(getDataSource());
        // Marco el flag en 0 para todas la carga previa
        jdbcTemplate.update(desmarcarScript, new Object[] { codigoFichero });

        jdbcTemplate.update(insertarScript, new Object[] { codigoFichero, fechaExtraccion });

        //Si hace falta, pongo el id de la fecha en el registro correspondiente
        if (updateRegistroScript != null) {
            List<Map> result = jdbcTemplate.queryForList(ultimoIdScript, new Object[] { codigoFichero });
            if (result.size() != 1) { return ExitStatus.FAILED; }
            //TODO el result devuelve un BigDecimal Ver por qué no lo inserta (caetear a Long?)
            jdbcTemplate.update(updateRegistroScript, new Object[] { ((BigDecimal) result.get(0).get("LAST_ID")).doubleValue() });
        }

        return ExitStatus.FINISHED;
    }

    /**
     * getStackTrace.
     * @param aThrowable exception
     * @return stack serialize
     */
    public String getStackTrace(Throwable aThrowable) {
        final Writer result = new StringWriter();
        final PrintWriter printWriter = new PrintWriter(result);
        aThrowable.printStackTrace(printWriter);
        return result.toString();
    }

    /**
     * getDataSource.
     * @return the datasource
     */
    public DataSource getDataSource() {
        return dataSource;
    }

    /**
     * setDataSource.
     * @param dataSource the datasource to set
     */
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
     * @param desmarcarScript the desmarcarScript to set
     */
    public void setDesmarcarScript(String desmarcarScript) {
        this.desmarcarScript = desmarcarScript;
    }

    /**
     * @param insertarScript the insertarScript to set
     */
    public void setInsertarScript(String insertarScript) {
        this.insertarScript = insertarScript;
    }

    /**
     * @param fechaExtraccion the fechaExtraccion to set
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
        this.fechaExtraccion = fechaExtraccion;
    }

    /**
     * @param codigoFichero the codigoFichero to set
     */
    public void setCodigoFichero(String codigoFichero) {
        this.codigoFichero = codigoFichero;
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
