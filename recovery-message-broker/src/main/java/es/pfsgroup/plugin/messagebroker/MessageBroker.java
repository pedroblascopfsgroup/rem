package es.pfsgroup.plugin.messagebroker;

import es.pfsgroup.plugin.messagebroker.exceptions.InvalidHandler;
import es.pfsgroup.plugin.messagebroker.integration.MessageBrokerGateway;

public class MessageBroker {

	private static final String HANDLER_SUFFIX = "Handler";
	private MessageBrokerGateway messageBrokerGateway;
	
	/**
	 * Envía datos en bruto de forma asíncrcona mediante el sistema de mensajería.
	 * @param data
	 */
	public void sendAsync(String typeOfMessage, Object data) {
		messageBrokerGateway.sendAsyncMessage(typeOfMessage, data);
		
	}
	
	public void sendAsync(Class clazz, Object data) {
		if (clazz.getSimpleName().endsWith(HANDLER_SUFFIX)){
			
			char c[] = clazz.getSimpleName().toCharArray();
			c[0] = Character.toLowerCase(c[0]);
			String name  = new String(c);

			String typeOfMessage = name.substring(0, name.length() - HANDLER_SUFFIX.length());
			this.sendAsync(typeOfMessage, data);
			
		}else{
			throw new InvalidHandler(clazz, "Class name must end with 'Handle'");
		}
		
	}
	
	
	public void setMessageBrokerGateway(MessageBrokerGateway messageBrokerGateway) {
		this.messageBrokerGateway = messageBrokerGateway;
	}

}
