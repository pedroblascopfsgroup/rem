package es.capgemini.pfs.batch.revisar.expedientes;

import java.util.Date;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.batch.BatchException;
import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.pfs.batch.common.ValidationTasklet;
import es.capgemini.pfs.batch.revisar.movimientos.MovimientosBatchManager;

/**
 * Tasklet que revisa los movimientos de un contrato.
 *
 * @author Andrés Esteban
 */
public class RevisarExpedientesTasklet implements ValidationTasklet {

    private final Log logger = LogFactory.getLog(getClass());
    private Date fechaExtraccion; // DDMMYYYY

    private String bindings;

    @Autowired
    private ExpedientesBatchManager expedientesBatchManager;
    @Autowired
    private MovimientosBatchManager movimientosBatchManager;

    /**
     * @return the fechaExtraccion
     */
    public Date getFechaExtraccion() {
        return fechaExtraccion;
    }

    /**
     * @param fechaExtraccion
     *            the fechaExtraccion to set
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
        this.fechaExtraccion = fechaExtraccion;
    }

    /**
     * @return the bindings
     */
    public String getBindings() {
        return bindings;
    }

    /**
     * @param bindings
     *            the bindings to set
     */
    public void setBindings(String bindings) {
        this.bindings = bindings;
    }

    /**
     * Metodo de ejecucion principal.
     *
     * @return ExitStatus
     * @throws Exception
     *             e
     */
    @Override
    public ExitStatus execute() throws Exception {
        Long cntId = null;
        Long expId = null;

        try {
            //Busco todos los Expedientes
            logger.debug("Buscando expedientes");
            Set<ExpedienteBatch> expedientes = expedientesBatchManager.buscarExpedientesActivos();
            for (ExpedienteBatch e : expedientes) {
                expId = e.getId();
                if (e.isAutomatico()
                        && movimientosBatchManager.revisarMovimientos(e.getIdContratoPase(), fechaExtraccion, null, e.getId(), null, true, true)) {
                    logger.debug("Contrato " + e.getIdContratoPase() + " cancelado");
                    expedientesBatchManager.cancelarExpediente(e.getId(), e.getIdJbpm());

                } else {
                    logger.debug("El contrato " + e.getIdContratoPase() + " de pase no es cancelable");
                    for (Long idContrato : e.getIdsContratosNoPase()) {
                        cntId = idContrato;
                        if (movimientosBatchManager.revisarMovimientos(idContrato, fechaExtraccion, null, e.getId(), null, false, true)) {

                            //@NOTA: El cliente ha decidido que no se deben liberar contratos aunque estén saldados
                            //logger.debug("El contrato " + idContrato + " esta cancelado");
                            //expedientesBatchManager.liberarContrato(idContrato, e.getId());
                        }
                    }
                }
            }
            return ExitStatus.FINISHED;
        } catch (Exception e) {
            logger.error(e);
            throw new BatchException("Error revisando expedientes -> expediente: [" + expId + "] contrato: [" + cntId + "]", e);
        }
    }

    /**
     * afterStep.
     *
     * @param arg0
     *            StepExecution
     * @return ExistStatus
     */
    @Override
    public ExitStatus afterStep(StepExecution arg0) {
        return null;
    }

    /**
     * beforeStep.
     *
     * @param stepExecution
     *            StepExecution
     */
    @Override
    public void beforeStep(StepExecution stepExecution) {
        ParameterBinder.bind(this, bindings, stepExecution.getJobParameters());
    }

    /**
     * onErrorInStep.
     *
     * @param arg0
     *            StepExecution
     * @param arg1
     *            Throwable
     * @return ExitStatus
     */
    @Override
    public ExitStatus onErrorInStep(StepExecution arg0, Throwable arg1) {
        return null;
    }

}
