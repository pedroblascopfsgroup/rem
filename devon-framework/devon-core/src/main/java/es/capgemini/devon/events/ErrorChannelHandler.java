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
public class ErrorChannelHandler {

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Eventos de error. FIXME Que hacer?
     *
     * @param message mensaje
     */
    @ServiceActivator(inputChannel = "errorChannel")
    public void handle(Message<?> message) {
        String out = "";
        if (message.getPayload() instanceof ErrorEvent) {
            Exception e = ((ErrorEvent) message.getPayload()).getException();
            out = e.getMessage();
            if (e.getCause() != null) {
                out = out + " Cause: " + e.getCause().getMessage();
            }
        } else if (message.getPayload() instanceof GenericEvent) {
            out = ((GenericEvent) message.getPayload()).getPropertyAsString(Event.MESSAGE_KEY);
        } else {
            out = message.getPayload().toString();
        }
        if (logger.isErrorEnabled()) {
            logger.error("    ERROR CHANNEL: " + message.getHeaders().getTimestamp() + ": " + out);
        }
    }

}
