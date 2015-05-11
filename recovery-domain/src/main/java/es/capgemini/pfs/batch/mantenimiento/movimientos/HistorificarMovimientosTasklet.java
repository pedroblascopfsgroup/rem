package es.capgemini.pfs.batch.mantenimiento.movimientos;

import java.util.Date;

import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.pfs.batch.revisar.movimientos.MovimientosBatchManager;

/**
 * Historificacion de movimientos.
 * @author lgiavedo
 *
 */
public class HistorificarMovimientosTasklet implements Tasklet, StepExecutionListener {

    private Date fechaExtraccion;

    private String bindings;

    @Autowired
    private MovimientosBatchManager movimientosBatchManager;

    /**
     * Inicia el job de Historificacion de movimientos.
     * @return ExisEstatus codigo
     */
    @Override
    public ExitStatus execute() {

        movimientosBatchManager.historificarMovimiento();
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
     * @param error throwable
     * @return ExitStatus codigo
     */
    @Override
    public ExitStatus onErrorInStep(StepExecution stepExecution, Throwable error) {
        return null;
    }

    /**
     * @param stepExecution step
     */
    @Override
    public void beforeStep(StepExecution stepExecution) {
        ParameterBinder.bind(this, bindings, stepExecution.getJobParameters());
    }

    /*--------------------------------------------------------------------
     * Setters
     *--------------------------------------------------------------------*/

    /**
     * Setea la fecha de extracción.
     * @param fechaExtraccion date
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
        this.fechaExtraccion = fechaExtraccion;
    }

    /**
     * @return the fechaExtraccion
     */
    public Date getFechaExtraccion() {
        return fechaExtraccion;
    }

    /**
     * @param bindings the bindings to set
     */
    public void setBindings(String bindings) {
        this.bindings = bindings;
    }

}
