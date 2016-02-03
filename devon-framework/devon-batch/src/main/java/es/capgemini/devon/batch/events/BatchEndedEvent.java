package es.capgemini.devon.batch.events;

/**
 * @author Nicolás Cornaglia
 */
public class BatchEndedEvent extends BatchEvent {

    private static final long serialVersionUID = 1L;

    public static String EXCEPTION_KEY = "exception";

    public BatchEndedEvent(String jobName, Exception exception) {
        super(jobName);
        if (exception != null) {
            setProperty(EXCEPTION_KEY, exception);
        }
    }

}
