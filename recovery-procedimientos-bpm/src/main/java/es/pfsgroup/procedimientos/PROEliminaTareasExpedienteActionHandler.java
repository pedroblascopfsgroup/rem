package es.pfsgroup.procedimientos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.pfsgroup.recovery.api.TareaNotificacionApi;

/**
 * Esta clase se encarga de terminar todas las tareas del expediente.
 *
 * @author jbosnjak
 *
 */
public class PROEliminaTareasExpedienteActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    

    private static final long serialVersionUID = 1L;

    /**
     * Este metodo debe llamar a la creacion del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("EliminaTareasExpedienteActionHandler......");
        }
        
        TareaNotificacionApi tareaNotificacionManager = proxyFactory.proxy(TareaNotificacionApi.class);
        
        // Borra el timer en caso de que no se haya ejecutado
        BPMUtils.deleteTimer(executionContext);

        // Borra la tarea asociada a CE
        Long idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_CE);
        if (idTarea != null) {
            tareaNotificacionManager.borrarNotificacionTarea(idTarea);
        }

        // Borra la tarea asociada a RE
        idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_RE);
        if (idTarea != null) {
            tareaNotificacionManager.borrarNotificacionTarea(idTarea);
        }

        // Borra la tarea asociada a DC
        idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_DC);
        if (idTarea != null) {
            tareaNotificacionManager.borrarNotificacionTarea(idTarea);
        }

    }
}
