package es.pfsgroup.plugin.recovery.coreextension.utils;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Component;

/**
 * Clase que permite genear el <code>select</code> de una quey HQL en base a los
 * campos que tiene una determinada clase.
 * 
 * @author bruno
 * 
 */
@Component
public class EXTHQLFieldsSelector {

    /**
     * Permite genear el <code>select</code> de una quey HQL en base a los
     * campos que tiene una determinada clase.
     * 
     * @param clazz
     *            Clase que contiene los campos sobre los que queremso hacer
     *            select.
     * @param alias
     *            Alias que queremos que tenga la clase
     * @param typesAllowed
     *            Lista de tipos permitidos, s�lo se incluir�n en la select los
     *            campos cuyos tipos est�n especificados aqu�.
     * @return
     */
    public StringBuilder selectAllFields(final Class clazz, final String alias, List<? extends Class> typesAllowed) {
        final StringBuilder builder = new StringBuilder("select distinct ");

        final List<Field> fields = getAllFields(clazz);
        String separator = "";
        if ((fields != null)) {
            for (Field f : fields) {
                int modifiers = f.getModifiers();
                if ((typesAllowed.contains(f.getType())) && (!Modifier.isTransient(modifiers) && (!Modifier.isStatic(modifiers)))) {
                    builder.append(separator).append(alias).append(".").append(f.getName()).append(" as ").append(f.getName());
                    separator = ", ";
                }
            }
        }

        return builder;
    }

    /**
     * Devuelve todos los campos de la clase, incluyendo los de las superclases.
     * 
     * @param clazz
     * @return
     */
    private List<Field> getAllFields(final Class clazz) {
        final ArrayList<Field> fields = new ArrayList<Field>();
        final List<Class> clases = getClassesInOrder(clazz);
        Field[] declared;
        for (Class myClass : clases) {
            declared = myClass.getDeclaredFields();
            if (declared != null) {
                fields.addAll(Arrays.asList(declared));
            }
            myClass = myClass.getSuperclass();
        }
        return fields;
    }

    /**
     * Devuelve toda la jerarqu�a de clases ordenadas de modo que la padre est�
     * primero.
     * 
     * @param clazz
     * @return
     */
    private List<Class> getClassesInOrder(final Class clazz) {
        final ArrayList<Class> clases = new ArrayList<Class>();
        Class myClass = clazz;
        while ((myClass != null) && (myClass != Object.class)) {
            clases.add(myClass);
            myClass = myClass.getSuperclass();
        }
        Collections.reverse(clases);
        return clases;
    }
}
