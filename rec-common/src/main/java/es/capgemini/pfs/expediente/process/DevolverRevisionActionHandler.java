package es.capgemini.pfs.expediente.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.expediente.ExpedienteManager;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;

/**
 * Handler del Nodo Devolver A Revision de Expediente.
 * @author jbosnjak
 *
 */
@Component
public class DevolverRevisionActionHandler extends JbpmActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private TareaNotificacionManager notificacionManager;

    @Autowired
    private ExpedienteManager expedienteManager;

    private static final long serialVersionUID = 1L;

    /**
     * Este metodo debe llamar a la creacion del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        logger.debug("---------ENTRE EN DevolverRevisionActionHandler---------");

        //Borra el timer en caso de que no se haya ejecutado
        BPMUtils.deleteTimer(executionContext, TIMER_TAREA_CE);
        BPMUtils.deleteTimer(executionContext, TIMER_TAREA_RE);
        BPMUtils.deleteTimer(executionContext, TIMER_TAREA_DC);

        //Borra la tarea asociada a DC
        /*Long idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_DC);

        notificacionManager.borrarNotificacionTarea(idTarea);*/
        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);
        notificacionManager.eliminarTareasInvalidasElevacionExpediente(idExpediente, DDEstadoItinerario.ESTADO_DECISION_COMIT);
        if (logger.isDebugEnabled()) {
            logger.debug("Vuelvo al estado del expediente a RE");
        }
        executionContext.setVariable(TAREA_ASOCIADA_DC, null);

        expedienteManager.cambiarEstadoItinerarioExpediente(idExpediente, DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE);

        expedienteManager.desCongelarExpediente(idExpediente);

        executionContext.getProcessInstance().signal();
    }
}
