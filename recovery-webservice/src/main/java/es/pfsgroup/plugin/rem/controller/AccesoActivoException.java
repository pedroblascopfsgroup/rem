package es.pfsgroup.plugin.rem.controller;

import es.capgemini.devon.exception.FrameworkException;

public class AccesoActivoException extends FrameworkException {
	
	protected AccesoActivoException() {
	}
	
	public AccesoActivoException(String message) {
		super(message);
	}

	public AccesoActivoException(String messageKey, Object[] messageArgs) {
		super(messageKey, messageArgs);
	}

	public AccesoActivoException(Throwable cause) {
		super(cause);
	}

	public AccesoActivoException(Throwable cause, String messageKey,
			Object[] messageArgs) {
		super(cause, messageKey, messageArgs);
	}
}
