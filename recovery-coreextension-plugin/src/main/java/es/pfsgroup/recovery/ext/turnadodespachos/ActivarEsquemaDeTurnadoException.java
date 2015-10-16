package es.pfsgroup.recovery.ext.turnadodespachos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class ActivarEsquemaDeTurnadoException extends Exception {

	protected final Log logger = LogFactory.getLog(getClass());
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public ActivarEsquemaDeTurnadoException(String message) {
		super(message);
		logger.error(message);
	}
	
	public ActivarEsquemaDeTurnadoException(String message, Throwable cause) {
		super(message, cause);
		logger.error(message, cause);
	}
	
}
