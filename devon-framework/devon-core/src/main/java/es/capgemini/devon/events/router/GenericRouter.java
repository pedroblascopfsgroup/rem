package es.capgemini.devon.events.router;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.integration.annotation.MessageEndpoint;
import org.springframework.integration.annotation.Router;
import org.springframework.integration.core.Message;

import es.capgemini.devon.events.Event;

/**
 * @author Nicolás Cornaglia
 */
@MessageEndpoint
public class GenericRouter {

    public static String ROUTING_CHANNEL = "routingChannel";

    private List<RouteStrategy> routeStrategies = new ArrayList<RouteStrategy>();

    @Router(inputChannel = "routingChannel")
    public List<String> handle(Message<Event> message) {
        Set<String> routes = new HashSet<String>();

        for (RouteStrategy strategy : routeStrategies) {
            List<String> thisRoutes = strategy.getRoutes(message);
            routes.addAll(thisRoutes);
        }

        return new ArrayList<String>(routes);
    }

    /**
     * @param routeStrategies the routeStrategies to set
     */
    public void setRouteStrategies(List<RouteStrategy> routeStrategies) {
        this.routeStrategies = routeStrategies;
    }

}
