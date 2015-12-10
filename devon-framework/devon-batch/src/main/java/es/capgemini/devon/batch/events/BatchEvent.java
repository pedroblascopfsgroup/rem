package es.capgemini.devon.batch.events;

import es.capgemini.devon.events.GenericEvent;

/**
 * @author Nicolás Cornaglia
 */
public abstract class BatchEvent extends GenericEvent {

    public static final String JOB_NAME_KEY = "jobName";

    private static final long serialVersionUID = 1L;

    public BatchEvent(String jobName) {
        setProperty(JOB_NAME_KEY, jobName);
    }

}
