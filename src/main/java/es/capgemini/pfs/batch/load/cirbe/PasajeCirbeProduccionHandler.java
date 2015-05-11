package es.capgemini.pfs.batch.load.cirbe;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.BatchPasajeProduccionHandler;

/**
 * Clase encargada de Invocar el proceso de pasaje a produccion de CIRBE.
 * Si finaliza Ok, Se lanza un evento para la ejecución de las revisiones.
 * @author pamuller
 *
 */
public class PasajeCirbeProduccionHandler extends BatchPasajeProduccionHandler implements BatchCirbeConstants {

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
        return CIRBE_PASAJE_JOBNAME;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void fireEndEvent() {
        getEventManager().fireEvent(CIRBE_CHAIN_CHANNEL, CHAIN_END);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void sendEndChainEvent() {
        eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento END [" + workingCode + "]");
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(CIRBE_CHAIN_CHANNEL, workingCode), CHAIN_END);
    }

}
