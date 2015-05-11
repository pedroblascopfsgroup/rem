package es.capgemini.pfs.batch.revisar.clientes;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.pfs.arquetipo.ArquetipoManager;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.batch.revisar.movimientos.MovimientosBatchManager;
import es.capgemini.pfs.batch.revisar.personas.PersonasBatchManager;
import es.capgemini.pfs.cliente.ClienteManager;

/**
 * Ejecuta el job de revisar clientes.
 * @author Andrés Esteban
 *
 */
public class RevisarClientesTasklet implements Tasklet, StepExecutionListener {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ClientesBatchManager clientesBatchManager;
    @Autowired
    private PersonasBatchManager personasBatchManager;
    @Autowired
    private MovimientosBatchManager movimientosBatchManager;
    @Autowired
    private ArquetipoManager arquetipoManager;
    @Autowired
    private ClienteManager clienteManager;

    private Date fechaExtraccion;
    private String bindings;

    /**
     * Inicia el job de revisión de clientes.
     * @return ExisEstatus codigo
     */
    @Override
    public ExitStatus execute() {
        logger.debug("Inicio del job RevisarClientes");

        List<Long> contratosCliente;
        Long arqCalculadoId;
        Long arqActualId;
        Long contratoPaseId;
        Boolean esRecuperacion;
        Long personaId;

        List<Long> clientesIds = clientesBatchManager.buscarClientesActivos();

        for (Long clienteId : clientesIds) {
            logger.debug("Revisando el cliente con id: " + clienteId);

            //Recuperamos el contrato de pase del cliente
            contratoPaseId = clientesBatchManager.buscarContratoPrincipal(clienteId);
            logger.debug("Su contrato de pase con id: " + contratoPaseId);

            //Asignamos el nuevo arquetipo si lo tuviera y recalculamos sus timers
            logger.debug("Revisando el arquetipo");
            personaId = clientesBatchManager.buscarPersona(clienteId);
            arqActualId = clientesBatchManager.buscarArquetipo(clienteId);
            arqCalculadoId = personasBatchManager.buscarArquetipoCalculado(personaId);

            //Si ha cambiado de arquetipo y es un arquetipo válido
            if (arqCalculadoId != null && arqActualId != null) {
                if (!arqCalculadoId.equals(arqActualId)) {

                    //Si el nuevo arquetipo NO provoca gestión cancelamos el cliente
                    Arquetipo arq = arquetipoManager.get(arqCalculadoId);
                    if (arq != null) {
                        if (arq.getGestion() == false) {
                            logger.debug("El cliente ha cambiado a un arquetipo sin gestión");
                            clientesBatchManager.cancelarCliente(clienteId);
                            logger.debug("Fin de la revisión del cliente");
                            continue;
                        }

                        logger.debug("Cambio el arquetipo del cliente con id: " + clienteId);
                        clienteManager.asginarArquetipo(clienteId, arqCalculadoId);
                        clienteManager.recalcularTimersGestionVencidos(clienteId, arqCalculadoId);
                        arqActualId = arqCalculadoId;
                    }
                }
            }

            //Implementar el método de arquetipo de recuperación
            //Comprobamos si el arquetipo es de recuperación
            esRecuperacion = arquetipoManager.isArquetipoRecuperacion(arqActualId);

            //Revisamos el contrato de pase por si se hubiera saldado o cancelado
            //Si se ha saldado y es de recuperación o si se ha cancelado sea cual sea su itinerario, se cancela el cliente
            if (movimientosBatchManager.revisarMovimientos(contratoPaseId, fechaExtraccion, clienteId, null, null, esRecuperacion, false)) {
                logger.debug("El cliente ha saldado/cancelado su contrato de pase");
                clientesBatchManager.cancelarCliente(clienteId);
                logger.debug("Fin de la revisión del cliente");
                continue;
            }

            //Insertar nuevos contratos vencidos y no vencidos
            clientesBatchManager.insertarNuevosContratos(clienteId);

            //Recuperamos todos los contratos del cliente
            contratosCliente = clientesBatchManager.buscarContratos(clienteId);

            // Reviso los movimientos de los contratos del cliente
            logger.debug("Revisando los contratos del cliente");
            for (Long contratoId : contratosCliente) {
                //Si se trata del contrato de pase, como ya se ha revisado, se salta
                if (contratoPaseId.equals(contratoId)) {
                    continue;
                }
                //Revisamos el movimiento del contrato, pero no nos fijamos si el contrato está o no saldado, simplemente si se cancela
                if (movimientosBatchManager.revisarMovimientos(contratoId, fechaExtraccion, clienteId, null, null, false, false)) {
                    clientesBatchManager.borrarContrato(clienteId, contratoId);
                }

            }
        }

        logger.debug("Fin del job RevisarClientes");
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
        ParameterBinder.bind(this, bindings, stepExecution.getJobParameters());
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
     * Setea los parámetros a cargar en el beforeStep.
     * @param bindings parámetros
     */
    public void setBindings(String bindings) {
        this.bindings = bindings;
    }

    /**
     * Setea la fecha de extracción.
     * @param fechaExtraccion date
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
        this.fechaExtraccion = fechaExtraccion;
    }

}
