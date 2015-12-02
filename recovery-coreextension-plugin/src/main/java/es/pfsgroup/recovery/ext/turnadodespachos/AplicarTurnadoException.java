package es.pfsgroup.recovery.ext.turnadodespachos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class AplicarTurnadoException extends Exception {

	protected final Log logger = LogFactory.getLog(getClass());
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public AplicarTurnadoException(String message) {
		super(message);
		logger.error(message);
	}
	
	public AplicarTurnadoException(String message, Throwable cause) {
		super(message, cause);
		logger.error(message, cause);
	}
	
}
