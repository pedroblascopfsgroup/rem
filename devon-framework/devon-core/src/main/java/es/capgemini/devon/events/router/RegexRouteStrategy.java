package es.capgemini.devon.events.router;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.integration.core.Message;

import es.capgemini.devon.events.Event;
import es.capgemini.devon.exception.FrameworkException;

/**
 * @author Nicolás Cornaglia
 */
public class RegexRouteStrategy implements RouteStrategy {

    private String source;
    private String match;
    private String search;
    private String replace;

    @Override
    public List<String> getRoutes(Message<Event> message) throws FrameworkException {
        List<String> routes = new ArrayList<String>();
        Event event = message.getPayload();

        String route = null;
        String value = null;
        try {
            // get value from expression.source
            value = PropertyUtils.getNestedProperty(event.getProperties(), source).toString();
        } catch (Exception e) {
            throw new FrameworkException(e);
        }
        // if matches with expression.match
        if (value.matches(match)) {
            // replace with expression.replace
            route = value.replaceAll(search, replace);
        }
        if (route != null) {
            routes.add(route);
        }

        return routes;
    }

    /**
     * @param source the source to set
     */
    public void setSource(String source) {
        this.source = source;
    }

    /**
     * @param match the match to set
     */
    public void setMatch(String match) {
        this.match = match;
    }

    /**
     * @param search the search to set
     */
    public void setSearch(String search) {
        this.search = search;
    }

    /**
     * @param replace the replace to set
     */
    public void setReplace(String replace) {
        this.replace = replace;
    }

}
