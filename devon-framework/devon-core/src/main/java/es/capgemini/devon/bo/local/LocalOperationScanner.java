package es.capgemini.devon.bo.local;

import java.beans.Introspector;
import java.lang.reflect.Method;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.stereotype.Service;
import org.springframework.util.ReflectionUtils;

import es.capgemini.devon.bo.BusinessOperationDefinition;
import es.capgemini.devon.bo.BusinessOperationScanner;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.registry.DefaultRegistry;
import es.capgemini.devon.utils.AnnotationUtils;

/**
 * Registro de operaciones de negocio locales (implementadas como beans, con la anotación @BusinessOperation
 * 
 * @author Nicolás Cornaglia
 * @See {@link BusinessOperation}
 */
@Service
public class LocalOperationScanner extends DefaultRegistry<BusinessOperationDefinition> implements BusinessOperationScanner {

    private final Log logger = LogFactory.getLog(getClass());

    private ClassLoader classLoader = DefaultResourceLoader.class.getClassLoader();

    @Autowired
    private DefaultListableBeanFactory beanFactory;

    /**
     * @see es.capgemini.devon.bo.BusinessOperationScanner#scan()
     */
    public Map<String, BusinessOperationDefinition> scan() {

        String[] beanNames = beanFactory.getBeanDefinitionNames();
        for (String name : beanNames) {
            final String beanName = name;
            BeanDefinition bd = null;
            try {
                bd = beanFactory.getBeanDefinition(beanName);
            } catch (BeansException e) {
                throw new FrameworkException(e);
            }
            if (bd != null && bd.getBeanClassName() != null) {
                Class<?> clazz = null;
                try {
                    clazz = classLoader.loadClass(bd.getBeanClassName());
                } catch (ClassNotFoundException e) {
                    throw new FrameworkException(e);
                }
                ReflectionUtils.doWithMethods(clazz, new ReflectionUtils.MethodCallback() {

                    public void doWith(Method method) {
                        BusinessOperation annotation = AnnotationUtils.findAnnotation(method, BusinessOperation.class);
                        if (annotation != null) {
                            // Get the Operation name
                            String operationId = annotation.value();
                            if ("".equals(operationId)) {
                                operationId = beanName + "." + Introspector.decapitalize(method.getName());
                            }

                            String overrides = "".equals(annotation.overrides()) ? null : annotation.overrides();
                            if (get(operationId) == null) {
                                put(operationId, new LocalOperationDefinition(operationId, beanName, method, overrides));
                                if (logger.isDebugEnabled()) {
                                    logger.debug("Registered local business operation '" + operationId + " [" + beanName + "."
                                            + method.toGenericString() + "]");
                                }
                            } else {
                                throw new FrameworkException("fwk.bo.businessOperationDefinitionAlreadyExists", operationId);
                            }
                        }
                    }
                });
            }
        }
        if (logger.isInfoEnabled()) {
            logger.info("Registered ["+this.getObjectsRegistry().size()+"] local business operations");
        }

        return this.getObjectsRegistry();

    }

}
