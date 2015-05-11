package es.pfsgroup.plugin.recovery.coreextension.utils;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.commons.utils.Checks;

/**
 * Esta clase nos permite definir clases que representen el modelo a devolver
 * por una Operación de Negocio. Permite desde un plugin de personalización
 * personalizar el modelo devuelto por una operación de negocio sin modificarrla
 * ni extenderla.
 * 
 * <h3>Uso</h3>
 * <ul>
 * <li>Dentro de una operación de negocio usar el método
 * <code>getModelFor</code> para obtener la clase que debe representar al
 * modelo.</li>
 * <li>En un plugin de personalización escribir una clase que extienda la clase
 * por defecto para el modelo.</li>
 * <li>En
 * <code>devon.properties>/code> escribir en la propiedad <code>nombre_operacion_negocio.model</code>
 * el nombre completo de la nueva clase para el modelo.</li>
 * </ul>
 * 
 * 
 * @author bruno
 * 
 */
@Component
public class EXTModelClassFactory {

    @Resource
    private Properties appProperties;

    /**
     * Devuelve la clase de modelo definida para una operación de negocio.
     * 
     * @param boName
     *            Nombre de la operación de negocio. Buscará en las
     *            appProperties la propiedad
     *            <code>boname.<strong>model</strong></code>.
     * @param superClazz
     *            Clase que representa el modelo de la operación de negocio por
     *            defecto. Si no hay ninguna otra clase que la sustituya se
     *            devuelve esta.
     * @return
     */
    public <T> Class<? extends T> getModelFor(final String boName, final Class<T> superClazz) {
        final String className = appProperties.getProperty(boName + ".model");
        if (Checks.esNulo(className)) {
            return superClazz;
        } else {
            try {
                final Class clazz = Class.forName(className);
                if (superClazz.isAssignableFrom(clazz)) {
                    return clazz;
                } else {
                    throw new BusinessOperationException(className + " debe ser una subclase de " + superClazz.getName());
                }
            } catch (ClassNotFoundException e) {
                throw new BusinessOperationException(e);
            }
        }
    }
}
