package es.capgemini.devon.events;

import es.capgemini.devon.exception.FrameworkException;

/**
 * @author Nicolás Cornaglia
 */
public class ErrorEvent extends GenericEvent {

    private static final long serialVersionUID = 1L;

    public static final String EXCEPTION_KEY = "exception";

    public ErrorEvent(FrameworkException exception) {
        setProperty(EXCEPTION_KEY, exception);
    }

    /**
     * @return the error
     */
    public FrameworkException getException() {
        return (FrameworkException) getProperty(EXCEPTION_KEY);
    }

}
