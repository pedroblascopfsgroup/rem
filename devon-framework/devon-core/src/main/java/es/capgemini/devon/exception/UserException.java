package es.capgemini.devon.exception;

public class UserException extends FrameworkException {

    private static final long serialVersionUID = 1L;

    protected UserException() {
        super();
    }

    public UserException(String messageKey, Object... messageArgs) {
        super(messageKey, messageArgs);
    }

    public UserException(Throwable cause) {
        super(cause);
    }

    public UserException(Throwable cause, String messageKey, Object... messageArgs) {
        super(cause, messageKey, messageArgs);
    }

}
