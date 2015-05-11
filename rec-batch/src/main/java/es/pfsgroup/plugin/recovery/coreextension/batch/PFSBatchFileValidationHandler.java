package es.pfsgroup.plugin.recovery.coreextension.batch;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.BatchValidacionHandler;
import es.pfsgroup.commons.utils.Checks;

/**
 * Handler genérico para la vaidación de ficheros via batch.
 * 
 * @author bruno
 * 
 */
public class PFSBatchFileValidationHandler extends BatchValidacionHandler {

    private List<String> customParams;
    private String jobName;
    private String chainChannel;

    @Override
    public Map<String, Object> buildParameters(Map<?, ?> parameters, String fileName, String workingCode) {
        final Map<String, Object> params = new HashMap<String, Object>();
        if (Checks.estaVacio(parameters)) {
            throw new IllegalArgumentException("Se debe haber pasado como mínimo el parámetro" + EXTRACTTIME);
        } else {
            params.put(EXTRACTTIME, parameters.get(EXTRACTTIME));
        }
        if (customParams != null) {
            Object parameter;
            for (String name : customParams) {
                parameter = parameters.get(name);
                if (parameter != null) {
                    params.put(name, parameter);
                }
            }
        }
        params.put("random", new Random(System.currentTimeMillis()).toString());
        params.put(FILENAME, fileName);
        params.put(ENTIDAD, workingCode);
        return params;
    }

    @Override
    public String getJobName() {
        return this.jobName;
    }

    @Override
    public void sendEndChainEvent(String workingCode) {
        getEventManager().fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento END [" + workingCode + "]");
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(chainChannel, workingCode), CHAIN_END);
    }


    public void setChainChannel(final String chainChannel) {
        this.chainChannel = chainChannel;
    }

    public void setJobName(final String jobName) {
        this.jobName = jobName;
    }


    public void setCustomParams(final List<String> customParams) {
        this.customParams = customParams;
    }

}
