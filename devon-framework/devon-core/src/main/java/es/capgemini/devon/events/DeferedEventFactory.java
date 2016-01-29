package es.capgemini.devon.events;

import java.io.Serializable;
import java.util.Date;

import es.capgemini.devon.events.defered.DeferedEvent;

/**
 * @author Nicolás Cornaglia
 */
public interface DeferedEventFactory {

    public DeferedEvent getNewInstance();

    public DeferedEvent getNewInstance(String queue, Serializable data, Long arrived, Date willProcess);

}
