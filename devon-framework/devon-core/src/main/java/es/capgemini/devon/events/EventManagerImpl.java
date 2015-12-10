package es.capgemini.devon.events;

import java.io.Serializable;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.integration.channel.AbstractMessageChannel;
import org.springframework.integration.channel.PollableChannel;
import org.springframework.integration.channel.PublishSubscribeChannel;
import org.springframework.integration.channel.SubscribableChannel;
import org.springframework.integration.channel.ThreadLocalChannel;
import org.springframework.integration.core.Message;
import org.springframework.integration.core.MessageChannel;
import org.springframework.integration.handler.MethodInvokingMessageHandler;
import org.springframework.integration.message.GenericMessage;
import org.springframework.integration.message.MessageHandler;
import org.springframework.stereotype.Service;
import org.springframework.util.ReflectionUtils;

import es.capgemini.devon.events.defered.DefaultDeferedEventFactory;
import es.capgemini.devon.events.defered.DeferedEvent;
import es.capgemini.devon.events.defered.DeferedEventDao;
import es.capgemini.devon.events.defered.DeferedEventException;
import es.capgemini.devon.events.defered.DeferedEventState;
import es.capgemini.devon.exception.FrameworkException;

/**
 * Implementación de envío de mensajes a canales.
 * Canal de errores + canal de mensages genéricos.
 *
 * @author Nicolás Cornaglia
 */
@Service("eventManager")
public class EventManagerImpl implements EventManager, Serializable {

    private static final long serialVersionUID = 1L;

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired(required = false)
    private DeferedEventDao deferedEventDao;

    @Autowired(required = false)
    private MessageChannel[] messageChannels;

    @Autowired(required = false)
    private DeferedEventFactory deferedEventFactory = new DefaultDeferedEventFactory();

    @Autowired
    private BeanFactory beanFactory;

    private Map<String, MessageChannel> channelCache = new HashMap<String, MessageChannel>();

    @PostConstruct
    public void initCache() {
        if (messageChannels != null) {
            for (MessageChannel messageChannel : messageChannels) {
                channelCache.put(messageChannel.getName(), messageChannel);
            }
        }
    }

    /**
     * @see es.capgemini.devon.events.EventManager#fireEvent(java.lang.String, java.lang.String)
     */
    @Override
    public void fireEvent(String channelName, String message) {
        fireEvent(channelName, message, null);
    }

    /**
     * @see es.capgemini.devon.events.EventManager#fireEvent(java.lang.String, java.lang.String, java.util.Map)
     */
    @Override
    public void fireEvent(String channelName, String message, Map<String, Serializable> properties) {
        Event event = new GenericEvent();
        event.setProperty(Event.MESSAGE_KEY, message);
        fireEvent(channelName, event, properties);
    }

    /**
     * @see es.capgemini.devon.events.EventManager#fireEvent(java.lang.String, es.capgemini.devon.exception.FrameworkException)
     */
    @Override
    public void fireEvent(String channelName, FrameworkException exception) {
        Event event = new ErrorEvent(exception);
        fireEvent(channelName, event);
    }

    /**
     * @see es.capgemini.devon.events.EventManager#fireEvent(java.lang.String, es.capgemini.devon.events.Event)
     */
    @Override
    public void fireEvent(String channelName, Event event) {
        fireEvent(channelName, event, null);
    }

    /**
     * @see es.capgemini.devon.events.EventManager#fireEvent(java.lang.String, es.capgemini.devon.events.Event, java.util.Map)
     */
    @Override
    public void fireEvent(String channelName, Event event, Map<String, Serializable> properties) {
        MessageChannel messageChannel = getChannel(channelName);
        if (messageChannel == null) {
            logger.warn("Unknown channel [" + channelName + "]");
        } else {
            if (properties != null) {
                for (String key : properties.keySet()) {
                    event.setProperty(key, properties.get(key));
                }
            }
            messageChannel.send(new GenericMessage<Event>(event));
            if (logger.isTraceEnabled()) {
                logger.trace("Evento enviado a [" + channelName + "]: [" + event + "]");
            }
        }
    }

    /**
     * @see es.capgemini.devon.events.EventManager#fireEvent(java.lang.String, java.lang.Object)
     */
    @Override
    public void fireEvent(String channelName, GenericMessage genericMessage) {
        MessageChannel messageChannel = getChannel(channelName);
        if (messageChannel == null) {
            logger.warn("Unknown channel [" + channelName + "]");
        } else {
            messageChannel.send(genericMessage);
            if (logger.isTraceEnabled()) {
                logger.trace("Evento enviado a [" + channelName + "]: [" + genericMessage + "]");
            }
        }
    }

    public PublishSubscribeChannel createPublishSubscribeChannel(String channelName) {
        return (PublishSubscribeChannel) createChannel(channelName, true);
    }

    public PollableChannel createPollableChannel(String channelName) {
        return (PollableChannel) createChannel(channelName, false);
    }

    /**
     * @param channelName
     * @param isPublishSubscribe
     * @return
     */
    private MessageChannel createChannel(String channelName, boolean isPublishSubscribe) {
        MessageChannel messageChannel = getChannel(channelName);
        if (messageChannel == null) {
            if (logger.isDebugEnabled()) {
                logger.debug("Creating channel [" + channelName + "]");
            }
            if (isPublishSubscribe) {
                messageChannel = new PublishSubscribeChannel();
            } else {
                messageChannel = new ThreadLocalChannel();
            }
            ((AbstractMessageChannel) messageChannel).setBeanName(channelName);
            channelCache.put(channelName, messageChannel);
            ((DefaultListableBeanFactory) beanFactory).registerSingleton(channelName, messageChannel);
        } else {
            logger.warn("Returning existing channel on creation request [" + channelName + "]");
        }
        return messageChannel;
    }

