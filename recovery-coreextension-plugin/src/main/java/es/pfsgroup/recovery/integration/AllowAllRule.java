package es.pfsgroup.recovery.integration;

import org.springframework.integration.core.Message;

public class AllowAllRule<T> implements Rule<T> {

	/**
	 * Siempre acepta
	 * 
	 * @param message Mensaje
	 */
	@Override
	public boolean check(Message<T> message) {
		return true;
	}

}
