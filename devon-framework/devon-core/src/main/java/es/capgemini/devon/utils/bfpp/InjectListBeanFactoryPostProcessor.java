package es.capgemini.devon.utils.bfpp;

import java.util.List;

import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.PropertyValue;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.RuntimeBeanReference;
import org.springframework.beans.factory.support.ManagedList;

/**
 * @author Nicolás Cornaglia
 */
public class InjectListBeanFactoryPostProcessor extends AbstractInjectionBeanFactoryPostProcessor {

    /**
     * @see es.capgemini.devon.utils.bfpp.AbstractInjectionBeanFactoryPostProcessor#postProcessBeanName(org.springframework.beans.factory.config.ConfigurableListableBeanFactory, org.springframework.beans.PropertyValue, java.lang.String)
     */
    @Override
    public void postProcessBeanName(ConfigurableListableBeanFactory beanFactory, BeanDefinition beanDef, MutablePropertyValues propValues,
            PropertyValue whereToPlug, String beanName) {
        Object value = whereToPlug.getValue();
        if (!(value instanceof List))
            throw new IllegalArgumentException("Property is not an instanceof List.");

        ((List) value).add(new RuntimeBeanReference(beanName));

    }

    /**
     * @see es.capgemini.devon.utils.bfpp.AbstractInjectionBeanFactoryPostProcessor#getUndefinedPropertyObject()
     */
    @Override
    public Object getUndefinedPropertyObject() {
        return new ManagedList();
    }

}
