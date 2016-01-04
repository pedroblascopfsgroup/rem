package es.capgemini.devon.hibernate.events.defered;

import java.io.Serializable;
import java.util.Date;

import org.springframework.stereotype.Component;

import es.capgemini.devon.events.DeferedEventFactory;
import es.capgemini.devon.events.defered.DeferedEvent;

/**
 * @author Nicolás Cornaglia
 */
@Component("deferedEventFactory")
public class HibernateDeferedEventFactory implements DeferedEventFactory {

    public DeferedEvent getNewInstance() {
        return new HibernateDeferedEvent();
    }

    public DeferedEvent getNewInstance(String queue, Serializable data, Long arrived, Date willProcess) {
        return new HibernateDeferedEvent(queue, data, arrived, willProcess);
    }

}
