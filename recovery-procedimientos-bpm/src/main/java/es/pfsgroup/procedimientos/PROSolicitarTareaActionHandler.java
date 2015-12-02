package es.pfsgroup.procedimientos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.ComunicacionBPM;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

public class PROSolicitarTareaActionHandler extends JbpmActionHandler implements TareaBPMConstants{

	private static final long serialVersionUID = 4625913629939597734L;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private IntegracionBpmService integracionBPMService;
	
	public void run(ExecutionContext executionContext) throws Exception {
		if (logger.isDebugEnabled()) {
            logger.debug("EJECUTANDO SolicitarTareaActionHandler");
        }
        //Debo crear la tarea
        Long idEntidad = (Long) executionContext.getVariable(ID_ENTIDAD_INFORMACION);
        String tipoEntidad = (String) executionContext.getVariable(CODIGO_TIPO_ENTIDAD);
        String codigoSubtipoTarea = (String) executionContext.getVariable(CODIGO_SUBTIPO_TAREA);
        Long plazo = (Long) executionContext.getVariable(PLAZO_PROPUESTA);
        Boolean espera = proxyFactory.proxy(JBPMProcessApi.class).getFixeBooleanValue(executionContext, ESPERA);
        if (espera == null) {
            espera = true;
        }

        String descripcion = (String) executionContext.getVariable(DESCRIPCION_TAREA);
        DtoGenerarTarea dto = new DtoGenerarTarea(idEntidad, tipoEntidad, codigoSubtipoTarea, espera, false, plazo, descripcion);
        Long idTarea = proxyFactory.proxy(TareaNotificacionApi.class).crearTarea(dto);

        Prorroga prorroga = (Prorroga) executionContext.getVariable(PRORROGA_ASOCIADA);
        ComunicacionBPM comunicacion = (ComunicacionBPM) executionContext.getVariable(COMUNICACION_BPM);
        //Seteo la prorroga y la comunicacion en caso de que corresponda
        TareaNotificacion tarea = proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea);
        tarea.setProrroga(prorroga);
        tarea.setComunicacionBPM(comunicacion);
        proxyFactory.proxy(TareaNotificacionApi.class).saveOrUpdate(tarea);
        executionContext.setVariable(ID_TAREA, idTarea);

        // Envía la notificación para que sea informada
        integracionBPMService.notificaTarea(tarea);
        
        executionContext.getProcessInstance().signal(TRANSITION_TAREA_SOLICITADA);
		
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
