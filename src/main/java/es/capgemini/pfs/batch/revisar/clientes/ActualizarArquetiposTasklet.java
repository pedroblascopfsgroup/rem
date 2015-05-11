package es.capgemini.pfs.batch.revisar.clientes;

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

/**
 * Se encarga de generar alcualizar los arquetipos por el valor de los calculados.
 * 
 * @author lgiavedo
 *
 */
public class ActualizarArquetiposTasklet implements Tasklet, StepExecutionListener, ClienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private PersonasBatchManager personasBatchManager;

    private String bindings;

    /**
     * 
     * @return ExitStatus FINISHED si no hay errores
     * @throws Exception
     */
    @Override
    public ExitStatus execute() {
        logger.debug("Inicio del job ActualizarArquetiposTasklet");

        personasBatchManager.actualizarArquetiposPorCalculados();

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

}
