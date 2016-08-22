package es.pfsgroup.framework.paradise.utils;

import es.capgemini.devon.exception.FrameworkException;


public class JsonViewerException extends FrameworkException {
	
	protected JsonViewerException() {
	}
	
	public JsonViewerException(String message) {
		super(message);
	}

	public JsonViewerException(String messageKey, Object[] messageArgs) {
		super(messageKey, messageArgs);
	}

	public JsonViewerException(Throwable cause) {
		super(cause);
	}

	public JsonViewerException(Throwable cause, String messageKey,
			Object[] messageArgs) {
		super(cause, messageKey, messageArgs);
	}

	

}
