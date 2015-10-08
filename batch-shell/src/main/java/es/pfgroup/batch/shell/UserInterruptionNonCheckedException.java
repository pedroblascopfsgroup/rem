package es.pfgroup.batch.shell;

public class UserInterruptionNonCheckedException extends RuntimeException {

	public UserInterruptionNonCheckedException() {
		super();
	}

	public UserInterruptionNonCheckedException(String message, Throwable cause) {
		super(message, cause);
	}

	public UserInterruptionNonCheckedException(String message) {
		super(message);
	}

	public UserInterruptionNonCheckedException(Throwable cause) {
		super(cause);
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = 3164940848154373304L;

}
