package es.pfsgroup.recovery.integration;

import java.util.List;

import org.springframework.integration.core.Message;

public class ConsumerActionManager<T> implements ConsumerManager<T> {

	private final List<ConsumerAction<T>> consumerList;
	
	public ConsumerActionManager(List<ConsumerAction<T>> consumerList) {
		this.consumerList = consumerList;
	}

	public void dispatch(Message<T> message) {
		// busca los mensajes 
		for (ConsumerAction<T> consumer : consumerList) {
			if (consumer.check(message)) {
				consumer.execute(message);
			}
		}
	}
	
}
