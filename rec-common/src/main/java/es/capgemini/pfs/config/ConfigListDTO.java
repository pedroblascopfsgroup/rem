package es.capgemini.pfs.config;

import java.io.Serializable;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

/**
 * @author Nicolás Cornaglia
 */
public class ConfigListDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String key;

    /**
     * Constructor vacio.
     */
    public ConfigListDTO() {
    }

    /**
     * Constructor.
     * @param key String
     */
    public ConfigListDTO(String key) {
        this.key = key;
    }

    /**
     * @return the key
     */
    public String getKey() {
        return key;
    }

    /**
     * @param key the key to set
     */
    public void setKey(String key) {
        this.key = key;
    }

    /**
     * Valida que el key no sea nulo.
     * @param context MessageContext
     */
    public void validateStart(MessageContext context) {
        if (getKey() == null) {
            context.addMessage(new MessageBuilder().error().source("key").defaultText("Key must be not null").build());
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }

}
