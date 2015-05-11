package es.capgemini.pfs.batch.common;

import java.util.List;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.repeat.ExitStatus;

/**
 * Esta clase se encarga de correr varias validaciones.
 * @author jbosnjak
 *
 */
public class MultipleValidator implements ValidationTasklet {

    private List<ValidationTasklet> validaciones;

    private DataSource dataSource;

    private Log logger = LogFactory.getLog(getClass());

    /**
     * getValidaciones.
     * @return validaciones
     */
    public List<ValidationTasklet> getValidaciones() {
        return validaciones;
    }

    /**
     * setValidaciones.
     * @param validaciones validaciones to set
     */
    public void setValidaciones(List<ValidationTasklet> validaciones) {
        this.validaciones = validaciones;
    }

    /**
     * Metodo que ejecuta las validaciones.
     * @return ExitStatus
     * @throws Exception e
     */
    @Override
    public ExitStatus execute() throws Exception {
        ExitStatus exit = ExitStatus.FINISHED;
        for (ValidationTasklet validator : this.validaciones) {
            logger.debug("Corriendo validacion clase: " + validator.getClass().getName());
            ExitStatus exit2 = validator.execute();
            if (!exit.getExitCode().equals(ExitStatus.FAILED.getExitCode())) {
                //exit = ExitStatus.FAILED;
                exit = exit2;
            }
        }
        return exit;
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
        for (ValidationTasklet validator : this.validaciones) {
            validator.beforeStep(stepExecution);
        }
    }

    /**
     * onErrorInStep.
     * @param arg0 SteoExecution
     * @param arg1 Throwable
     * @return ExistStatus
     */
    @Override
    public ExitStatus onErrorInStep(StepExecution arg0, Throwable arg1) {
        return null;
    }

    /**
     * getDataSource.
     * @return the dataSource
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

    private String bindings;

    /**
     * getBindings.
     * @return the bindings
     */
    public String getBindings() {
        return bindings;
    }

    /**
     * setBindings.
     * @param bindings the bindings to set
     */
    public void setBindings(String bindings) {
        this.bindings = bindings;
    }

}
