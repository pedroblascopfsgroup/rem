package es.capgemini.pfs.expediente.process;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.expediente.ExpedienteManager;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.tareaNotificacion.TareaNotificacionManager;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * Handler Del Nodo Enviar a Revision.
 * @author jbosnjak
 *
 */
@Component
public class EnviarARevisionActionHandler extends JbpmActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

    @Autowired
    private TareaNotificacionManager notificacionManager;

    @Autowired
    private ExpedienteManager expedienteManager;

    /**
     * Las variables boolean en jbpm se almacenan como String T/F.
     * @param executionContext
     * @return
     */
    private boolean generaAlerta(ExecutionContext executionContext) {
        return JBPMProcessManager.getFixeBooleanValue(executionContext, GENERAALERTA);
    }

    /**Este metodo debe llamar a la creacion del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run() throws Exception {
        logger.debug("---------ENTRE EN EnviarARevisionActionHandler---------");

        //Borra el timer en caso de que no se haya ejecutado
        //BPMUtils.deleteTimer(executionContext);

        //Comprobamos si viene de una transición automática (timer desde generar notificación) o viene de una transición manual (desde el estado anterior)
        //Si es manual borramos los timers, si es automática no podemos borrar timers porque se está ejecutando uno de ellos y se embucla
        if (generaAlerta(executionContext)) {
            BPMUtils.deleteTimer(executionContext, TIMER_TAREA_CE);
            BPMUtils.deleteTimer(executionContext, TIMER_TAREA_RE);
            BPMUtils.deleteTimer(executionContext, TIMER_TAREA_DC);
        }

        //Borra la tarea asociada a CE
        /*Long idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_CE);

        notificacionManager.borrarNotificacionTarea(idTarea);
        */
        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);

        notificacionManager.eliminarTareasInvalidasElevacionExpediente(idExpediente, DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);

        if (logger.isDebugEnabled()) {
            logger.debug("Cambio el estado del expediente a RE");
        }
        executionContext.setVariable(TAREA_ASOCIADA_CE, null);

        expedienteManager.cambiarEstadoItinerarioExpediente(idExpediente, DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE);

        executionContext.getProcessInstance().signal();
    }

}
