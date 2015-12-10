package es.capgemini.devon.batch.tasks;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.sql.DataSource;

import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.dao.DataAccessException;

import es.capgemini.devon.batch.BatchException;
import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.devon.events.ErrorEvent;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.DatabaseUtils;
import es.capgemini.devon.utils.ResourceUtils;

/**
 * @author Nicolás Cornaglia
 * TODO: DOCUMENTAR!!! Agregar Javadoc a todos los metodos
 */
public abstract class DataLoaderTasklet implements Tasklet, StepExecutionListener {

    public static String IN_FILE_KEY = "inFile";

    private DataSource dataSource;
    private Resource resource;
    private String bindings;
    private String message;
    private String severidad;
    private Map<String, String> params = new HashMap<String, String>();

    private Resource[] resourceBeforeScripts = new ClassPathResource[] {};
    private Resource[] resourceAfterScripts = new ClassPathResource[] {};
    private String beforeScript = null;
    private String afterScript = null;

    @Autowired
    private EventManager eventManager;

    @javax.annotation.Resource
    protected Properties appProperties;

    /**
     * @see org.springframework.batch.core.step.tasklet.Tasklet#execute()
     */
    @Override
    public ExitStatus execute() throws DataAccessException, IOException {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put(IN_FILE_KEY, getResource().getFile().getName());

        DatabaseUtils.executeScript(dataSource, beforeScript, params, true, appProperties);
        DatabaseUtils.executeScripts(dataSource, resourceBeforeScripts, params, true, appProperties);

        ExitStatus exitStatus = executeInternal();

        DatabaseUtils.executeScripts(dataSource, resourceAfterScripts, params, true, appProperties);
        DatabaseUtils.executeScript(dataSource, afterScript, params, true, appProperties);

        return exitStatus;
    }

    public abstract ExitStatus executeInternal();

    public void setBeforeScripts(String scripts) {
        resourceBeforeScripts = ResourceUtils.getStringAsResources(scripts);
    }

    public void setBeforeScripts(String[] scripts) {
        resourceBeforeScripts = ResourceUtils.getStringsAsResources(scripts);
    }

    public void setAfterScripts(String scripts) {
        resourceAfterScripts = ResourceUtils.getStringAsResources(scripts);
    }

    public void setAfterScripts(String[] scripts) {
        resourceAfterScripts = ResourceUtils.getStringsAsResources(scripts);
    }

    /**
     * @param key
     * @return
     */
    public String getParameter(String key) {
        return params.get(key);
    }

    public String getParameter(String key, String def) {
        String result = getParameter(key);
        return result == null ? def : result;
    }

    /**
     * @param dataSource
     */
    @Required
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * @return
     */
    public DataSource getDataSource() {
        return dataSource;
    }

    @Override
    public ExitStatus afterStep(StepExecution stepExecution) {
        return null;
    }

    @Override
    public void beforeStep(StepExecution stepExecution) {
        ParameterBinder.bind(this, bindings, stepExecution.getJobParameters());
    }

    @Override
    public ExitStatus onErrorInStep(StepExecution stepExecution, Throwable e) {
        ErrorEvent ev = new ErrorEvent(new BatchValidationException(e, BatchException.SEVERIDAD_ERROR, "unZipFile.error"));
        eventManager.fireEvent(BatchException.ERROR_CHANNEL, ev);
        return null;
    }

    /**
     * @param bindings
     */
    public void setBindings(String bindings) {
        this.bindings = bindings;
    }

    /**
     * @param fullPath
     */
    public void setFileSystemResource(String fullPath) {
        setResource(new FileSystemResource(fullPath));
    }

    /**
     * @param resource
     */
    public void setResource(Resource resource) {
        this.resource = resource;
    }

    /**
     * @return the resource
     */
    public Resource getResource() {
        return resource;
    }

    /**
     * @return the params
     */
    public Map<String, String> getParams() {
        return params;
    }

    /**
     * @param params the params to set
     */
    public void setParams(Map<String, String> params) {
        this.params = params;
    }

    /**
     * @param beforeScript the beforeScript to set
     */
    public void setBeforeScript(String beforeScript) {
        this.beforeScript = beforeScript;
    }

    /**
     * @param afterScript the afterScript to set
     */
    public void setAfterScript(String afterScript) {
        this.afterScript = afterScript;
    }

    /**
     * @param appProperties the appProperties to set
     */
    public void setAppProperties(Properties appProperties) {
        this.appProperties = appProperties;
    }

    /**
     * Inyección del {@link EventManager} para gestión de eventos
     * 
     * @param eventManager 
     */
    public void setEventManager(EventManager eventManager) {
        this.eventManager = eventManager;
    }

    protected EventManager getEventManger() {
        return this.eventManager;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getSeveridad() {
        return severidad;
    }

    public void setSeveridad(String severidad) {
        this.severidad = severidad;
    }

}
