package es.capgemini.devon.utils;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

/**
 */
@Component
public class PropertyUtils {

    private static Properties properties;

    public static Properties getAppProperties() {
        return properties;
    }

    @Resource
    public void setAppProperties(Properties appProperties) {
        properties = appProperties;
    }

    public static String getProperty(String key) {
        return properties.getProperty(key);
    }

    public static String getProperty(String key, String defaultValue) {
        String val = getProperty(key);
        return (val == null) ? defaultValue : val;
    }

}
