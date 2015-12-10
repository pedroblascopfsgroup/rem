package es.capgemini.devon.utils;

import java.lang.reflect.Field;

/**
 * Clase de utileria para trabajo con objetos de tipo Class
 * 
 * @author lgiavedo
 */
public class ClassUtils {

    private ClassUtils() {
    }

    /**
     * Metodo encargado de verificar si una clase tiene un propiedad de un tipo determinada con 
     * una anotacion determinada
     * 
     * @param toInspect clase sobre la que quiero realizar la inspección
     * @param fieldType clase de la propiedad que estoy intentando determinar
     * @param annotation clase de la anotacion que estoy intentando determinar
     * @return true si la clase tiene una propiedade del tipo especificado con una anotacion del tipo especificado
     *         false sin la clase no tiene una propiedad del tipo especificado con una anotacion del tipo especificado
     */
    public static boolean containsFieldType(final Class toInspect, final Class fieldType, final Class annotation) {
        Field[] fields = toInspect.getDeclaredFields();
        for (int i = 0; i < fields.length; i++) {
            if (fields[i].getType().equals(fieldType)) {
                if (fieldContainsAnntation(fields[i], annotation)) return true;
            }
        }
        return false;
    }

    /**
     * Metodo encargado de verificar si un field contiene un tipo de anotacion determinado
     * 
     * @param field field que quiero verificar
     * @param annotation antacion por la que quiero comparar
     * @return true si el field contiene la anotacion
     *         false si el field no contiene la anotacion 
     */
    public static boolean fieldContainsAnntation(final Field field, final Class annotation) {
        return field.getAnnotation(annotation) != null ? true : false;
    }
}
