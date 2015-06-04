package es.capgemini.pfs.integration;

import org.springframework.integration.core.Message;

public abstract interface ConsumerManager<T> {

	void dispatch(Message<T> message);
	
}
