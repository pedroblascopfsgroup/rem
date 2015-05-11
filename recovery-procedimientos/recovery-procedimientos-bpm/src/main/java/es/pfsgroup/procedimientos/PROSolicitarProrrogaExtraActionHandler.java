package es.pfsgroup.procedimientos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.recovery.api.TareaNotificacionApi;

/**
 * Handler Del Nodo SolicitarProrrogaExtraActionHandler.
 * @author jbosnjak
 *
 */
public class PROSolicitarProrrogaExtraActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

    /**Este metodo debe llamar a la creacion del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        logger.debug("---------ENTRE EN SolicitarProrrogaExtraActionHandler---------");
        
        TareaNotificacionApi notificacionManager = proxyFactory.proxy(TareaNotificacionApi.class);

        //Borra el timer en caso de que no se haya ejecutado
        //BPMUtils.deleteTimer(executionContext);

        String whereToGo = (String) executionContext.getVariable(WHERE_TO_GO);
        Long idTarea = null;
        if (executionContext.getVariable(TAREA_ASOCIADA_CE) != null) {
            idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_CE);
        } else if (executionContext.getVariable(TAREA_ASOCIADA_RE) != null) {
            idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_RE);
        } else if (executionContext.getVariable(TAREA_ASOCIADA_DC) != null) {
            idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_DC);
        }

        TareaNotificacion tarea = notificacionManager.get(idTarea);
        tarea.setAlerta(Boolean.FALSE);
        notificacionManager.saveOrUpdate(tarea);

        executionContext.getProcessInstance().signal(whereToGo);
    }
}
