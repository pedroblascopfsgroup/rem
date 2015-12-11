package es.capgemini.devon.utils;

import java.util.HashSet;
import java.util.Map;
import java.util.Properties;

import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;

/**
 * @author Nicolás Cornaglia
 */
public class PropertyPlaceholderUtils extends PropertyPlaceholderConfigurer {

    /**
     * @param strVal
     * @param props
     * @return
     */
    public static String resolve(String strVal, Properties props) {
        return resolve(strVal, props, false);
    }

    /**
     * @param strVal
     * @param props
     * @param visitedPlaceholders
     * @return
     */
    public static String resolve(String strVal, Properties props, boolean ignoreUnresolvablePlaceholders) {
        PropertyPlaceholderUtils p = new PropertyPlaceholderUtils();
        p.setIgnoreUnresolvablePlaceholders(ignoreUnresolvablePlaceholders);
        return p.resolveInternal(strVal, props);
    }

    /**
     * @param strVal
     * @param props
     * @return
     */
    public static String resolve(String strVal, Map<String, ?> props) {
        return resolve(strVal, props, false);
    }

    /**
     * @param strVal
     * @param props
     * @return
     */
    public static String resolve(String strVal, Map<String, ?> props, boolean ignoreUnresolvablePlaceholders) {
        Properties properties = new Properties();
        properties.putAll(props);
        return resolve(strVal, properties, ignoreUnresolvablePlaceholders);
    }

    private String resolveInternal(String strVal, Properties props) {
        return parseStringValue(strVal, props, new HashSet());
    }

}
