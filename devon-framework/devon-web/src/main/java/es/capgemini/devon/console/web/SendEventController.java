package es.capgemini.devon.console.web;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.events.Event;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.events.EventScope;
import es.capgemini.devon.events.UserChannel;
import es.capgemini.devon.events.WebEventsSubscriptor;

/**
 * @author Nicolás Cornaglia
 */
@Controller
public class SendEventController {

    @Resource
    EventManager eventManager;

    @RequestMapping("sendEvent.htm")
    public String sendEvent(@RequestParam("message") String message, @RequestParam(required = false, value = "username") final String username,
            ModelMap model) {
        if (username == null || "".equals(username)) {
            Map<String, Serializable> globalProperties = new HashMap<String, Serializable>() {
                {
                    put(Event.SCOPE_KEY, EventScope.GLOBAL);
                }
            };
            eventManager.fireEvent(WebEventsSubscriptor.USER_CHANNEL, message, globalProperties);
        } else {
            Map<String, Serializable> userProperties = new HashMap<String, Serializable>() {
                {
                    put(Event.SCOPE_KEY, EventScope.USER);
                    put(UserChannel.USERS_KEY, username);
                }
            };
            eventManager.fireEvent(WebEventsSubscriptor.USER_CHANNEL, message, userProperties);
        }
        return "";
    }
}
