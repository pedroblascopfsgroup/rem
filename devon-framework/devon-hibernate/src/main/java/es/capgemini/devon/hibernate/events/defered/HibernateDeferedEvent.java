package es.capgemini.devon.hibernate.events.defered;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import es.capgemini.devon.events.defered.DeferedEvent;
import es.capgemini.devon.events.defered.DeferedEventState;

/**
 * TODO Documentar
 * 
 * @author Nicolás Cornaglia
 */
@Entity
@Table(name = "DeferedEvent")
public class HibernateDeferedEvent implements DeferedEvent {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Serializable data;
    private String queue;
    private String state = DeferedEventState.NEW.getCode();
    private Long arrived;
    private Date willProcess;
    private Date processed;

    public Date getWillProcess() {
        return willProcess;
    }

    public void setWillProcess(Date willProcess) {
        this.willProcess = willProcess;
    }

    public Date getProcessed() {
        return processed;
    }

    public void setProcessed(Date processed) {
        this.processed = processed;
    }

    public HibernateDeferedEvent() {
    }

    public HibernateDeferedEvent(String queue, Serializable data, Long arrived, Date willProcess) {
        this.queue = queue;
        this.data = data;
        this.arrived = arrived;
        this.willProcess = willProcess;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DeferedEventGenerator")
    @SequenceGenerator(name = "DeferedEventGenerator", sequenceName = "DeferedEvent_Seq")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Serializable getData() {
        return data;
    }

    public void setData(Serializable data) {
        this.data = data;
    }

    public String getQueue() {
        return queue;
    }

    public void setQueue(String queue) {
        this.queue = queue;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    /**
     * @return the arrived
     */
    public Long getArrived() {
        return arrived;
    }

    /**
     * @param arrived the arrived to set
     */
    public void setArrived(Long arrived) {
        this.arrived = arrived;
    }

}
