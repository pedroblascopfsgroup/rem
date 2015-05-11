package es.capgemini.pfs.batch.common;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.batch.BatchManager;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.devon.utils.TimeUtils;
import es.capgemini.pfs.batch.files.Constants;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.JobRunner;

/**
 * @author Nicolás Cornaglia
 */
public abstract class FileHandler implements Constants, JobRunner {

    @Autowired
    private JobController jobManager;

    /**
     * Se hace un autowired del batchManager.
     */
    @Autowired
    private BatchManager batchManager;

    /**
     * Se hace un autowired del eventManager.
     */
    @Autowired
    private EventManager eventManager;

    /**
     * Se hace un autowired del appProperties.
     */
    @Resource
    private Properties appProperties;

    /**
     * Parametro window.
     */
    private long window;

    /**
     * Parametro channel.
     */
    private String channel;

    /**
     * Parametro cronExpression.
     */
    private String cronExpression;

    /**
     * Borra el fichero del subdirectorio de backup y luego lo mueve al
     * subdirectorio. modified by pamuller / aesteban.
     * @param file Nombre del zip file
     * @param path Path del file
     */
    protected final void backupFile(String file, String path) {
        String backupFile = path + File.separator + getAppProperty(BATCH_FILE_BACKUPSUBDIR) + file.substring(file.lastIndexOf(File.separator));
        deleteFile(backupFile);
        FileUtils.moveFile(file, path + File.separator + getAppProperty(BATCH_FILE_BACKUPSUBDIR));
    }

    /**
     * Intenta borrar un fichero y lanza un error si no puede.
     * @param file
     *            Fichero a borrar
     */
    protected final void deleteFile(String file) {
        try {
            FileUtils.deleteFile(file);
        } catch (IOException e) {
            getEventManager().fireEvent(EventManager.ERROR_CHANNEL, new FrameworkException(e));
        }
    }

    /**
     * Obtiene el working code de la entidad del nombre del fichero.
     * @param fileName nombre del fichero.
     * @param semaphorePattern patron del semaforo
     * @return working code de la entidad
     */
    protected final String getWorkingCodeFromFileName(String fileName, String semaphorePattern) {
        // Get workingCode from semaphore fileName
        String workingCodePattern = getAppProperty(BATCH_FILES_WORKINGCODE_PATTERN);
        String workingCodePlaceholder = getAppProperty(BATCH_FILES_WORKINGCODE_PLACEHOLDER);
        return getRegexGroup(fileName, semaphorePattern.replace(workingCodePlaceholder, "(" + workingCodePattern + ")"), 1);
    }

    /**
     * Obtiene una key de las propiedades de la aplicación, obtenidos del bean
     * "appProperties".
     * @param key String
     * @return key
     */
    protected String getAppProperty(String key) {
        return getAppProperties().getProperty(key);
    }

    /**
     * Obtiene una key de las propiedades de la aplicación, obtenidos del bean
     * "appProperties".
     * @param key String
     * @param defaultValue String
     * @return key
     */
    protected String getAppProperty(String key, String defaultValue) {
        return getAppProperties().getProperty(key, defaultValue);
    }

    /**
     * Devuelve una secuencia capturada de hacer un "match" en una expresión.
     * regex Ej.:
     * <pre>
     * String s = getRegexGroup(&quot;TRADE-1001-20080521.sem&quot;,
     * &quot;TRADE-[0-9][0-9][0-9][0-9]-YYYYMMDD.sem&quot;, 1)
     * assertEquals(s, &quot;1001&quot;)
     * </pre>
     * @see Pattern
     * @see Matcher
     * @param source String
     * @param pattern String
     * @param group int
     * @return String
     */
    protected String getRegexGroup(String source, String pattern, int group) {
        Pattern p = Pattern.compile(pattern);
        Matcher m = p.matcher(source);
        m.find();
        return m.group(group);
    }

    /**
     * Decide si la fecha que recibida como parametro es menor
     * o igual a la actual.
     * @param date Fecha Parametro
     * @return Fecha propuesta
     */
    protected Date shouldProcessOn(Date date) {
        return TimeUtils.shouldProcessOn(date, getWindow(), getCronExpression());
    }

    /**
     * setBatchManager.
     * @param batchManager BatchManager
     */
    public void setBatchManager(BatchManager batchManager) {
        this.batchManager = batchManager;
    }

    /**
     * setAppProperties.
     * @param appProperties Properties
     */
    public void setAppProperties(Properties appProperties) {
        this.appProperties = appProperties;
    }

    /**
     * getBatchManager.
     * @return BatchManager
     */
    public BatchManager getBatchManager() {
        return batchManager;
    }

    /**
     * getEventManager.
     * @return EventManager
     */
    public EventManager getEventManager() {
        return eventManager;
    }

    /**
     * getAppProperties.
     * @return Properties
     */
    public Properties getAppProperties() {
        return appProperties;
    }

    /**
     * setEventManager.
     * @param eventManager EventManager
     */
    public void setEventManager(EventManager eventManager) {
        this.eventManager = eventManager;
    }

    /**
     * getWindow.
     * @return long
     */
    public long getWindow() {
        return window;
    }

    /**
     * setWindow.
     * @param window long
     */
    public void setWindow(long window) {
        this.window = window;
    }

    /**
     * getBatchManager.
     * @return BatchManager
     */
    public String getChannel() {
        return channel;
    }

    /**
     * setChannel.
     * @param channel String
     */
    public void setChannel(String channel) {
        this.channel = channel;
    }

   

    /**
     * getCronExpression.
     * @return the cronExpression
     */
    public String getCronExpression() {
        return cronExpression;
    }

    /**
     * setCronExpression.
     * @param cronExpression
     *            the cronExpression to set
     */
    public void setCronExpression(String cronExpression) {
        this.cronExpression = cronExpression;
    }

    /**
     * @return the jobManager
     */
    public JobController getJobManager() {
        return jobManager;
    }

    /**
     * @param jobManager the jobManager to set
     */
    public void setJobManager(JobController jobManager) {
        this.jobManager = jobManager;
    }

}
