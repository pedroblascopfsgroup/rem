package es.capgemini.devon.batch;

import es.capgemini.devon.bo.BusinessOperationException;

/**
 * @author Nicolás Cornaglia
 */
public class BatchException extends BusinessOperationException {

    private static final long serialVersionUID = 1L;

    public static final String SEVERIDAD_INFO = "info";
    public static final String SEVERIDAD_ERROR = "error";
    public static final String SEVERIDAD_WARN = "warn";
    public static final String SEVERIDAD_UNKNOWN = "UNKNOWN";

    public static final String ERROR_CHANNEL = "errorChannelBatch";

    private String severidad;

    protected BatchException() {
        super();
    }

    public BatchException(String messageKey, Object... messageArgs) {
        super(messageKey, messageArgs);
        setSeveridad(SEVERIDAD_UNKNOWN);
    }

    public BatchException(String messageKey, String severidad, Object... messageArgs) {
        super(messageKey, messageArgs);
        setSeveridad(severidad);
    }

    public BatchException(String messageKey, String severidad) {
        super(messageKey);
        setSeveridad(severidad);
    }

    public BatchException(Throwable cause, String severidad, String messageKey) {
        super(cause);
        setSeveridad(severidad);
    }

    public BatchException(Throwable cause) {
        super(cause);
    }

    public BatchException(Throwable cause, String messageKey, Object... messageArgs) {
        super(cause, messageKey, messageArgs);
    }

    public String getSeveridad() {
        return severidad;
    }

    public void setSeveridad(String severidad) {
        this.severidad = severidad;
    }
}
