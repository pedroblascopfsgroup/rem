package es.capgemini.pfs.batch.revisar.clientes;

import java.util.Date;

import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;

/**
 * Ejecuta el job de revisar clientes.
 * @author Andr�s Esteban
 *
 */
public class RevisarClientesTasklet implements Tasklet, StepExecutionListener {

    

    /**
     * Inicia el job de revisi�n de clientes.
     * @return ExisEstatus codigo
     */
    @Override
    public ExitStatus execute() {
       
        return ExitStatus.FINISHED;
    }

    /*--------------------------------------------------------------------
     * StepExecutionListener methods
     *--------------------------------------------------------------------*/

    /**
     * @param stepExecution step
     * @return ExitStatus codigo
     */
    @Override
    public ExitStatus afterStep(StepExecution stepExecution) {
        return null;
    }

    /**
     * @param stepExecution step
     */
    @Override
    public void beforeStep(StepExecution stepExecution) {
    }

    /**
     * @param stepExecution step
     * @param error throwable
     * @return ExitStatus codigo
     */
    @Override
    public ExitStatus onErrorInStep(StepExecution stepExecution, Throwable error) {
        return null;
    }

    /*--------------------------------------------------------------------
     * Setters
     *--------------------------------------------------------------------*/

    /**
     * Setea los par�metros a cargar en el beforeStep.
     * @param bindings par�metros
     */
    public void setBindings(String bindings) {
       
    }

    /**
     * Setea la fecha de extracci�n.
     * @param fechaExtraccion date
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
    }

}
