package es.pfsgroup.procedimientos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

public class PROTareaCompletadaActionHandler extends JbpmActionHandler implements TareaBPMConstants{

	private static final long serialVersionUID = -5984482623180849995L;
	
	 private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private IntegracionBpmService integracionBPMService;
	
	public void run(ExecutionContext executionContext) throws Exception {
		if (logger.isDebugEnabled()){
    		logger.debug("EJECUTANDO TareaCompletadaActionHandler");
    	}
    	Long idTarea = (Long)executionContext.getVariable(ID_TAREA);
    	proxyFactory.proxy(TareaNotificacionApi.class).borrarNotificacionTarea(idTarea);
    	
    	TareaNotificacion tarea = proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea);
    	integracionBPMService.notificaTarea(tarea);
    	
    	executionContext.getProcessInstance().signal(TRANSITION_FIN);
	}
	
	@Override
	public void execute(ExecutionContext executionContext) throws Exception {
		DbIdContextHolder.setDbId((Long) executionContext.getVariable(DbIdContextHolder.DB_ID));
        run(executionContext);
	}

	@Override
	public void run() throws Exception {
		String message = "INVOCACION INCORRECTA: deber�a haberse ejecutado run(ExecutionContext)";
		logger.fatal(message);
		throw new IllegalAccessError(message);
	}

}
