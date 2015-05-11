package es.pfsgroup.plugin.recovery.masivo;

/**
 * Esta excepción indica que se ha producido un error (pete) durante una validación.
 * @author bruno
 *
 */
public class ValidationError extends RuntimeException{

	private static final long serialVersionUID = -7179660673439877464L;

	public ValidationError() {
		super();
	}

	public ValidationError(String message, Throwable cause) {
		super(message, cause);
	}

	public ValidationError(String message) {
		super(message);
	}

	public ValidationError(Throwable cause) {
		super(cause);
	}

}
