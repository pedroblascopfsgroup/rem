package es.capgemini.devon.exception;

import org.springframework.context.NoSuchMessageException;
import org.springframework.context.support.AbstractMessageSource;

import es.capgemini.devon.utils.MessageUtils;

/**
 * @author Nicolás Cornaglia
 */
public class FrameworkException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    protected FrameworkException() {
        super();
    }

    public FrameworkException(String messageKey, Object... messageArgs) {
        super(resolveMessage(messageKey, messageArgs));
    }

    public FrameworkException(Throwable cause) {
        super(cause);
    }

    public FrameworkException(Throwable cause, String messageKey, Object... messageArgs) {
        super(resolveMessage(messageKey, messageArgs), cause);
    }

    private static String resolveMessage(String messageKey, Object[] messageArgs) {
        AbstractMessageSource ms = MessageUtils.getMessageSource();
        String resolved = null;
        if (ms != null) {
            try {
                resolved = ms.getMessage(messageKey, messageArgs, MessageUtils.DEFAULT_LOCALE);
            } catch (NoSuchMessageException e) {
                resolved = copyArgs(messageKey, messageArgs);
            }
        } else {
            resolved = copyArgs(messageKey, messageArgs);
        }

        return resolved;
    }

    private static String copyArgs(String messageKey, Object[] messageArgs) {
        String resolved = messageKey + (messageArgs.length > 0 ? ":" : "");
        for (Object arg : messageArgs) {
            resolved = resolved + ", " + arg;
        }
        return resolved;
    }
}
