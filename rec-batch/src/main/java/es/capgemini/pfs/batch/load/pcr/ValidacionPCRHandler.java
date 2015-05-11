package es.capgemini.pfs.batch.load.pcr;

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
public class ValidacionPCRHandler extends BatchValidacionHandler implements BatchPCRConstantes {

    @Autowired
    private EventManager eventManager;

    /**
     * {@inheritDoc}
     */
    @Override
    public String getJobName() {
        return PCR_VALIDACION_JOBNAME;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void sendEndChainEvent(String workingCode) {
        eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento END [" + workingCode + "]");
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(PCR_CHAIN_CHANNEL, workingCode), CHAIN_END);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Map<String, Object> buildParameters(Map<?, ?> parameters, String fileName, String workingCode) {
        Map<String, Object> params = new HashMap<String, Object>();

        //FIXME sacar cuando vaya a produccion
        params.put("random", new Random(System.currentTimeMillis()).toString());
        params.put(CONTRATOS_TXT, parameters.get(CONTRATOS_TXT));
        params.put(CONTRATOS_CSV, parameters.get(CONTRATOS_CSV));
        params.put(PERSONAS_TXT, parameters.get(PERSONAS_TXT));
        params.put(PERSONAS_CSV, parameters.get(PERSONAS_CSV));
        params.put(RELACION_TXT, parameters.get(RELACION_TXT));
        params.put(RELACION_CSV, parameters.get(RELACION_CSV));
        params.put(DIRECCIONES_TXT, parameters.get(DIRECCIONES_TXT));
        params.put(DIRECCIONES_CSV, parameters.get(DIRECCIONES_CSV));
        params.put(PCR_CNT_PARAM_ROWCOUNT, parameters.get(PCR_CNT_PARAM_ROWCOUNT));
        params.put(PCR_PER_PARAM_ROWCOUNT, parameters.get(PCR_PER_PARAM_ROWCOUNT));
        params.put(PCR_REL_PARAM_ROWCOUNT, parameters.get(PCR_REL_PARAM_ROWCOUNT));
        params.put(PCR_CNT_PARAM_SUM_POS_VENCIDA, parameters.get(PCR_CNT_PARAM_SUM_POS_VENCIDA));
        params.put(PCR_DIR_PARAM_ROWCOUNT, parameters.get(PCR_DIR_PARAM_ROWCOUNT));

        params.put(FILENAME, fileName);
        params.put(ENTIDAD, workingCode);
        params.put(EXTRACTTIME, parameters.get(EXTRACTTIME));
        return params;
    }

}
