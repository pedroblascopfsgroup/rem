package es.capgemini.pfs.batch.load.pcr;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.BatchPasajeProduccionHandler;

/**
 * Clase encargada de Invocar el proceso de pasaje a produccion.
 * Si finaliza Ok, Se lanza un evento para la ejecución de las revisiones.
 * @author jbosnjak
 *
 */
public class PasajeProduccionHandler extends BatchPasajeProduccionHandler implements BatchPCRConstantes {

    /**
     * Se hace un autowired del eventManager.
     */
    @Autowired
    private EventManager eventManager;

    /**
     * {@inheritDoc}
     */
    @Override
    public String getJobName() {
        return PCR_PASAJE_JOBNAME;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void fireEndEvent() {
        getEventManager().fireEvent(PCR_CHAIN_CHANNEL, CHAIN_END);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void sendEndChainEvent() {
        eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento END [" + workingCode + "]");
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(PCR_CHAIN_CHANNEL, workingCode), CHAIN_END);
    }

}
