package es.capgemini.devon.utils.bfpp;

import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.PropertyValue;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.RuntimeBeanReference;

/**
 * @author Nicolás Cornaglia
 */
public class InjectBeanBeanFactoryPostProcessor extends AbstractInjectionBeanFactoryPostProcessor {

    /**
     * @see es.capgemini.devon.utils.bfpp.AbstractInjectionBeanFactoryPostProcessor#postProcessBeanName(org.springframework.beans.factory.config.ConfigurableListableBeanFactory, org.springframework.beans.PropertyValue, java.lang.String)
     */
    @Override
    public void postProcessBeanName(ConfigurableListableBeanFactory beanFactory, BeanDefinition beanDef, MutablePropertyValues propValues,
            PropertyValue whereToPlug, String beanName) {

        propValues.addPropertyValue(new PropertyValue(whereToPlug.getName(), new RuntimeBeanReference(beanName)));
    }

    /**
     * @see es.capgemini.devon.utils.bfpp.AbstractInjectionBeanFactoryPostProcessor#getUndefinedPropertyObject()
     */
    @Override
    public Object getUndefinedPropertyObject() {
        // FIXME
        return null; //new ManagedBean();
    }

}
