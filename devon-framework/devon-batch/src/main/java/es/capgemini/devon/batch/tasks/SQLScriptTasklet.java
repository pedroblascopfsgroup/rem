package es.capgemini.devon.batch.tasks;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.devon.batch.BatchException;
import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;
import es.capgemini.devon.events.ErrorEvent;
import es.capgemini.devon.events.EventManager;

/**
 * @author Nicol�s Cornaglia
 */
public class SQLScriptTasklet implements Tasklet, StepExecutionListener {

    private final Log logger = LogFactory.getLog(getClass());

    private String bindings;
    private DataSource dataSource;
    private String script;
    private String message;
	private String severidad;
    
    @Autowired
    private EventManager eventManager;

    /**
     * Execute the SQL
     * 
     * @see org.springframework.batch.core.step.tasklet.Tasklet#execute()
     */
    public ExitStatus execute() {

        try {
            JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
            jdbcTemplate.execute(script);
        } catch (Exception e) {
        	/*EventBatchUtil eUtil = new EventBatchUtil();
			eUtil.throwEventErrorChannel(e,
					getSeveridad(), getMessage());*/
        	EventBatchUtil.getInstance().throwEventErrorChannel(e, getSeveridad(), getMessage());
    		return ExitStatus.FAILED;
        }

        return ExitStatus.FINISHED;
    }

    @Required
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
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

    public void setScript(String script) {
        this.script = script;
    }
    
    /**
     * Inyecci�n del {@link EventManager} para gesti�n de eventos
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
