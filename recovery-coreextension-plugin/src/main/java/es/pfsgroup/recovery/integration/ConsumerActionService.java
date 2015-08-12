package es.pfsgroup.recovery.integration;

import org.springframework.integration.core.Message;
import org.springframework.integration.message.MessageHandlingException;

public class ConsumerActionService extends DataContainerPayloadService<DataContainerPayload> {

	@Override
	protected void doOnError(Message<DataContainerPayload> message, Exception ex) {
		super.doOnError(message, ex);
		throw new MessageHandlingException(message, ex);
	}
	
	public ConsumerActionService(ConsumerManager<DataContainerPayload> consumerManager
			, String entidadWorkingCode) {
		super(consumerManager, entidadWorkingCode);
	}

}
