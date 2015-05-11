package es.capgemini.pfs.expediente.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Handler Del Nodo SolicitarProrrogaExtraActionHandler.
 * @author jbosnjak
 *
 */
@Component
public class SolicitarProrrogaExtraActionHandler extends JbpmActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

    @Autowired
    private TareaNotificacionManager notificacionManager;

    /**Este metodo debe llamar a la creacion del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        logger.debug("---------ENTRE EN SolicitarProrrogaExtraActionHandler---------");

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
