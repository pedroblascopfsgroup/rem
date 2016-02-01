package es.capgemini.devon.files;

import es.capgemini.devon.exception.FrameworkException;

/**
 * @author Nicolás Cornaglia
 */
public class FileException extends FrameworkException {

    private static final long serialVersionUID = 1L;

    protected FileException() {
        super();
    }

    public FileException(String messageKey, Object... messageArgs) {
        super(messageKey, messageArgs);
    }

    public FileException(Throwable cause) {
        super(cause);
    }

    public FileException(Throwable cause, String messageKey, Object... messageArgs) {
        super(cause, messageKey, messageArgs);
    }

}
