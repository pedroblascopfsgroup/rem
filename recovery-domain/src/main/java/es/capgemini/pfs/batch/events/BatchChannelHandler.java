package es.capgemini.pfs.batch.events;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.integration.annotation.MessageEndpoint;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.core.Message;

import es.capgemini.devon.batch.events.BatchEndedEvent;
import es.capgemini.devon.batch.events.BatchEvent;
import es.capgemini.devon.batch.events.BatchStartedEvent;

/**
 * @author Nicolás Cornaglia
 */
@MessageEndpoint
public class BatchChannelHandler {

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Eventos de error Batch por validaciones erroneas.
     * Insertar Una incidencia en la BBDD.
     * @param message Message
     */
    @ServiceActivator(inputChannel = "batchChannel")
    public void handle(Message<?> message) {
        BatchEvent e = (BatchEvent) message.getPayload();
        if (e instanceof BatchStartedEvent) {
            logger.debug("    batchChannel: " + "Batch started: [" + e.getPropertyAsString(BatchEvent.JOB_NAME_KEY) + "]");
        } else {
            if (e instanceof BatchEndedEvent) {
                Exception ex = (Exception) e.getProperty(BatchEndedEvent.EXCEPTION_KEY);
                String msg = "    batchChannel: " + "Batch ended: [" + e.getPropertyAsString(BatchEvent.JOB_NAME_KEY) + "]";
                if (ex == null) {
                    msg += "";
                } else {
                    msg += ex.getMessage();
                }
                logger.debug(msg);
            }
        }
    }
}
