package es.capgemini.devon.events;

import java.io.Serializable;
import java.util.Hashtable;
import java.util.Map;
import java.util.UUID;

/**
 * @author Nicolás Cornaglia
 */
public class GenericEvent implements Serializable, Event {

    private static final long serialVersionUID = 1L;

    protected Map<String, Serializable> properties = new Hashtable<String, Serializable>();
    protected String id = getUUID();
    protected long time = System.currentTimeMillis();

    //    protected Usuario user = SecurityInfoManager.getCurrentUser();

    /**
     * Default constructor
     */
    public GenericEvent() {
    }

    /**
     * @param properties
     */
    public GenericEvent(Map properties) {
        if (properties != null) {
            this.properties = properties;
        }
    }

    private static synchronized String getUUID() {
        return UUID.randomUUID().toString();
    }

    /**
     * @see es.capgemini.devon.events.Event#getProperty(java.lang.String)
     */
    public Serializable getProperty(String key) {
        return properties.get(key);
    }

    /**
     * @see es.capgemini.devon.events.Event#getPropertyAsString(java.lang.String)
     */
    public String getPropertyAsString(String key) {
        return (String) properties.get(key);
    }

    /**
     * @see es.capgemini.devon.events.Event#getPropertyAsLong(java.lang.String)
     */
    public Long getPropertyAsLong(String key) {
        return (Long) properties.get(key);
    }

    /**
     * @see es.capgemini.devon.events.Event#getPropertyAsFloat(java.lang.String)
     */
    public Float getPropertyAsFloat(String key) {
        return (Float) properties.get(key);
    }

    /**
     * @see es.capgemini.devon.events.Event#getPropertyAsFloat(java.lang.String)
     */
    public Double getPropertyAsDouble(String key) {
        return (Double) properties.get(key);
    }

    /**
     * @see es.capgemini.devon.events.Event#setProperty(java.lang.String, java.io.Serializable)
     */
    public void setProperty(String key, Serializable value) {
        properties.put(key, value);
    }

    // Getters/Setters

    /**
     * @see es.capgemini.devon.events.Event#getTime()
     */
    public long getTime() {
        return time;
    }

    /**
     * @see es.capgemini.devon.events.Event#getId()
     */
    public String getId() {
        return id;
    }

    /**
     * @see es.capgemini.devon.events.Event#getProperties()
     */
    public Map getProperties() {
        return properties;
    }

    @Override
    public String toString() {
        StringBuffer buffer = new StringBuffer();
        buffer.append("id [").append(id).append("] time[").append(time).append("]");
        for (Map.Entry entry : properties.entrySet()) {
            buffer.append(" [").append(entry.getKey()).append(":").append(entry.getValue()).append("]");
        }
        return buffer.toString();
    }

    /**
     * @see es.capgemini.devon.events.Event#setProperties(java.util.Map)
     */
    @Override
    public void setProperties(Map properties) {
        this.properties = properties;
    }

    //    public Usuario getUser() {
    //        return user;
    //    }

}
