package es.capgemini.devon.batch;

import java.util.Date;
import java.util.Map;

import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;

import es.capgemini.devon.exception.FrameworkException;

/**
 * Clase de utilidades para el Batch.
 * 
 * @author Nicolás Cornaglia
 */
public class BatchUtils {

    /**
     * Genera un {@link JobParameters} necesario por Spring Batch
     * 
     * @param params
     * @return
     */
    public static JobParameters getJobParameters(Map<String, ?> params) {
        JobParametersBuilder pb = new JobParametersBuilder();
        for (Map.Entry<String, ?> entry : params.entrySet()) {
            if (entry.getValue() instanceof String) {
                pb.addString(entry.getKey(), (String) entry.getValue());
            } else if (entry.getValue() instanceof Long) {
                pb.addLong(entry.getKey(), (Long) entry.getValue());
            } else if (entry.getValue() instanceof Double) {
                pb.addDouble(entry.getKey(), (Double) entry.getValue());
            } else if (entry.getValue() instanceof Date) {
                pb.addDate(entry.getKey(), (Date) entry.getValue());
            } else {
                throw new FrameworkException(new IllegalArgumentException((entry.getValue()).getClass().getName()));
            }
        }

        return pb.toJobParameters();

    }

}
