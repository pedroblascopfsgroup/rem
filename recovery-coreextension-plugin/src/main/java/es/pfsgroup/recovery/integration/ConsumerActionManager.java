package es.pfsgroup.recovery.integration;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.integration.core.Message;

public class ConsumerActionManager<T> implements ConsumerManager<T> {

	protected final Log logger = LogFactory.getLog(getClass());

	private final List<ConsumerAction<T>> consumerList;
	
	public ConsumerActionManager(List<ConsumerAction<T>> consumerList) {
		this.consumerList = consumerList;
	}

	public void dispatch(Message<T> message) {
		// busca los mensajes 
		boolean encontrado = false;
		for (ConsumerAction<T> consumer : consumerList) {
			if (consumer.check(message)) {
				logger.debug(String.format("[INTEGRACION] Ejecutando ActionConsumer [%s] ...", consumer.getDescription()));
				consumer.execute(message);
				logger.info(String.format("[INTEGRACION] ActionConsumer [%s] ejecutado!!", consumer.getDescription()));
				encontrado = true;
			}
		}
		
		if (!encontrado) {
			logger.info(String.format("[INTEGRACION] Mensaje GUID[%s] descartado !!! (No existe ActionConsumer configurado para este mensaje)", message.getHeaders().getId()));
		}
	}
	
}
