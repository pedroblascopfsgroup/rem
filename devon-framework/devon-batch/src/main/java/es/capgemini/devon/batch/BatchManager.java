package es.capgemini.devon.batch;

import java.util.Date;
import java.util.Map;

import org.springframework.batch.core.Job;

import es.capgemini.devon.exception.FrameworkException;

/**
 * Gestiona los "jobs" de Spring Batch.
 * 
 * @author Nicolás Cornaglia
 * @see Job
 */
public interface BatchManager {

    public static String BATCH_CHANNEL = "batchChannel";
    public static String BATCH_NAME_KEY = "batchName";

    /**
     * Ejecuta un "job":
     * 
     * <pre>
     * Map params = new HashMap();
     * params.put("now", new Date());
     * params.put("path", "C:\\tmp");
     * String result = batchManager.run("importUsers", params);
     * </pre> 
     * 
     * <p>
     * La "key" de los parámetros es {@link String}, los parámetros en sí pueden ser: 
     * <ul>
     * <li>{@link String}</li>
     * <li>{@link Long}</li>
     * <li>{@link Double}</li>
     * <li>{@link Date}</li>
     * </ul>
     * 
     * @param jobName Nombre del job, correspondiente al nombre del bean que lo define
     * @param jobParameters Map de parámetros del job. 
     * @return BatchExitStatus Código de resultado de la ejecución
     * @throws FrameworkException
     */
    public abstract BatchExitStatus run(String jobName, Map<String, Object> jobParameters) throws FrameworkException;

}