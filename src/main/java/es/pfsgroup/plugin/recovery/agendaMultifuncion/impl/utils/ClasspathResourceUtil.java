package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.utils;

import java.io.InputStream;

/**
 * Interfaz que nos permite obtener recursos del classpath.
 * 
 * @author bruno
 * 
 */
public interface ClasspathResourceUtil {

    /**
     * Devuelve como un InputStream el contenido de cualquier fichero del classpath
     * @param resourceName
     * @return
     */
    InputStream getResourceAsStream(String resourceName);
}
