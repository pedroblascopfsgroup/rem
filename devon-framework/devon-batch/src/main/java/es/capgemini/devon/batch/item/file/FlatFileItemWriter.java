package es.capgemini.devon.batch.item.file;

import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.item.file.mapping.DefaultFieldSet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;
import es.capgemini.devon.events.EventManager;

/**
 * @author Nicolás Cornaglia
 */
public class FlatFileItemWriter extends org.springframework.batch.item.file.FlatFileItemWriter implements StepExecutionListener {

    private String bindings;
    private String message;
    private String severidad;
    private boolean trim = false;

    @Autowired
    private EventManager eventManager;

    @Override
    public void write(Object data) throws Exception {

        if (isTrim()) {
            DefaultFieldSet fields = (DefaultFieldSet) data;

            int size = fields.getFieldCount();
            for (int i = 0; i < size; i++) {
                fields.getValues()[i] = fields.getValues()[i].trim();
            }
        }

        super.write(data);
    }

    @SuppressWarnings("unchecked")
    @Override
    public void beforeStep(StepExecution stepExecution) {
        ParameterBinder.bind(this, bindings, stepExecution.getJobParameters());
    }

    @Override
    public ExitStatus afterStep(StepExecution stepExecution) {
        return null;
    }

    @Override
    public ExitStatus onErrorInStep(StepExecution stepExecution, Throwable e) {
        /*EventBatchUtil eUtil = new EventBatchUtil();
        eUtil.throwEventErrorChannel(e,
        		getSeveridad(), getMessage());*/
        EventBatchUtil.getInstance().throwEventErrorChannel(e, getSeveridad(), getMessage());
        return ExitStatus.FAILED;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        // El "resource" ahora puede venir vacío en la configuración, no usar los assert del padre.
    }

    public void setBindings(String bindings) {
        this.bindings = bindings;
    }

    public void setFileSystemResource(String fullPath) {
        setResource(new FileSystemResource(fullPath));
    }

    @Override
    public void setResource(Resource resource) {
        super.setResource(resource);
    }

    /**
     * Inyección del {@link EventManager} para gestión de eventos
     * 
     * @param eventManager 
     */
    public void setEventManager(EventManager eventManager) {
        this.eventManager = eventManager;
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

    public void setTrim(boolean trim) {
        this.trim = trim;
    }

    public boolean isTrim() {
        return trim;
    }
}
