package es.pfgroup.monioring.bach.load.persistence;

import java.util.Date;

/**
 * Capa de persistencia para guardar datos sobre la ejecución del monitor.
 * 
 * @author bruno
 * 
 */
public interface CheckStatusPersitenceService {

    /**
     * Persiste el dia/hora de la última comprobación de status para un job
     * 
     * @param entity
     * @param jobName
     */
    void saveCheckStatusTime(Integer entity, String jobName);

    /**
     * Devuelve el día y la hora de la última vez que se comprobó el status de
     * un job.
     * 
     * @param entity
     * @param jobName
     * @return
     */
    Date getLastCheckStatusTimeOrNull(Integer entity, String jobName);

}
