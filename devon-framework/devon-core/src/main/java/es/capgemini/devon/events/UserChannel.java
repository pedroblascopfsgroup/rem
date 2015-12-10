package es.capgemini.devon.events;

import java.io.Serializable;
import java.util.UUID;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.springframework.beans.factory.DisposableBean;
import org.springframework.context.annotation.Scope;
import org.springframework.integration.channel.PollableChannel;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import es.capgemini.devon.security.SecurityUtils;

/**
 * Genera una cola de mensajes para este usuario.
 * 
 * FIXME Quitar la cola generada cuando el ususario pierda la sesión. ver UserCounterListener
 * 
 * @author Nicolás Cornaglia
 */
@Component
@Scope("session")
public class UserChannel implements Serializable, DisposableBean {

    public static String USER_CHANNEL_PREFIX = "userChannel_";
    public static String USERS_KEY = "users";

    @Resource
    EventManager eventManager;

    @Resource
    WebEventsSubscriptor webEventsSubscriptor;

    String userName = null;
    String channelName = null;

    private PollableChannel messageChannel = null;

    @PostConstruct
    public void initialize() {

        UserDetails usuario = SecurityUtils.getCurrentUser();
        if (usuario == null)
            return;

        userName = usuario.getUsername();
        channelName = USER_CHANNEL_PREFIX + UUID.randomUUID().toString();

        messageChannel = eventManager.createPollableChannel(channelName);
        webEventsSubscriptor.addUserChannel(userName, messageChannel);
        eventManager.fireEvent(channelName, "Messages activated for user [" + userName + "]");
    }

    public PollableChannel getMessageChannel() {
        return messageChannel;
    }

    public void destroy() throws Exception {
        webEventsSubscriptor.removeUserChannel(userName, channelName);
    }

}
