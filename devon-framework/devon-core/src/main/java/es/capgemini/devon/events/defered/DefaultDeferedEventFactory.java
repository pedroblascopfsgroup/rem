package es.capgemini.devon.events.defered;

import java.io.Serializable;
import java.util.Date;

import es.capgemini.devon.events.DeferedEventFactory;

/**
 * @author Nicolás Cornaglia
 */
public class DefaultDeferedEventFactory implements DeferedEventFactory {

    public DefaultDeferedEventFactory() {
    }

    public DeferedEvent getNewInstance() {
        return new DefaultDeferedEvent();
    }

    public DeferedEvent getNewInstance(String queue, Serializable data, Long arrived, Date willProcess) {
        return new DefaultDeferedEvent(queue, data, arrived, willProcess);
    }
}