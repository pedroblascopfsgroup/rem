package es.pfgroup.monioring.bach.load.persistence;

import java.io.File;
import java.util.Properties;

/**
 * Fichero en el que se quiere persistir los datos de ejecución.
 * 
 * @author bruno
 * 
 */
public class CheckStatusPersitentFile {
    
    private final Properties properties;
    
    private final File file;

    /**
     * Crea un wrapper para el fichero de persistencia
     * @param path Ruta del fichero
     */
    public CheckStatusPersitentFile(final String path) {
         properties = new Properties();
         file = new File(path);
    }

    public Properties getProperties() {
        return properties;
    }

    public File getFile() {
        return file;
    }

}
