package es.capgemini.devon.events.defered;

import java.io.Serializable;
import java.util.Date;

/**
 * TODO Documentar
 * 
 * @author Nicolás Cornaglia
 */
public interface DeferedEvent extends Serializable {

    public Date getWillProcess();

    public void setWillProcess(Date willProcess);

    public Date getProcessed();

    public void setProcessed(Date processed);

    public Long getId();

    public void setId(Long id);

    public Serializable getData();

    public void setData(Serializable data);

    public String getQueue();

    public void setQueue(String queue);

    public String getState();

    public void setState(String state);

    public Long getArrived();

    public void setArrived(Long arrived);

}
