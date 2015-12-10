package es.capgemini.devon.utils.bfpp;

import java.util.List;
import java.util.regex.Pattern;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.PropertyValue;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;

/**
 * @author Nicolás Cornaglia
 */
public abstract class AbstractInjectionBeanFactoryPostProcessor implements BeanFactoryPostProcessor {

    private final Log logger = LogFactory.getLog(getClass());

    private String extensionBeanName;
    private String propertyName;

    private List<String> values;
    private String pattern;
    private Class clazz;
    private boolean optional = false;

    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
        if (extensionBeanName == null || !beanFactory.containsBeanDefinition(extensionBeanName))
            throw new IllegalArgumentException("Cannot find bean " + extensionBeanName);

        BeanDefinition beanDef = beanFactory.getBeanDefinition(extensionBeanName);
        MutablePropertyValues propValues = beanDef.getPropertyValues();
        if (propertyName == null) {
            throw new IllegalArgumentException("Must expecify property name for bean " + extensionBeanName);
        }
        if (!propValues.contains(propertyName)) {
            propValues.addPropertyValue(propertyName, getUndefinedPropertyObject());
        }

        PropertyValue pv = propValues.getPropertyValue(propertyName);
        if (values != null) {
            postProcessBeanNames(beanFactory, beanDef, propValues, pv);
        } else if (pattern != null) {
            postProcessPattern(beanFactory, beanDef, propValues, pv);
        } else if (clazz != null) {
            postProcessClazz(beanFactory, beanDef, propValues, pv);
        } else {
            throw new IllegalArgumentException("Must expecify [values|pattern|clazz] for bean " + extensionBeanName);
        }
    }

    public abstract Object getUndefinedPropertyObject();

    /**
     * @param beanFactory
     * @param whereToPlug
     */
    private void postProcessBeanNames(ConfigurableListableBeanFactory beanFactory, BeanDefinition beanDef, MutablePropertyValues propValues,
            PropertyValue whereToPlug) {
        for (String beanName : getValues()) {
            if (!optional && !beanFactory.containsBeanDefinition(beanName)) {
                throw new IllegalArgumentException("Cannot find bean " + beanName);
            }
            logger.info("Plugging in [" + beanName + "] into [" + extensionBeanName + "." + propertyName + "]");
            postProcessBeanName(beanFactory, beanDef, propValues, whereToPlug, beanName);
        }
    }

    /**
     * @param beanFactory
     * @param whereToPlug
     */
    private void postProcessPattern(ConfigurableListableBeanFactory beanFactory, BeanDefinition beanDef, MutablePropertyValues propValues,
            PropertyValue whereToPlug) {
        if ("".equals(pattern.trim()))
            throw new IllegalArgumentException("Pattern not provided");
        Pattern p = Pattern.compile(pattern);

        for (String beanName : beanFactory.getBeanDefinitionNames()) {
            if (p.matcher(beanName).matches()) {
                logger.debug("Plugging in " + beanName + " into bean:" + extensionBeanName + " property:" + propertyName);
                postProcessBeanName(beanFactory, beanDef, propValues, whereToPlug, beanName);
            }
        }
        if (beanFactory.getParentBeanFactory() != null) {
            postProcessPattern((ConfigurableListableBeanFactory) beanFactory.getParentBeanFactory(), beanDef, propValues, whereToPlug);
        }

    }

    /**
     * @param beanFactory
     * @param whereToPlug
     */
    private void postProcessClazz(ConfigurableListableBeanFactory beanFactory, BeanDefinition beanDef, MutablePropertyValues propValues,
            PropertyValue whereToPlug) {

        for (String beanName : beanFactory.getBeanNamesForType(clazz, false, false)) {
            logger.debug("Plugging in " + beanName + " into bean:" + extensionBeanName + " property:" + propertyName);
            postProcessBeanName(beanFactory, beanDef, propValues, whereToPlug, beanName);
        }
        if (beanFactory.getParentBeanFactory() != null) {
            postProcessClazz((ConfigurableListableBeanFactory) beanFactory.getParentBeanFactory(), beanDef, propValues, whereToPlug);
        }

    }

    /**
     * @param beanFactory
     * @param beanDef
     * @param propValues
     * @param whereToPlug
     * @param value
     */
    public abstract void postProcessBeanName(ConfigurableListableBeanFactory beanFactory, BeanDefinition beanDef, MutablePropertyValues propValues,
            PropertyValue whereToPlug, String value);

    /**
     * @return the extensionBeanName
     */
    public String getExtensionBeanName() {
        return extensionBeanName;
    }

    /**
     * @param extensionBeanName the extensionBeanName to set
     */
    public void setExtensionBeanName(String extensionBeanName) {
        this.extensionBeanName = extensionBeanName;
    }

    /**
     * @return the propertyName
     */
    public String getPropertyName() {
        return propertyName;
    }

    /**
     * @param propertyName the propertyName to set
     */
    public void setPropertyName(String propertyName) {
        this.propertyName = propertyName;
    }

    /**
     * @return the values
     */
    public List<String> getValues() {
        return values;
    }

    /**
     * @param values the values set
     */
    public void setValues(List<String> values) {
        this.values = values;
    }

    /**
     * @return the pattern
     */
    public String getPattern() {
        return pattern;
    }

    /**
     * @param pattern the pattern to set
     */
    public void setPattern(String pattern) {
        this.pattern = pattern;
    }

    public boolean isOptional() {
        return optional;
    }

    public void setOptional(boolean optional) {
        this.optional = optional;
    }

    /**
     * @return the clazz
     */
    public Class getClazz() {
        return clazz;
    }

    /**
     * @param clazz the clazz to set
     */
    public void setClazz(Class clazz) {
        this.clazz = clazz;
    }

}
