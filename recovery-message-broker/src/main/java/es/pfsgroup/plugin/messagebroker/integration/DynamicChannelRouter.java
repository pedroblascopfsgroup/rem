package es.pfsgroup.plugin.messagebroker.integration;

import org.springframework.integration.annotation.Router;
import org.springframework.integration.core.Message;

public class DynamicChannelRouter {

	@Router(inputChannel= "async.input")
	public String route(Message<Object> msg){
		return msg.getHeaders().get(StandardHeaders.TYPE_OF_MESSAGE) + ".input";
	}
}
