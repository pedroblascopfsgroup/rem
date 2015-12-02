package es.pfsgroup.recovery.integration;

import org.springframework.integration.core.Message;



public interface Action<T> extends Rule<T> {

	/**
	 * Ejecuta acción con el mensaje que llega.
	 * 
	 * @param message
	 */
	void execute(Message<T> message);

	
}
