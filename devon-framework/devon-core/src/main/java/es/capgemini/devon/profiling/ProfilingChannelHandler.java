package es.capgemini.devon.profiling;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.annotation.MessageEndpoint;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.core.Message;

/**
 * @author Nicol�s Cornaglia
 */
@MessageEndpoint
public class ProfilingChannelHandler {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ProfilerManager profilerManager;

    /**
     * Logear los mensajes gen�ricos en el logger del Handler
     * 
     * @param message
     */
    @ServiceActivator(inputChannel = "profilingChannel")
    public void handle(Message<ProfileData> message) {
        if (logger.isTraceEnabled()) {
            logger.debug("profiling: " + message.getHeaders().getTimestamp() + ": " + message.getPayload());
        }
        profilerManager.addData(message.getPayload());
    }

}
