package es.capgemini.devon.batch.events;

/**
 * @author Nicol�s Cornaglia
 */
public class BatchStartedEvent extends BatchEvent {

    private static final long serialVersionUID = 1L;

    public BatchStartedEvent(String jobName) {
        super(jobName);
    }

}
