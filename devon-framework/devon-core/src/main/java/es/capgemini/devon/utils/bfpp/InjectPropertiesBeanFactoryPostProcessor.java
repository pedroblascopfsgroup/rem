package es.capgemini.devon.utils.bfpp;

import java.util.Properties;

import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.PropertyValue;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.TypedStringValue;
import org.springframework.beans.factory.support.ManagedProperties;

/**
 * @author Nicolás Cornaglia
 */
public class InjectPropertiesBeanFactoryPostProcessor extends AbstractInjectionBeanFactoryPostProcessor {

    private String keyAttribute;

    /**
     * @see es.capgemini.devon.utils.bfpp.AbstractInjectionBeanFactoryPostProcessor#postProcessBeanName(org.springframework.beans.factory.config.ConfigurableListableBeanFactory, org.springframework.beans.PropertyValue, java.lang.String)
     */
    @Override
    public void postProcessBeanName(ConfigurableListableBeanFactory beanFactory, BeanDefinition beanDef, MutablePropertyValues propValues,
            PropertyValue whereToPlug, String beanName) {
        Object value = whereToPlug.getValue();
        if (!(value instanceof Properties))
            throw new IllegalArgumentException("Property is not an instanceof Property.");

        String key = (String) beanFactory.getBeanDefinition(beanName).getAttribute(keyAttribute);
        if (key == null) {
            throw new IllegalArgumentException("key not provided");
        } else {
            ((ManagedProperties) value).put(new TypedStringValue(key), new TypedStringValue(beanName));
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
        return new ManagedProperties();
    }

}
