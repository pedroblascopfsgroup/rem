package es.capgemini.pfs.batch.load.gcl;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.BatchPasajeProduccionHandler;
import es.capgemini.pfs.batch.revisar.ProcesoRevisionJobLauncher;

/**
 * Clase encargada de Invocar el proceso de pasaje a produccion de CIRBE.
 * Si finaliza Ok, Se lanza un evento para la ejecución de las revisiones.
 * @author pamuller
 *
 */
public class PasajeGruposClientesProduccionHandler extends BatchPasajeProduccionHandler implements BatchGruposClientesConstants {

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
        return GCL_PASAJE_JOBNAME;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void fireEndEvent() {
        getEventManager().fireEvent(GCL_CHAIN_CHANNEL, CHAIN_END);
        //Agregamos el proceso de revision para que se ejecute al finalizar el proceso
        ProcesoRevisionJobLauncher revisionJobLauncher = (ProcesoRevisionJobLauncher) ApplicationContextUtil.getApplicationContext().getBean(
                "procesoRevisionHandler");
        revisionJobLauncher.handle(workingCode, extractTime);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void sendEndChainEvent() {
        eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento END [" + workingCode + "]");
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(GCL_CHAIN_CHANNEL, workingCode), CHAIN_END);
    }

}
