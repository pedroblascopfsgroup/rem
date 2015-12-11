package es.capgemini.devon.stubs.events;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.integration.channel.PollableChannel;
import org.springframework.integration.channel.PublishSubscribeChannel;
import org.springframework.integration.core.MessageChannel;
import org.springframework.integration.message.GenericMessage;
import org.springframework.integration.message.MessageHandler;
import org.springframework.stereotype.Component;

import es.capgemini.devon.events.ErrorEvent;
import es.capgemini.devon.events.Event;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.events.GenericEvent;
import es.capgemini.devon.events.defered.DeferedEvent;
import es.capgemini.devon.exception.FrameworkException;

/**
 * Mock {@link EventManager}
 * 
 * @author Nicolás Cornaglia
 */
@Component("eventManager")
public class StubEventManagerImpl implements EventManager {

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * @see es.capgemini.devon.events.EventManager#fireEvent(java.lang.String,
     *      es.capgemini.devon.events.Event)
     */
    @Override
    public void fireEvent(String channelName, Event event) {
        fireEvent(channelName, event, null);
    }

    /**
     * @see es.capgemini.devon.events.EventManager#fireEvent(java.lang.String,
     *      es.capgemini.devon.events.Event, java.util.Map)
     */
    @Override
    public void fireEvent(String channelName, Event event, Map<String, Serializable> properties) {
        if (properties != null) {
            event.setProperties(properties);
        }
        if (logger.isDebugEnabled()) {
            logger.debug("Evento recibido: [" + event + "]");
        }
        if (event.getProperties().containsKey(ErrorEvent.EXCEPTION_KEY)) {
            Exception exception = (Exception) event.getProperty(ErrorEvent.EXCEPTION_KEY);
            String out = "";
            out = exception.getMessage();
            if (exception.getCause() != null) {
                out = out + " Cause: " + exception.getCause().getMessage();
            }
            logger.error(out, exception);
        }
    }

    /**
     * @see es.capgemini.devon.events.EventManager#fireEvent(java.lang.String,
     *      java.lang.String)
     */
    @Override
    public void fireEvent(String channelName, String message) {
        Event event = new GenericEvent();
        event.setProperty(Event.MESSAGE_KEY, message);
        fireEvent(channelName, event);
    }

    @Override
    public void fireEvent(String channelName, String message, Map<String, Serializable> properties) {
        Event event = new GenericEvent();
        event.setProperty(Event.MESSAGE_KEY, message);
        fireEvent(channelName, event, properties);
    }

    /**
     * @see es.capgemini.devon.events.EventManager#fireEvent(java.lang.String,
     *      es.capgemini.devon.exception.FrameworkException)
     */
    @Override
    public void fireEvent(String channelName, FrameworkException exception) {
        Event event = new GenericEvent();
        event.setProperty(ErrorEvent.EXCEPTION_KEY, exception);
        fireEvent(channelName, event);
    }

    /**
     * @see es.capgemini.devon.events.EventManager#getChannel(java.lang.String,
     *      boolean)
     */
    @Override
    public MessageChannel getChannel(String name) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public List<Event> receive(String channelName) {
        return null;
    }

    @Override
    public List<Event> receive(PollableChannel messageChannel) {
        // TODO Auto-generated method stub
        return null;
    }

    /**
     * @see es.capgemini.devon.events.EventManager#fireEvent(java.lang.String,
     *      org.springframework.integration.message.GenericMessage)
     */
    @Override
    public void fireEvent(String channelName, GenericMessage genericMessage) {
        // TODO Auto-generated method stub

    }

    @Override
    public DeferedEvent createDeferedEvent(String queue, Serializable data, Long arrived, Date willProcess) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void reQueueJobs(String channelName, Date before) {
        // TODO Auto-generated method stub

    }

    @Override
    public void saveOrUpdate(DeferedEvent deferedEvent) {
        // TODO Auto-generated method stub

    }

    @Override
    public void updateProcessDate(Long id, Date date) {
        // TODO Auto-generated method stub

    }

    /**
     * @see es.capgemini.devon.events.EventManager#subscribe(java.lang.String, java.lang.Object)
     */
    @Override
    public MessageHandler subscribe(String channelName, Object bean) {
        // TODO Auto-generated method stub
        return null;
    }

    /**
     * @see es.capgemini.devon.events.EventManager#subscribe(java.lang.String, java.lang.Object, java.lang.String)
     */
    @Override
    public MessageHandler subscribe(String channelName, Object bean, String methodName) {
        return null;
    }

    /**
     * @see es.capgemini.devon.events.EventManager#createPollableChannel(java.lang.String)
     */
    @Override
    public PollableChannel createPollableChannel(String channelName) {
        // TODO Auto-generated method stub
        return null;
    }

    /**
     * @see es.capgemini.devon.events.EventManager#createPublishSubscribeChannel(java.lang.String)
     */
    @Override
    public PublishSubscribeChannel createPublishSubscribeChannel(String channelName) {
        // TODO Auto-generated method stub
        return null;
    }

    public void unsubscribe(String channelName, MessageHandler messageHandler) {
        // TODO Auto-generated method stub

    }

    public void destroyChannel(String channelName) {
        // TODO Auto-generated method stub

    }

}
