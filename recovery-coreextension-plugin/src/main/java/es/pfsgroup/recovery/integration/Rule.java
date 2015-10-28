package es.pfsgroup.recovery.integration;

import org.springframework.integration.core.Message;

public interface Rule<T> {

	/**
	 * Comprueba si esta regla es válida
	 * 
	 * @return
	 */
	boolean check(Message<T> message);
	
}
