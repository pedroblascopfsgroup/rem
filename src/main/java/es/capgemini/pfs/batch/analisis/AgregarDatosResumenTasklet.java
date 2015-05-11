package es.capgemini.pfs.batch.analisis;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StopWatch;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.subfase.model.Subfase;

/**
 *  Agrega los Datos necesarios para poder realizar el
 *  Resumen de las Posiciones Irregulares dentro del
 *  Análisis de la Posición de la Oficina.
 *
 * @author Andrés Esteban
 *
 */
public class AgregarDatosResumenTasklet implements Tasklet, StepExecutionListener {

    private final Log logger = LogFactory.getLog(getClass());

    private Date fechaExtraccion;

    private String bindings;

    @Autowired
    private ResumenBatchManager resumenBatchManager;

    /**
     *
     *@return ExisEstatus codigo
     */
    @Override
    public ExitStatus execute() {
        logger.debug("Inicio del analisis Agregar Datos Resumen");
        StopWatch sw = new StopWatch();
        sw.start();

        resumenBatchManager.borrarAnalisis(fechaExtraccion);

        Object[] args = { Subfase.SUBFASE_NV, DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA, Subfase.SUBFASE_CAR, Subfase.SUBFASE_GV15,
                Subfase.SUBFASE_GV15_30, Subfase.SUBFASE_GV30_60, Subfase.SUBFASE_GV60, Subfase.SUBFASE_NV,
                DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA };
        resumenBatchManager.realizarAnalisis(args);
        sw.stop();

        logger.debug("Fin del analisis. Tiempo total: " + sw.getTotalTimeMillis());

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
    public ExitStatus afterStep(@SuppressWarnings("unused") StepExecution stepExecution) {
        return null;
    }

    /**
     * @param stepExecution step
     * @param error throwable
     * @return ExitStatus codigo
     */
    @Override
    public ExitStatus onErrorInStep(@SuppressWarnings("unused") StepExecution stepExecution, @SuppressWarnings("unused") Throwable error) {
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
     * Setea la fecha de extracciï¿½n.
     * @param fechaExtraccion date
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
        this.fechaExtraccion = fechaExtraccion;
    }

    /**
     * @param bindings the bindings to set
     */
    public void setBindings(String bindings) {
        this.bindings = bindings;
    }

}
