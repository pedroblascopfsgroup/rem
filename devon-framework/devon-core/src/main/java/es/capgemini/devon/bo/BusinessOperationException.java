package es.capgemini.devon.bo;

import es.capgemini.devon.exception.FrameworkException;

/**
 * TODO Documentar
 *
 * @author Nicolás Cornaglia
 */
public class BusinessOperationException extends FrameworkException {

    private static final long serialVersionUID = 1L;

    protected BusinessOperationException() {
        super();
    }

    public BusinessOperationException(String messageKey, Object... messageArgs) {
        super(messageKey, messageArgs);
    }

    public BusinessOperationException(Throwable cause) {
        super(cause);
    }

    public BusinessOperationException(Throwable cause, String messageKey, Object... messageArgs) {
        super(cause, messageKey, messageArgs);
    }

}
