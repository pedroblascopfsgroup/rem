package es.pfsgroup.procedimientos.expediente.deuda;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.recovery.api.TareaNotificacionApi;

/**
 * Genera Las notificaciones del proceso de expediente.
 * @author jbosnjak
 *
 */
public class PROGenerarNotificacionExpedienteDeudaActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

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
    public void run(ExecutionContext executionContext) throws Exception {
        logger.debug("---------ENTRE EN GenerarNotificacionExpedienteDeudaActionHandler---------");
        
        TareaNotificacionApi notificacionManager = proxyFactory.proxy(TareaNotificacionApi.class);

        String whereToGo = (String) executionContext.getVariable(WHERE_TO_GO);

        Long idTarea = null;
        try {
            if (generaAlerta(executionContext)) {
                if (whereToGo.equals(COMPLETAR_EXPEDIENTE) || whereToGo.equals(TRANSITION_ENVIARAREVISION)) {
                    //debo activar la alerta para la tarea de completar expediente
                    idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_CE);
                } else if (whereToGo.equals(REVISION_EXPEDIENTE) || whereToGo.equals(TRANSITION_ENVIARAENSANCION) ) {
                    //debo activar la alerta para la tarea de revisar expediente
                    idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_RE);
                } else if (whereToGo.equals(EN_SANCION) || whereToGo.equals(TRANSITION_ELEVAR_SANCIONADO) ) {
                    //debo activar la alerta para la tarea de en sancion
                    idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_ENSAN);
                } else if (whereToGo.equals(SANCIONADO)) {
                    //debo activar la alerta para la tarea de sancionado
                    idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_SANC);
                } else if (whereToGo.equals(FORMALIZAR_PROPUESTA)) {
                    //debo activar la alerta para la tarea de formalizar propuesta
                    idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_FP);
                } 

                //Parche por si la tarea no existe (versi�n de Fase 1)
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
        
        //Si tiene que ir a alguna de estas transiciones se está avanzando de forma automática
        if (whereToGo.equals(TRANSITION_ENVIARAREVISION) || whereToGo.equals(TRANSITION_ENVIARAENSANCION) || whereToGo.equals(TRANSITION_ELEVAR_SANCIONADO)) {
        	executionContext.setVariable(AVANCE_AUTOMATICO, Boolean.TRUE);
        } else {
        	executionContext.setVariable(AVANCE_AUTOMATICO, Boolean.FALSE);
        }
        executionContext.getProcessInstance().signal(whereToGo);
    }
}