    /**
     * @param channelName
     */
    public void destroyChannel(String channelName) {
        channelCache.remove(channelName);
        ((DefaultListableBeanFactory) beanFactory).destroySingleton(channelName);
    }

    /**
     * @see es.capgemini.devon.events.EventManager#receive(java.lang.String)
     */
    public List<Event> receive(String channelName) {
        PollableChannel messageChannel = (PollableChannel) channelCache.get(channelName);
        return receive(messageChannel);
    }

    /**
     * @see es.capgemini.devon.events.EventManager#receive(org.springframework.integration.channel.PollableChannel)
     */
    public List<Event> receive(PollableChannel messageChannel) {
        List<Event> events = new LinkedList<Event>();
        if (messageChannel != null) {
            Message<?> message = null;
            PollableChannel c = messageChannel;
            while ((message = c.receive(0)) != null) {
                if (logger.isTraceEnabled()) {
                    logger.trace("received message [" + message + "] on queue [" + messageChannel.getName() + "]");
                }
                events.add((Event) message.getPayload());
                message = null;
            }
        }
        return events;
    }

    /**
     * @see es.capgemini.devon.events.EventManager#getChannel(java.lang.String)
     */
    public MessageChannel getChannel(String channelName) {
        return channelCache.get(channelName);
    }

    /**
     * @see es.capgemini.devon.events.EventManager#subscribe(java.lang.String, java.lang.Object)
     */
    public MessageHandler subscribe(String channelName, Object bean) {
        return subscribe(channelName, bean, "handle");
    }

    /**
     * @see es.capgemini.devon.events.EventManager#unsubscribe(java.lang.String, org.springframework.integration.message.MessageHandler)
     */
    public void unsubscribe(String channelName, MessageHandler messageHandler) {
        SubscribableChannel messageChannel = (SubscribableChannel) getChannel(channelName);
        messageChannel.unsubscribe(messageHandler);
    }

    /**
     * @see es.capgemini.devon.events.EventManager#subscribe(java.lang.String, java.lang.Object, java.lang.String)
     */
    public MessageHandler subscribe(String channelName, Object bean, String methodName) {
        Method method = ReflectionUtils.findMethod(bean.getClass(), methodName, new Class[] { Message.class });
        MessageHandler messageHandler = new MethodInvokingMessageHandler(bean, method);
        SubscribableChannel messageChannel = (SubscribableChannel) createChannel(channelName, true);
        messageChannel.subscribe(messageHandler);
        return messageHandler;
    }

    // ------ Defered Events ------

    /**
     * @see es.capgemini.devon.events.EventManager#saveOrUpdate(es.capgemini.devon.events.defered.DeferedEvent)
     */
    public void saveOrUpdate(DeferedEvent deferedEvent) {
        if (deferedEventDao != null) {
            deferedEventDao.saveOrUpdate(deferedEvent);
        } else {
            throw new DeferedEventException("events.defered.noDatastore");
        }
    }

    /**
     * @see es.capgemini.devon.events.EventManager#createDeferedEvent(java.lang.String, java.io.Serializable, java.lang.Long, java.util.Date)
     */
    public DeferedEvent createDeferedEvent(String queue, Serializable data, Long arrived, Date willProcess) {
        DeferedEvent job = deferedEventFactory.getNewInstance(queue, data.toString(), arrived, willProcess);
        saveOrUpdate(job);
        return job;
    }

    /**
     * @see es.capgemini.devon.events.EventManager#reQueueJobs(java.lang.String, java.util.Date)
     */
    @SuppressWarnings("unchecked")
    public void reQueueJobs(String channelName, Date before) {
        if (deferedEventDao != null) {
            List<DeferedEvent> events = deferedEventDao.findJobsToExecuteByName(channelName, before);
            for (DeferedEvent event : events) {
                if (logger.isDebugEnabled()) {
                    logger.debug("ReQueue in [" + event.getQueue() + "] with data [" + event.getData() + "]");
                }

                // Update deferedEvent
                event.setState(DeferedEventState.SENDED.getCode());
                event.setProcessed(new Date());
                deferedEventDao.saveOrUpdate(event);

                // Send the event to the queue
                GenericMessage message = new GenericMessage(event.getData());
                message.getHeaders().put(RETHROWED_KEY, "true");
                message.getHeaders().put(DEFERED_EVENT_KEY, event.getId().toString());
                // TODO Test 
                //                message.getHeader().setProperty(RETHROWED_KEY, "true");
                //                message.getHeader().setProperty(DEFERED_EVENT_KEY, event.getId().toString());
                fireEvent(event.getQueue(), message);
            }
        } else {
            throw new DeferedEventException("events.defered.noDatastore");
        }
    }

    /**
     * @param id
     * @param date
     */
    public void updateProcessDate(Long id, Date date) {
        if (deferedEventDao != null) {
            DeferedEvent event = deferedEventDao.get(id);
            if (event != null) {
                event.setProcessed(date);
                event.setState(DeferedEventState.RECEIVED.getCode());
                deferedEventDao.saveOrUpdate(event);
            }
        } else {
            throw new DeferedEventException("events.defered.noDatastore");
        }

    }

    public int getOrder() {
        return 1000;
    }

    public void setBeanFactory(BeanFactory beanFactory) {
        this.beanFactory = beanFactory;
    }
}
