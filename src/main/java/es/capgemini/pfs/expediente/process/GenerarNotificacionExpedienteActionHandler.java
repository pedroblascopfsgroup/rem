package es.capgemini.pfs.expediente.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * Genera Las notificaciones del proceso de expediente.
 * @author jbosnjak
 *
 */
@Component
public class GenerarNotificacionExpedienteActionHandler extends JbpmActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

    @Autowired
    private TareaNotificacionManager notificacionManager;

    /**
     * Las variables boolean en jbpm se almacenan como String T/F.
     * @param executionContext
     * @return
     */
    private boolean generaAlerta(ExecutionContext executionContext) {
        return JBPMProcessManager.getFixeBooleanValue(executionContext, GENERAALERTA);
    }

    /**
     * Este metodo crea la notificacion y vuelve al proceso que lo invoco.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        logger.debug("---------ENTRE EN GenerarNotificacionExpedienteActionHandler---------");

        String whereToGo = (String) executionContext.getVariable(WHERE_TO_GO);

        Long idTarea = null;
        try {
            if (generaAlerta(executionContext)) {
                if (whereToGo.equals(COMPLETAR_EXPEDIENTE)) {
                    //debo activar la alerta para la tarea de completar expediente
                    idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_CE);
                } else if (whereToGo.equals(REVISION_EXPEDIENTE)) {
                    //debo activar la alerta para la tarea de revisar expediente
                    idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_RE);
                } else if (whereToGo.equals(DECISION_COMITE)) {
                    //debo activar la alerta para la tarea de decision comite
                    idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_DC);
                }

                //Parche por si la tarea no existe (versión de Fase 1)
                if (idTarea != null) {
                    TareaNotificacion tarea = notificacionManager.get(idTarea);
                    tarea.setAlerta(Boolean.TRUE);
                    notificacionManager.saveOrUpdate(tarea);
                }
            }
        } catch (Exception e) {
            //Se pone la exception por si tira un error y no se ve en la consola
            logger.error("Error al generar la notificacion", e);
        }
        executionContext.getProcessInstance().signal(whereToGo);
    }
}
