package es.capgemini.devon.events;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.integration.channel.PollableChannel;
import org.springframework.integration.channel.PublishSubscribeChannel;
import org.springframework.integration.core.MessageChannel;
import org.springframework.integration.message.GenericMessage;
import org.springframework.integration.message.MessageHandler;

import es.capgemini.devon.events.defered.DeferedEvent;
import es.capgemini.devon.exception.FrameworkException;

public interface EventManager {

    public final static String ERROR_CHANNEL = "errorChannel";
    public final static String GENERIC_CHANNEL = "genericChannel";
    public static final String RETHROWED_KEY = "rethrowed";
    public static final String DEFERED_EVENT_KEY = "defered_event_id";

    /**
     * Fires events to a channel
     * 
     * @param channelName
     * @param event
     */
    public abstract void fireEvent(String channelName, Event event);

    /**
     * Fires events with properties to a channel
     * 
     * @param channelName
     * @param event
     * @param properties
     */
    public abstract void fireEvent(String channelName, Event event, Map<String, Serializable> properties);

    /**
     * Fires message events to a channel
     * 
     * @param channelName
     * @param message
     */
    public abstract void fireEvent(String channelName, String message);

    /**
     * @param channelName
     * @param message
     * @param properties
     */
    public abstract void fireEvent(String channelName, String message, Map<String, Serializable> properties);

    /**
     * Fires exception events to a channel
     * 
     * @param channelName
     * @param message
     */
    public abstract void fireEvent(String channelName, FrameworkException exception);

    /**
     * Fires generic messages to a channel
     * 
     * @param channelName
     * @param event
     */
    public void fireEvent(String channelName, GenericMessage genericMessage);

    /**
     * Crea una cola de mensajes a la cual es posible suscribirse.
     * 
     * @param channelName
     * @return
     */
    public PublishSubscribeChannel createPublishSubscribeChannel(String channelName);

    /**
     * Crea una cola de mensajes a la cual es posible pedirle los mensajes bajo demanda.
     * 
     * @param channelName
     * @return
     */
    public PollableChannel createPollableChannel(String channelName);

    /**
     * Elimina una cola de mensajes
     * 
     * @param channelName
     */
    public void destroyChannel(String channelName);

    /**
     * @param channelName
     */
    public abstract MessageChannel getChannel(String channelName);

    /**
     * @param channelName
     * @return
     */
    public abstract List<Event> receive(String channelName);

    /**
     * @param messageChannel
     * @return
     */
    public abstract List<Event> receive(PollableChannel messageChannel);

    /**
     * @param channelName
     * @param bean
     * @return
     */
    public abstract MessageHandler subscribe(String channelName, Object bean);

    /**
     * @param channelName
     * @param bean
     * @param methodName
     * @return
     */
    public abstract MessageHandler subscribe(String channelName, Object bean, String methodName);

    /**
     * @param channelName
     * @param messageHandler
     */
    public abstract void unsubscribe(String channelName, MessageHandler messageHandler);

    /**
     * Guarda en base de datos un evento diferido
     * 
     * @param deferedEvent
     */
    public abstract void saveOrUpdate(DeferedEvent deferedEvent);

    /**
     * Crea un bean {@link DeferedEvent} y lo garda en abse de datos
     * 
     * @param queue
     * @param data
     * @param arrived
     * @param willProcess
     * @return
     */
    public abstract DeferedEvent createDeferedEvent(String queue, Serializable data, Long arrived, Date willProcess);

    /**
     * Obtiene los eventos diferidos de base de datos y los envía a la cola correspondiente
     * 
     * @param channelName
     * @param before
     */
    public abstract void reQueueJobs(String channelName, Date before);

    /**
     * Actualizar la fecha de proceso de un DeferedEvent
     * 
     * @param property
     * @param now
     */
    public abstract void updateProcessDate(Long id, Date date);
}