package es.capgemini.devon.batch.tasks;

import java.io.File;
import java.util.zip.ZipFile;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.batch.BatchException;
import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;
import es.capgemini.devon.events.ErrorEvent;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.ZipUtils;

/**
 * @author Nicolás Cornaglia
 */
public class UnZipTasklet implements Tasklet, StepExecutionListener {

    private final Log logger = LogFactory.getLog(getClass());

    private String zipFileName;
    private String zipFilesToExtract;
    private String pathToExtract;
    private String bindings;
    private String message;
	private String severidad;
    @Autowired
    private EventManager eventManager;
    

    public ExitStatus execute() {

        ExitStatus status = null;
        try {
            ZipUtils.extract(new ZipFile(zipFileName), new File(pathToExtract), zipFilesToExtract);
        } catch (Exception e) {
        	EventBatchUtil.getInstance().throwEventErrorChannel(e, getSeveridad(), getMessage());
        	/*EventBatchUtil eUtil = new EventBatchUtil();
			eUtil.throwEventErrorChannel(e,
					getSeveridad(), getMessage());*/
            status = new ExitStatus(false, ExitStatus.FAILED.getExitCode(), e.toString());
        }
        if (status == null) {
            status = ExitStatus.FINISHED;
        }

        return status;
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
    	EventBatchUtil.getInstance().throwEventErrorChannel(e, getSeveridad(), getMessage());
    	/*EventBatchUtil eUtil = new EventBatchUtil();
		eUtil.throwEventErrorChannel(e,
				getSeveridad(), getMessage());*/
		return ExitStatus.FAILED;
    }

    public void setBindings(String bindings) {
        this.bindings = bindings;
    }

    /**
     * @param zipFileName the zipFileName to set
     */
    public void setZipFileName(String zipFileName) {
        this.zipFileName = zipFileName;
    }

    /**
     * @param zipFilesToExtract the zipFilesToExtract to set
     */
    public void setZipFilesToExtract(String zipFilesToExtract) {
        this.zipFilesToExtract = zipFilesToExtract;
    }

    /**
     * @param pathToExtract the pathToExtract to set
     */
    public void setPathToExtract(String pathToExtract) {
        this.pathToExtract = pathToExtract;
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

}
