package es.capgemini.devon.events.defered;

import java.io.Serializable;
import java.util.Date;


/**
 * @author Nicolás Cornaglia
 */
public class DefaultDeferedEvent implements DeferedEvent {

    private static final long serialVersionUID = 1L;
    private Long id;
    private Serializable data;
    private String queue;
    private String state;
    private Long arrived;
    private Date willProcess;
    private Date processed;

    public DefaultDeferedEvent() {
        state = DeferedEventState.NEW.getCode();
    }

    public DefaultDeferedEvent(String queue, Serializable data, Long arrived, Date willProcess) {
        state = DeferedEventState.NEW.getCode();
        this.queue = queue;
        this.data = data;
        this.arrived = arrived;
        this.willProcess = willProcess;
    }

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

    public Long getArrived() {
        return arrived;
    }

    public void setArrived(Long arrived) {
        this.arrived = arrived;
    }
}