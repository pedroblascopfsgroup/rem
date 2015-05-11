package es.capgemini.pfs.batch.load.alertas;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.BatchAnalizeProduccionHandler;

/**
 * Clase encargada de Invocar el proceso de pasaje a produccion.
 * Si finaliza Ok, Se lanza un evento para la ejecución de las revisiones.
 * @author aesteban
 *
 */
public class AnalizeAlertasProduccionHandler extends BatchAnalizeProduccionHandler implements BatchAlertasConstants {

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
        return ALE_ANALIZE_JOBNAME;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void sendEndChainEvent(String workingCode) {
        eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento END [" + workingCode + "]");
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(ALE_CHAIN_CHANNEL, workingCode), CHAIN_END);
    }

}
