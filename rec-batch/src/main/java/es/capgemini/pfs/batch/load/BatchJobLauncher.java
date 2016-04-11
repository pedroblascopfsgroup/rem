package es.capgemini.pfs.batch.load;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.pfs.batch.common.FileHandler;
import es.capgemini.pfs.dsm.dao.EntidadDao;

/**
 * Todos los jobs deben implementar esta interfaz.
 * @author aesteban
 *
 */
public abstract class BatchJobLauncher extends FileHandler {

    private final Log logger = LogFactory.getLog(getClass());
    private static final String FILE_PATTER_REGEX = "20[0-1][0-9][0-1][0-9][0-3][0-9]";
    private File file;

    @Resource
    private EntidadDao entidadDao;

    /**
     * Obtiene un fichero de sem�foro, genera par�metros para el job y lo lanza.
     * @param file File
     *
     */
    public abstract void/*BatchExitStatus*/handle(File file);

    /**
     * Recupera la fecha del nombre del archivo.
     * @param fileName String
     * @return Date
     */
    protected Date getDateFromFile(String fileName) {
        try {
            Pattern p = Pattern.compile(FILE_PATTER_REGEX);
            Matcher m = p.matcher(fileName);
            m.find();
            SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
            return df.parse(m.group());
        } catch (Exception e) {
            logger.error("Error al parsear la fecha de entrada: " + fileName, e);
            return new Date();
        }
    }

    /**
     * setEntidadDao.
     * @param entidadDao entidadDao to set
     */
    public void setEntidadDao(EntidadDao entidadDao) {
        this.entidadDao = entidadDao;
    }

    /**
    * Completar quien sepa.
    * @param file File
    * @return boolean
    */
    protected boolean waitEndOfFile(File file) {
        logger.info("Verificando fin del fichero:" + file.getName());
        if (!file.exists()) {
            logger.error("El fichero " + file.getName() + " no existe");
            return false;
        }
        long length = file.length();
        long available = 0;
        FileInputStream fis = null;
        try {
            fis = new FileInputStream(file);
            available = fis.available();
        } catch (IOException e) {
            //Si ha dado en este punto la excepcion indica que el fichero no se ha terminado de copiar
            logger.warn("Problemas al leer el fichero: " + e.getMessage());
            try {
            	if(fis != null){
            		fis.close();
            	}
            } catch (Exception e1) {
            }
            //Esperamos 1/2 segundo he intentamos nuevamente
            try {
                Thread.sleep(500);
            } catch (InterruptedException e1) {
                logger.error(e1);
            }
            waitEndOfFile(file);
        } finally {
            try {
            	if(fis != null){
            		fis.close();
            	}
            } catch (Exception e1) {
            }
        }

        if (available < length) {
            //Indica que el fichero no se ha terminadod e copiar
            //Esperamos 1/2 segundo he intentamos nuevamente
            logger.info("El fichero no se ha completado. Posee: " + available + ", de un total de: " + length);
            try {
                Thread.sleep(500);
            } catch (InterruptedException e1) {
                logger.error(e1);
            }
            waitEndOfFile(file);
        } else {
            logger.info("El fichero " + file.getName() + " esta 100% disponible para ser procesado");
        }

        //Este punto indica que la comprobacion ha sido correcta
        return true;
    }

    /**
     * @return the entidadDao
     */
    public EntidadDao getEntidadDao() {
        return entidadDao;
    }

    /**
     * @return the file
     */
    public File getFile() {
        return file;
    }

    /**
     * @param file the file to set
     */
    public void setFile(File file) {
        this.file = file;
    }

}
