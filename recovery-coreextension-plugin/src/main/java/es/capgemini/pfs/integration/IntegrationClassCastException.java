package es.capgemini.pfs.integration;

public class IntegrationClassCastException extends RuntimeException {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;

	public IntegrationClassCastException(String expected, String found, String problem) {
		super(String.format("[INTEGRACION] Se esperaba una clase de tipo %s, sin embargo se ha recibido del tipo %s. Problema: %s", expected, found, problem));
	}


}
