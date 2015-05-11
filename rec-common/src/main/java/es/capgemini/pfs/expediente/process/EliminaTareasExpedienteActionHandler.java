package es.capgemini.pfs.expediente.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;

/**
 * Esta clase se encarga de terminar todas las tareas del expediente.
 *
 * @author jbosnjak
 *
 */
@Component
public class EliminaTareasExpedienteActionHandler extends JbpmActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private TareaNotificacionManager tareaNotificacionManager;

    private static final long serialVersionUID = 1L;

    /**
     * Este metodo debe llamar a la creacion del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        if (logger.isDebugEnabled()) {
            logger.debug("EliminaTareasExpedienteActionHandler......");
        }
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
