package es.capgemini.devon.events;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.annotation.MessageEndpoint;
import org.springframework.integration.annotation.Router;
import org.springframework.integration.core.Message;
import org.springframework.integration.core.MessageChannel;
import org.springframework.stereotype.Service;

/**
 * @author Nicolás Cornaglia
 */
@Service
@MessageEndpoint
public class WebEventsSubscriptor {

    public static final String USER_CHANNEL = "usersChannel";

    private final Log logger = LogFactory.getLog(getClass());

    List<Event> events = Collections.synchronizedList(new LinkedList<Event>());
    private Map<String, MessageChannel> userChannels = new HashMap<String, MessageChannel>();

    @Resource
    EventManager eventManager;

    @Autowired
    UserChannel userChannel;

    public void addUserChannel(String userName, MessageChannel messageChannel) {
        userChannels.put(userName, messageChannel);
    }

    /**
     * @param userName
     */
    public void removeUserChannel(String userName, String messageChannel) {
        userChannels.remove(userName);
        eventManager.destroyChannel(messageChannel);
    }

    @Router(inputChannel = USER_CHANNEL)
    public List<String> handle(Message<Event> message) {
        List<String> routes = new ArrayList<String>();
        Event event = message.getPayload();
        EventScope scope = (EventScope) event.getProperty(Event.SCOPE_KEY);

        // Global Messages
        if (scope != null && scope.equals(EventScope.GLOBAL)) {
            for (String messageChannel : userChannels.keySet()) {
                routes.add(userChannels.get(messageChannel).getName());
            }
            if (logger.isDebugEnabled()) {
                logger.debug("routing: " + message.getHeaders().getTimestamp() + ": " + message.getPayload());// + " to " + routes);
            }
        } else if (scope != null && scope.equals(EventScope.USER)) {
            String usersToSend = (String) event.getProperty(UserChannel.USERS_KEY);
            String[] users = usersToSend.split(",");
            for (String user : users) {
                MessageChannel messageChannel = userChannels.get(user);
                if (messageChannel != null) {
                    routes.add(messageChannel.getName());
                }
            }
        }
        return routes;
    }

    public List<Event> receive() {
        return eventManager.receive(userChannel.getMessageChannel());
    }

    public void setEventManager(EventManager eventManager) {
        this.eventManager = eventManager;
    }

    public void setUserChannel(UserChannel userChannel) {
        this.userChannel = userChannel;
    }

}
