package es.pfsgroup.recovery.integration;

public class IntegrationDataException extends RuntimeException {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;

	public IntegrationDataException(String message) {
		super(message);
	}

	public IntegrationDataException(String message, Throwable t) {
		super(message, t);
	}

}
