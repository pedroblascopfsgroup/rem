package es.capgemini.devon.bo.local;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.stereotype.Component;
import org.springframework.util.ReflectionUtils;

import es.capgemini.devon.bo.BusinessOperationDefinition;
import es.capgemini.devon.bo.BusinessOperationExecutor;
import es.capgemini.devon.bo.BusinessOperationRegistry;
import es.capgemini.devon.exception.ExceptionUtils;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.utils.StringUtils;

/**
 * TODO Documentar
 * 
 * @author Nicolás Cornaglia
 */
@Component
public class LocalBusinessOperationExecutor implements BusinessOperationExecutor {

    private final Log logger = LogFactory.getLog(getClass());

    Map<String, Object> targetsCache = new ConcurrentHashMap<String, Object>();

    @Autowired
    private BusinessOperationRegistry businessOperationRegistry;

    @Autowired
    private DefaultListableBeanFactory beanFactory;

    /**
     * @see es.capgemini.devon.bo.BusinessOperationExecutor#getType()
     */
    @Override
    public String getType() {
        return LocalOperationDefinition.TYPE;
    }

    /**
     * @see es.capgemini.devon.bo.BusinessOperationExecutor#execute(es.capgemini.devon.bo.BusinessOperationDefinition, java.lang.Object[])
     */
    @Override
    public Object execute(BusinessOperationDefinition def, Object[] args) {
        Object result = null;
        LocalOperationDefinition definition = (LocalOperationDefinition) def;
        if (logger.isDebugEnabled()) {
            LocalOperationDefinition realDefinition = (LocalOperationDefinition) businessOperationRegistry.get(def.getId());
            String realOperationName = realDefinition.getOverwrittenBy() == null ? null : realDefinition.getId();
            logger.debug("Executing BusinessOperation [" + definition.getId() + "] "
                    + (realOperationName == null ? "" : "(originally [" + realOperationName + "]) ") + "with ["
                    + StringUtils.arrayToCommaDelimitedString(args) + "]");
        }
        ReflectionUtils.makeAccessible(definition.getMethod());
        try {
            result = ReflectionUtils.invokeMethod(definition.getMethod(), getCachedTarget(definition), args);
        } catch (UserException e) {
            throw e;
        } catch (Exception e) {
            if (logger.isDebugEnabled()) {
                logger.debug(ExceptionUtils.getStackTraceAsString(e));
            }
            throw new FrameworkException(e);
        }
        return result;
    }

    /**
     * @param method
     * @param target
     * @param args
     * @return
     */
    public static Object invokeMethod(Method method, Object target, Object[] args) throws Exception {
        try {
            return method.invoke(target, args);
        } catch (InvocationTargetException ex) {
            ReflectionUtils.rethrowException(ex.getTargetException());
        }
        throw new IllegalStateException("Should never get here");
    }

    /**
     * @param id
     * @return
     */
    public Object getCachedTarget(LocalOperationDefinition definition) {
        Object bean = targetsCache.get(definition.getBeanName());
        if (bean == null) {
            bean = beanFactory.getBean(definition.getBeanName());
            targetsCache.put(definition.getBeanName(), bean);
        }
        return bean;
    }
}
