package es.capgemini.devon.bo.local;

import java.lang.reflect.Method;

import es.capgemini.devon.bo.BusinessOperationDefinition;

/**
 * Business Operation implemented in this applicaction as a local bean.
 * 
 * @author Nicolás Cornaglia
 */
public class LocalOperationDefinition implements BusinessOperationDefinition {

    public static final String TYPE = "LOCAL";

    private String id;
    private String beanName;
    private Method method;
    private String overrides;
    private String overwrittenBy;

    public LocalOperationDefinition(String id, String beanName, Method method) {
        this(id, beanName, method, null);
    }

    public LocalOperationDefinition(String id, String beanName, Method method, String overrides) {
        this.id = id;
        this.beanName = beanName;
        this.method = method;
        this.overrides = overrides;
    }

    /**
     * @see es.capgemini.devon.bo.BusinessOperationDefinition#getType()
     */
    @Override
    public String getType() {
        return TYPE;
    }

    /**
     * @see es.capgemini.devon.bo.BusinessOperationDefinition#getId()
     */
    public String getId() {
        return id;
    }

    /**
     * @see es.capgemini.devon.bo.BusinessOperationDefinition#getOverwrittenBy()
     */
    public String getOverwrittenBy() {
        return overwrittenBy;
    }

    /**
     * @see es.capgemini.devon.bo.BusinessOperationDefinition#setOverwrittenBy(java.lang.String)
     */
    public void setOverwrittenBy(String overwrittenBy) {
        this.overwrittenBy = overwrittenBy;
    }

    /**
     * @see es.capgemini.devon.bo.BusinessOperationDefinition#getOverrides()
     */
    public String getOverrides() {
        return overrides;
    }

    public String getBeanName() {
        return beanName;
    }

    public Method getMethod() {
        return method;
    }

}
