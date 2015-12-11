package es.capgemini.devon.utils;

import java.lang.annotation.Annotation;
import java.lang.reflect.Method;

/**
 * @author Nicolás Cornaglia
 */
public class AnnotationUtils extends org.springframework.core.annotation.AnnotationUtils {

    /**
     * Basada en AnnotationUtils.findAnnotations(Method, Class<A>) de Spring, pero buscando anotaciones en los métodos de las interfaces si no se encuentra.
     */
    public static <A extends Annotation> A findAnnotation(Method method, Class<A> annotationType) {
        A annotation = org.springframework.core.annotation.AnnotationUtils.findAnnotation(method, annotationType);
        if (annotation != null) {
            return annotation;
        }
        Class<?> cl = method.getDeclaringClass();
        for (Class<?> ifc : cl.getInterfaces()) {
            try {
                Method equivalentMethod = ifc.getDeclaredMethod(method.getName(), method.getParameterTypes());
                annotation = getAnnotation(equivalentMethod, annotationType);
            } catch (NoSuchMethodException ex) {
                // We're done...
            }
            if (annotation != null) {
                break;
            }
        }
        return annotation;
    }

}
