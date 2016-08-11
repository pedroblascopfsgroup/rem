package es.pfsgroup.plugin.messagebroker.integration;

import org.springframework.integration.annotation.Gateway;
import org.springframework.integration.annotation.Header;

import es.pfsgroup.plugin.messagebroker.StandardHeaders;

public interface MessageBrokerGateway {
	
	@Gateway
	public void sendAsyncMessage(@Header(StandardHeaders.TYPE_OF_MESSAGE) String typeOfMessage, Object data);

}
