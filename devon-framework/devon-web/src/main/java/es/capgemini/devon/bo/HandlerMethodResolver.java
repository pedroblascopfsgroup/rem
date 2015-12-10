package es.capgemini.devon.bo;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.util.ClassUtils;
import org.springframework.util.ReflectionUtils;

import es.capgemini.devon.bo.annotations.BusinessOperation;

/**
 * @author Nicolás Cornaglia
 */
public class HandlerMethodResolver {

    private Map<String, Method> handlerMethods = new HashMap<String, Method>();

    /**
     * Create a new HandlerMethodResolver for the specified handler type.
     * @param handlerType the handler class to introspect
     */
    public HandlerMethodResolver(final Class<?> handlerType) {
        ReflectionUtils.doWithMethods(handlerType, new ReflectionUtils.MethodCallback() {
            public void doWith(Method method) {
                if (method.isAnnotationPresent(BusinessOperation.class)) {
                    BusinessOperation annotation = AnnotationUtils.getAnnotation(method, BusinessOperation.class);
                    String value = (String) AnnotationUtils.getDefaultValue(annotation);
                    handlerMethods.put("".equals(value) ? method.getName() : value, ClassUtils.getMostSpecificMethod(method, handlerType));
                }
            }
        });
    }

    public Map<String, Method> getHandlerMethods() {
        return handlerMethods;
    }

    public Method getMethod(String id) {
        return handlerMethods.get(id);
    }

}
