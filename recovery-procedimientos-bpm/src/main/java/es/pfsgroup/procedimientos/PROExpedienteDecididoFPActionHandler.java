package es.pfsgroup.procedimientos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

/**
 * Handler de decisión de un expediente que viene de Formalizar propuesta
 * @author cperez
 *
 */
public class PROExpedienteDecididoFPActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants{

	private static final long serialVersionUID = -3443273565873581680L;
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	public void run(ExecutionContext executionContext) throws Exception {
		 logger.debug("---------ENTRE EN ExpedienteDecididoFPActionHandler---------");
	        //Borra el timer en caso de que no se haya ejecutado
	        BPMUtils.deleteTimer(executionContext);

	        //Borra la tarea asociada a FP
	        Long idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_FP);
	        if (idTarea != null) {
	            proxyFactory.proxy(TareaNotificacionApi.class).borrarNotificacionTarea(idTarea);
	        }

	        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);

	        proxyFactory.proxy(TareaNotificacionApi.class).crearNotificacion(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
	                SubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_DECISION_TOMADA, null);

	        executionContext.getProcessInstance().signal();
		
	}
	
}
