package es.capgemini.devon.utils;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Properties;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanInitializationException;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;

/**
 * @author Nicolás Cornaglia
 */
public class RecursivePropertiesFactoryBean extends PropertyPlaceholderConfigurer implements FactoryBean {

    Properties mergedProps;

    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
        try {
            mergedProps = mergeProperties();

            // Convert the merged properties, if necessary.
            convertProperties(mergedProps);

            // Let the subclass process the properties.
            processProperties(beanFactory, mergedProps);
        } catch (IOException ex) {
            throw new BeanInitializationException("Could not load properties", ex);
        }
    }

    @SuppressWarnings("unchecked")
    @Override
    protected void processProperties(ConfigurableListableBeanFactory beanFactoryToProcess, Properties props) throws BeansException {
        // Pre-parse properties to hold the processed (de-nested) values.
        for (Enumeration e = mergedProps.keys(); e.hasMoreElements(); /**/) {
            String key = (String) e.nextElement();
            String value = mergedProps.getProperty(key);
            String newValue = parseStringValue(value, mergedProps, new HashSet());
            mergedProps.put(key, newValue);
        }
        super.processProperties(beanFactoryToProcess, props);
    }

    public Object getObject() throws Exception {
        return mergedProps;
    }

    public Class getObjectType() {
        return Properties.class;
    }

    public boolean isSingleton() {
        return true;
    }
}
