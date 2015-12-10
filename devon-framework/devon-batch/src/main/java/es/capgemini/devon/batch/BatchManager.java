package es.capgemini.devon.batch;

import java.util.Date;
import java.util.Map;

import org.springframework.batch.core.Job;

import es.capgemini.devon.exception.FrameworkException;

/**
 * Gestiona los "jobs" de Spring Batch.
 * 
 * @author Nicol�s Cornaglia
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
     * La "key" de los par�metros es {@link String}, los par�metros en s� pueden ser: 
     * <ul>
     * <li>{@link String}</li>
     * <li>{@link Long}</li>
     * <li>{@link Double}</li>
     * <li>{@link Date}</li>
     * </ul>
     * 
     * @param jobName Nombre del job, correspondiente al nombre del bean que lo define
     * @param jobParameters Map de par�metros del job. 
     * @return BatchExitStatus C�digo de resultado de la ejecuci�n
     * @throws FrameworkException
     */
    public abstract BatchExitStatus run(String jobName, Map<String, Object> jobParameters) throws FrameworkException;

}