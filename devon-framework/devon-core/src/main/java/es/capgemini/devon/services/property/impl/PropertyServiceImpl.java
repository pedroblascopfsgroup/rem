package es.capgemini.devon.services.property.impl;

import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.services.property.PropertyService;

/**
 * @author Nicolás Cornaglia
 */
public class PropertyServiceImpl implements PropertyService {

    private final Log logger = LogFactory.getLog(getClass());
    private Properties properties;

    public PropertyServiceImpl() {
    }

    public void init() {
        logger.debug("Init propertyService");
    }

    public void destroy() {
        logger.debug("Destroy propertyService");
    }

    /**
     * @see es.capgemini.devon.services.property.PropertyService#getProperty(java.lang.String)
     */
    public String getProperty(String key) {
        return properties.getProperty(key);
    }

    /**
     * @see es.capgemini.devon.services.property.PropertyService#getProperty(java.lang.String, java.lang.String)
     */
    public String getProperty(String key, String defaultValue) {
        String val = getProperty(key);
        return val != null ? val : defaultValue;
    }

    public Properties getProperties() {
        return properties;
    }

    public void setProperties(Properties properties) {
        this.properties = properties;
    }

}