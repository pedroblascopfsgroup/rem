package es.capgemini.devon.utils.bfpp;

import java.util.Map;

import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.PropertyValue;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.RuntimeBeanReference;
import org.springframework.beans.factory.config.TypedStringValue;
import org.springframework.beans.factory.support.ManagedMap;

/**
 * @author Nicolás Cornaglia
 */
public class InjectMapBeanFactoryPostProcessor extends AbstractInjectionBeanFactoryPostProcessor {

    private String keyAttribute;

    /**
     * @see es.capgemini.devon.utils.bfpp.AbstractInjectionBeanFactoryPostProcessor#postProcessBeanName(org.springframework.beans.factory.config.ConfigurableListableBeanFactory, org.springframework.beans.PropertyValue, java.lang.String)
     */
    @Override
    public void postProcessBeanName(ConfigurableListableBeanFactory beanFactory, BeanDefinition beanDef, MutablePropertyValues propValues,
            PropertyValue whereToPlug, String beanName) {
        Object value = whereToPlug.getValue();
        if (!(value instanceof Map))
            throw new IllegalArgumentException("Property is not an instanceof Map.");

        String key = (String) beanFactory.getBeanDefinition(beanName).getAttribute(keyAttribute);
        if (key == null) {
            throw new IllegalArgumentException("key not provided");
        } else {
            ((ManagedMap) value).put(new TypedStringValue(key), new RuntimeBeanReference(beanName));
        }

    }

    /**
     * @param keyAttribute
     */
    public void setKeyAttribute(String keyAttribute) {
        this.keyAttribute = keyAttribute;
    }

    /**
     * @see es.capgemini.devon.utils.bfpp.AbstractInjectionBeanFactoryPostProcessor#getUndefinedPropertyObject()
     */
    @Override
    public Object getUndefinedPropertyObject() {
        return new ManagedMap();
    }

}
