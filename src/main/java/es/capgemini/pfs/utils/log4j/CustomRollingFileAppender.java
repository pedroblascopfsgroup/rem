package es.capgemini.pfs.utils.log4j;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.RollingFileAppender;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 *
 */
public class CustomRollingFileAppender extends RollingFileAppender {

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * @param file String
     */
    @Override
    public void setFile(String file) {
        boolean windows = false;
        boolean linux = false;
        //Determinando el SO
        String so = System.getProperty("os.name");
        if (so == null) {
            logger.error("Imposible determinar el SO. Variable {os.name} = null");
        } else {
            linux = so.toLowerCase().indexOf("linux") != -1;
            windows = so.toLowerCase().indexOf("windows") != -1;

            //Obtenemos la ruta convirtinedo las variables
            String adaptedFile = getFullFile(file);

            //linux?
            if (linux) {
                if (!adaptedFile.startsWith("/")) {
                    //Solo se permiten path absolutos
                    adaptedFile = "/" + adaptedFile;
                }
            }
            //windows?
            /*if (windows) {
                //De momento no es necesario modificar nada mas
            }*/
            super.setFile(adaptedFile);
        }

        //No se ha podido determianr el so
        if (!linux && !windows) {
            logger.error("No se ha determinado configuracion para el SO: " + so);
            super.setFile(file);
        }

    }

    private String getFullFile(String file) {
        if (file.indexOf('{') != -1) {
            int indexI = file.indexOf('{') + 1;
            int indexF = indexI + file.substring(indexI).indexOf("}");
            String var = file.substring(indexI, indexF);
            String value = System.getenv(var);
            file = file.substring(0, indexI - 1) + value + file.substring(indexF + 1);
        }
        if (file.indexOf('{') != -1) {
            getFullFile(file);
        }
        return file;
    }

}
