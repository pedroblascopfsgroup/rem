package es.capgemini.pfs.batch.load.alertas;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.QueueUtils;
import es.capgemini.pfs.batch.load.BatchValidacionHandler;

/**
 * Clase que ejecuta las validaciones de la carga.
 * @author aesteban
 */
public class ValidacionAlertasHandler extends BatchValidacionHandler implements BatchAlertasConstants {

    @Autowired
    private EventManager eventManager;

    /**
     * {@inheritDoc}
     */
    @Override
    public String getJobName() {
        return ALE_VALITACION_JOBNAME;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void sendEndChainEvent(String workingCode) {
        eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "Lanzamos un evento END [" + workingCode + "]");
        getEventManager().fireEvent(QueueUtils.getQueueNameForEntity(ALE_CHAIN_CHANNEL, workingCode), CHAIN_END);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Map<String, Object> buildParameters(Map<?, ?> parameters, String fileName, String workingCode) {
        Map<String, Object> params = new HashMap<String, Object>();

        //FIXME sacar cuando vaya a produccion
        params.put("random", new Random(System.currentTimeMillis()).toString());
        params.put(ALERTAS_TXT, parameters.get(ALERTAS_TXT));
        params.put(ALERTAS_CSV, parameters.get(ALERTAS_CSV));
        params.put(ALERTAS_PARAM_ROWCOUNT, parameters.get(ALERTAS_PARAM_ROWCOUNT));

        String grupoCarga = getGrupoCargaCodeFromFileName(fileName, getAppProperty(ALE_SEMAPHORE));
        params.put(ALERTAS_GRUPO_CARGA, grupoCarga);
        params.put(FILENAME, fileName);
        params.put(ENTIDAD, workingCode);
        params.put(EXTRACTTIME, parameters.get(EXTRACTTIME));
        return params;
    }

    /**
     * Obtiene el codigo del grupo de carga del nombre del fichero.
     * @param fileName nombre del fichero.
     * @param semaphorePattern patron del semaforo
     * @return working code de la entidad
     */
    private String getGrupoCargaCodeFromFileName(String fileName, String semaphorePattern) {
        // Get workingCode from semaphore fileName
        String workingCodePattern = getAppProperty(BATCH_FILES_WORKINGCODE_PATTERN);
        String workingCodePlaceholder = getAppProperty(BATCH_FILES_WORKINGCODE_PLACEHOLDER);
        String semaforo = semaphorePattern.replace(workingCodePlaceholder, workingCodePattern);
        String grupoCargaCodePattern = getAppProperty(ALERTAS_CODIGO_GRUPO_CARGA_PATTERN);
        return getRegexGroup(fileName, semaforo.replace(grupoCargaCodePattern, "(" + grupoCargaCodePattern + ")"), 1);
    }

}
