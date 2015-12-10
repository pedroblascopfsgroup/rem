package es.capgemini.devon.beans;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.FrameworkException;

/**
 * Elimina las definiciones de beans sobreescritas por una extensión y pone un alias al bean de la extensión.
 * Ej.: Si existe un bean @Service("salaManager") y una extensión tiene el bean @Service(overrides="salaManager"), 
 * se elimina el bean "salaManager" original y se agrega el alias "salaManager" al segundo bean
 * 
 * @author Nicolás Cornaglia
 */
@Component
public class ExtensionsBeanFactoryPostProcessor implements BeanFactoryPostProcessor {

    private final Log logger = LogFactory.getLog(getClass());

    private ClassLoader classLoader = DefaultResourceLoader.class.getClassLoader();

    /**
     * @see org.springframework.beans.factory.config.BeanFactoryPostProcessor#postProcessBeanFactory(org.springframework.beans.factory.config.ConfigurableListableBeanFactory)
     */
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactoryToProcess) throws BeansException {
        DefaultListableBeanFactory beanFactory = (DefaultListableBeanFactory) beanFactoryToProcess;
        String[] beanNames = beanFactory.getBeanDefinitionNames();
        for (String beanName : beanNames) {
            BeanDefinition bd = beanFactory.getBeanDefinition(beanName);
            if (bd != null && bd.getBeanClassName() != null) {
                Class<?> clazz = null;
                try {
                    clazz = classLoader.loadClass(bd.getBeanClassName());
                } catch (ClassNotFoundException e) {
                    logger.error("Bean: "+bd.getBeanClassName()+", Resource: "+bd.getResourceDescription(), e);
                    throw new FrameworkException(e);
                }
                if (clazz.isAnnotationPresent(Service.class)) {
                    Service annotation = AnnotationUtils.findAnnotation(clazz, Service.class);
                    String overrides = "".equals(annotation.overrides()) ? null : annotation.overrides();
                    if (overrides != null) {
                        if (logger.isDebugEnabled()) {
                            logger.debug("Overriding '" + overrides + "' with '" + beanName + "'.");
                        }
                        if (!beanFactory.containsBeanDefinition(overrides)) {
                            String alias = beanFactory.getAliases(overrides)[0];
                            logger.error("Bean '" + overrides + "' already overridden with '" + alias + "'");
                            throw new FrameworkException("fwk.extensions.beanAlreadyOverridden", new Object[] { overrides, alias });
                        }
                        beanFactory.removeBeanDefinition(overrides);
                        beanFactory.removeBeanDefinition(beanName);
                        beanFactory.registerBeanDefinition(overrides, bd);
                        //beanFactory.registerAlias(beanName, overrides);
                    }
                }

            }

        }

    }
}
