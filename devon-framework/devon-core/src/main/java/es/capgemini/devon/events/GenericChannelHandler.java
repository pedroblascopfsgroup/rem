package es.capgemini.devon.events;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.integration.annotation.MessageEndpoint;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.core.Message;

/**
 * @author Nicolás Cornaglia
 */
@MessageEndpoint
public class GenericChannelHandler {

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Logear los mensajes genéricos en el logger del Handler
     * 
     * @param message
     */
    @ServiceActivator(inputChannel = "genericChannel")
    public void handle(Message<?> message) {
        if (logger.isDebugEnabled()) {
            logger.debug("GenericChannel: " + message.getHeaders().getTimestamp() + ": " + message.getPayload());
        }
    }

}
