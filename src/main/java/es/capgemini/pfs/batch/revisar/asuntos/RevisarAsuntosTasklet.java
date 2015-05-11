package es.capgemini.pfs.batch.revisar.asuntos;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.pfs.batch.revisar.movimientos.MovimientosBatchManager;

/**
 * Revision de asuntos.
 * @author jbosnjak
 *
 */
public class RevisarAsuntosTasklet implements Tasklet, StepExecutionListener {

    private final Log logger = LogFactory.getLog(getClass());

    private Date fechaExtraccion;

    private String bindings;

    @Autowired
    private AsuntosBatchManager asuntosBatchManager;

    @Autowired
    private MovimientosBatchManager movimientosBatchManager;

    /**
     * Inicia el job de revisión de asuntos.
     * @return ExisEstatus codigo
     */
    @Override
    public ExitStatus execute() {

        List<Map<String, Object>> contratos = asuntosBatchManager.obtenerContratosAsunto();
        logger.debug("Se encontraron " + contratos.size() + " contratos para revisar.");
        for (Map<String, Object> contrato : contratos) {
            Long idAsunto = Long.valueOf(contrato.get("ASU_ID").toString());
            Long idContrato = Long.valueOf(contrato.get("CNT_ID").toString());
            movimientosBatchManager.revisarMovimientos(idContrato, fechaExtraccion, null, null, idAsunto, true, true);
        }

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
     * @param bindings the bindings to set
     */
    public void setBindings(String bindings) {
        this.bindings = bindings;
    }

}
