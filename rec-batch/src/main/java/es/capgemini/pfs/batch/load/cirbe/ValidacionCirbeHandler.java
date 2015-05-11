package es.capgemini.pfs.batch.load.cirbe;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.BatchValidacionHandler;

/**
 * Clase que ejecuta las validaciones de la carga.
 * @author jbosnjak
 */
public class ValidacionCirbeHandler extends BatchValidacionHandler implements BatchCirbeConstants {

    @Autowired
    private EventManager eventManager;

    /**
     * {@inheritDoc}
     */
    @Override
    public String getJobName() {
        return CIRBE_VALIDACION_JOBNAME;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void sendEndChainEvent(String workingCode) {
        eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento END [" + workingCode + "]");
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(CIRBE_CHAIN_CHANNEL, workingCode), CHAIN_END);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Map<String, Object> buildParameters(Map<?, ?> parameters, String fileName, String workingCode) {
        Map<String, Object> params = new HashMap<String, Object>();

        //FIXME sacar cuando vaya a produccion
        params.put("random", new Random(System.currentTimeMillis()).toString());
        params.put(FILENAME, fileName);
        params.put(ENTIDAD, workingCode);
        params.put(EXTRACTTIME, parameters.get(EXTRACTTIME));
        params.put(CIRBE_CSV, parameters.get(CIRBE_CSV));
        params.put(PROP_CIRBE_ROWCOUNT, parameters.get(PROP_CIRBE_ROWCOUNT));
        return params;
    }

}
