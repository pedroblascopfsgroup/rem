package es.capgemini.devon.events.router;

import java.util.List;

import org.springframework.integration.core.Message;

import es.capgemini.devon.events.Event;

/**
 * @author Nicolás Cornaglia
 */
public interface RouteStrategy {

    public List<String> getRoutes(Message<Event> message);

}
