package es.capgemini.devon.services.property;

/**
 * OSGi service: 
 * <pre>
 * &lt;bean id="propertyService" class="es.capgemini.devon.services.property.impl.PropertyServiceImpl" init-method="init" destroy-method="destroy" lazy-init="false"&gt;
 *     &lt;property name="properties" ref="appProperties"/&gt;
 * &lt;/bean&gt;
 * &lt;osgi:service id="propertyServiceOsgi" 
 *       ref="propertyService"
 *       interface="es.capgemini.devon.services.property.PropertyService" /&gt;
 * </pre>
 *   
 * @author Nicolás Cornaglia
 */
public interface PropertyService {

    /**
     * @param key
     * @return
     */
    public abstract String getProperty(String key);

    /**
     * @param key
     * @param defaultValue
     * @return
     */
    public abstract String getProperty(String key, String defaultValue);

}