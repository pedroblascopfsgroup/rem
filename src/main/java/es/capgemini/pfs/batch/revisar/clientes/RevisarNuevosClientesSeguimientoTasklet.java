package es.capgemini.pfs.batch.revisar.clientes;

import java.util.Date;
import java.util.HashMap;
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
import es.capgemini.pfs.batch.revisar.personas.PersonasBatchManager;
import es.capgemini.pfs.cliente.process.ClienteBPMConstants;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * Se encarga de generar un nuevos clientes en base a los contratos vencidos
 *  que se le pasaron como parámetro.
 * @author Andrés Esteban
 *
 */
public class RevisarNuevosClientesSeguimientoTasklet implements Tasklet, StepExecutionListener, ClienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private PersonasBatchManager personasBatchManager;

    private Date fechaExtraccion;
    private String bindings;

    @Autowired
    private JBPMProcessManager jbpmUtils;

    /**
     * Revisar los nuevos clientes.
     * @return ExitStatus FINISHED si no hay errores
     * @throws Exception
     */
    @Override
    public ExitStatus execute() {
        logger.debug("Inicio del job RevisarNuevosClientesSeguimiento");

        List<Long> idPersonasFuturosClientes = personasBatchManager.buscarFuturosClientesSeguimiento();
        Long idArquetipo;

        for (Long idPersona : idPersonasFuturosClientes) {
            idArquetipo = personasBatchManager.buscarArquetipoCalculado(idPersona);

            if (idArquetipo == null || idArquetipo.longValue() == 0) {
                logger.error("Error al intentar crear un cliente de seguimiento. La persona " + idPersona + " no tiene un arquetipo calculado");
            } else {
                if (logger.isDebugEnabled()) {
                    logger.debug("Calculo Arquetipo: " + idArquetipo);
                    logger.debug("Se creara un cliente para la persona " + idPersona);
                }

                Map<String, Object> param = new HashMap<String, Object>();
                param.put(ARQUETIPO_ID, idArquetipo);
                param.put(PERSONA_ID, idPersona);
                param.put(FECHA_EXTRACCION, fechaExtraccion);
                jbpmUtils.crearNewProcess(PROCESO_CLIENTE, param);
            }
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
     * @param bindings parametros
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
