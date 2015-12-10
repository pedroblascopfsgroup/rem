package es.capgemini.devon.events.router;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;

import es.capgemini.devon.events.Event;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.scripting.groovy.GroovyEvaluator;

/**
 * @author Nicolás Cornaglia
 */
public class GroovyRouteStrategy implements RouteStrategy {

    private String script;

    @Autowired
    private GroovyEvaluator groovyEvaluator;

    @SuppressWarnings("unchecked")
    @Override
    public List<String> getRoutes(Message<Event> message) throws FrameworkException {
        List<String> routes = new ArrayList<String>();
        Event event = message.getPayload();

        Object result = groovyEvaluator.evaluate(script, event.getProperties());

        if (result instanceof String) {
            routes.add((String) result);
        } else if (result instanceof List) {
            routes.addAll((List) result);
        }

        return routes;
    }

    /**
     * @param script the script to set
     */
    public void setScript(String script) {
        this.script = script;
    }

    /**
     * @param groovyEvaluator the groovyEvaluator to set
     */
    public void setGroovyEvaluator(GroovyEvaluator groovyEvaluator) {
        this.groovyEvaluator = groovyEvaluator;
    }

}
