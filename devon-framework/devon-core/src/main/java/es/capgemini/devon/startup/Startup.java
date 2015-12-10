package es.capgemini.devon.startup;

import java.util.Arrays;
import java.util.Comparator;
import java.util.PriorityQueue;

import javax.annotation.PostConstruct;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.ContextStartedEvent;

import es.capgemini.devon.events.EventManager;

/**
 * @author Nicolás Cornaglia
 */
public class Startup implements ApplicationListener {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    Initializable[] initializables;

    @Autowired
    EventManager eventManager;

    /**
     * Initializes the applicacion
     */
    @PostConstruct
    public void init() {
        logger.info("Startup begin");

        PriorityQueue<Initializable> orderedInitializables = new PriorityQueue<Initializable>(25, new Comparator<Initializable>() {

            @Override
            public int compare(Initializable o1, Initializable o2) {
                return (o1.getOrder() < o2.getOrder()) ? -1 : (o1.getOrder() > o2.getOrder()) ? 1 : 0;
            }

        });
        orderedInitializables.addAll(Arrays.asList(initializables));

        Initializable initializable = null;
        while ((initializable = orderedInitializables.poll()) != null) {
            logger.info("Initializing [" + initializable.getOrder() + "] [" + initializable + "]");
            initializable.initialize();
        }

        logger.info("Startup end");
    }

    @Override
    public void onApplicationEvent(ApplicationEvent event) {
        if (event instanceof ContextStartedEvent) {
            logger.info("Spring context started!");
        } else if (event instanceof ContextRefreshedEvent) {
            logger.debug("Spring context refreshed!");
        }
    }

}
