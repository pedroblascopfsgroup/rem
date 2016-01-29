package es.capgemini.devon.web.fileupload;

import es.capgemini.devon.exception.FrameworkException;

public class FileUploadException extends FrameworkException {

    private static final long serialVersionUID = 1L;

    protected FileUploadException() {
        super();
    }

    public FileUploadException(String messageKey, Object... messageArgs) {
        super(messageKey, messageArgs);
    }

    public FileUploadException(Throwable cause) {
        super(cause);
    }

    public FileUploadException(Throwable cause, String messageKey, Object... messageArgs) {
        super(cause, messageKey, messageArgs);
    }
}
