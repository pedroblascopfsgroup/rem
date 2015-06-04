package es.capgemini.pfs.integration;

import org.springframework.integration.core.Message;

public class DenyAllRule<T> implements Rule<T> {

	/**
	 * Siempre deniega
	 */
	@Override
	public boolean check(Message<T> message) {
		return false;
	}

}
