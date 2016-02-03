package es.capgemini.devon.events.defered;

import es.capgemini.devon.exception.FrameworkException;

/**
 * @author Nicolás Cornaglia
 */
public class DeferedEventException extends FrameworkException {

    private static final long serialVersionUID = 1L;

    protected DeferedEventException() {
        super();
    }

    public DeferedEventException(String messageKey, Object... messageArgs) {
        super(messageKey, messageArgs);
    }

}
