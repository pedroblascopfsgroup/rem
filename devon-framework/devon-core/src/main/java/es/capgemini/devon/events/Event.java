package es.capgemini.devon.events;

import java.io.Serializable;
import java.util.Map;

public interface Event extends Serializable {

    public static final String MESSAGE_KEY = "MESSAGE";

    public static final String SCOPE_KEY = "SCOPE";

    public abstract Serializable getProperty(String key);

    public abstract String getPropertyAsString(String key);

    public abstract Long getPropertyAsLong(String key);

    public abstract Float getPropertyAsFloat(String key);

    public abstract Double getPropertyAsDouble(String key);

    public abstract void setProperty(String key, Serializable value);

    public abstract long getTime();

    public abstract String getId();

    public abstract Map getProperties();

    public abstract void setProperties(Map properties);

}