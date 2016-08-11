package es.pfsgroup.plugin.messagebroker;

import es.pfsgroup.plugin.messagebroker.integration.MessageBrokerGateway;

public class MessageBroker {

	private MessageBrokerGateway messageBrokerGateway;
	
	/**
	 * Envía datos en bruto de forma asíncrcona mediante el sistema de mensajería.
	 * @param data
	 */
	public void sendAsync(String typeOfMessage, Object data) {
		messageBrokerGateway.sendAsyncMessage(typeOfMessage, data);
		
	}
	
	public void setMessageBrokerGateway(MessageBrokerGateway messageBrokerGateway) {
		this.messageBrokerGateway = messageBrokerGateway;
	}

}
