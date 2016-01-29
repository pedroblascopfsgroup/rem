package es.capgemini.devon.files;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.scheduling.timer.MethodInvokingTimerTaskFactoryBean;
import org.springframework.stereotype.Service;

import es.capgemini.devon.utils.FileUtils;

/**
 * @author Nicolás Cornaglia
 */
@Service("fileManager")
public class FileManagerImpl implements FileManager {

    protected Log logger = LogFactory.getLog(getClass());

    private static final String TEMPORARY_PATH_KEY = "files.temporaryPath";
    private static final String TIME_TO_LIVE_KEY = "files.timeToLive";
    public static final String FILE_ITEM_KEY = "fileItem";

    // Instancia para acceso estático 
    private static FileManager instance;

    // Directorio donde ubicar los ficheros temporales, obtenido de appProperties
    private String temporaryPath;
    private File temporaryPathFile;
    // Colección de ficheros manejados actualmente por el manager
    private Map<UUID, FileItem> files = new HashMap<UUID, FileItem>();
    // Delete evicting files timer
    private Timer timer = null;
    // Tiempo default (en segundos) de evictTime para los ficheros
    private long temporaryFilesTimeToLive = 600L;
    // Delay inicial para las antes de la primera ejecución de "evictTemporaryFiles"
    private long evictTemporaryFilesDelay = 120L;
    // Tiempo entre ejecuciones de "evictTemporaryFiles"
    private long evictTemporaryFilesPeriod = 60L;

    @Resource
    private Properties appProperties;

    @PostConstruct
    public void init() {
        // Properties
        temporaryPath = appProperties.getProperty(TEMPORARY_PATH_KEY);
        temporaryFilesTimeToLive = Long.valueOf(appProperties.getProperty(TIME_TO_LIVE_KEY));
        // Temporary path
        temporaryPathFile = new File(temporaryPath);
        temporaryPathFile.mkdirs();
        FileUtils.deleteDirFiles(temporaryPathFile);
        // Static instance
        instance = this;
        // TimerTask to delete files
        MethodInvokingTimerTaskFactoryBean timerTask = new MethodInvokingTimerTaskFactoryBean();
        timerTask.setTargetObject(this);
        timerTask.setTargetMethod("evictTemporaryFiles");
        try {
            timerTask.afterPropertiesSet();
        } catch (ClassNotFoundException e) {
        } catch (NoSuchMethodException e) {
        }
        timer = new Timer(false);
        timer.schedule((TimerTask) timerTask.getObject(), evictTemporaryFilesDelay * 1000, evictTemporaryFilesPeriod * 1000);

    }

    /**
     * Acceso estático para clases no gestionadas por Spring
     * 
     * @return
     */
    public static FileManager getInstance() {
        return instance;
    }

    /**
     * @see es.capgemini.devon.files.FileManager#createTemporaryFileItem()
     */
    public FileItem createTemporaryFileItem() throws FileException {
        File file;
        try {
            file = File.createTempFile("rec_", ".tmp", temporaryPathFile);
            file.createNewFile();
        } catch (IOException e) {
            throw new FileException(e);
        }
        FileItem fileItem = new FileItem(file);
        registerTemporaryFile(fileItem, temporaryFilesTimeToLive);
        return fileItem;
    }

    /**
     * @see es.capgemini.devon.files.FileManager#deleteTemporaryFileItem(es.capgemini.devon.files.FileItem)
     */
    public boolean deleteTemporaryFileItem(FileItem fileItem) throws FileException {
        synchronized (this) {
            files.remove(fileItem.getId());
        }
        return fileItem.getFile().delete();
    }

    /**
     * @param fileItem
     * @param secondsToLive
     * @return
     */
    private FileItem registerTemporaryFile(FileItem fileItem, long secondsToLive) {
        fileItem.setEvictTime(System.currentTimeMillis() + secondsToLive * 1000);
        files.put(fileItem.getId(), fileItem);
        return fileItem;
    }

    /**
     * Borra los ficheros temporales en base a su "evictTime"
     */
    public void evictTemporaryFiles() {
        synchronized (this) {
            List<FileItem> toDelete = new ArrayList<FileItem>();
            for (FileItem fileItem : files.values()) {
                if (System.currentTimeMillis() > fileItem.getEvictTime()) {
                    toDelete.add(fileItem);
                }
            }
            for (FileItem fileItem : toDelete) {
                File file = fileItem.getFile();
                if (logger.isDebugEnabled()) {
                    logger.debug("Deleting evicted file " + file.getAbsolutePath());
                }
                boolean success = file.delete();
                if (!success) {
                    logger.error("Could not delete [" + file.getAbsolutePath() + "]");
                }
                files.remove(fileItem.getId());
            }
        }
    }

    /**
     * @return the temporaryPath
     */
    public String getTemporaryPath() {
        return temporaryPath;
    }

    /**
     * @param temporaryPath the temporaryPath to set
     */
    public void setTemporaryPath(String temporaryPath) {
        this.temporaryPath = temporaryPath;
    }

    /**
     * @return the appProperties
     */
    public Properties getAppProperties() {
        return appProperties;
    }

    /**
     * @param appProperties the appProperties to set
     */
    public void setAppProperties(Properties appProperties) {
        this.appProperties = appProperties;
    }

}
