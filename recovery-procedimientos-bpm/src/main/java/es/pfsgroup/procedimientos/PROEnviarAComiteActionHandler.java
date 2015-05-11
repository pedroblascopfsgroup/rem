package es.pfsgroup.procedimientos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.api.TareaNotificacionApi;

/**
 * Handler del Nodo Enviar A Comite.
 * @author jbosnjak
 *
 */
public class PROEnviarAComiteActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants {

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

    /**Este metodo debe llamar a la creacion del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        logger.debug("---------ENTRE EN EnviarAComiteActionHandler---------");
        
        ExpedienteApi expedienteManager = proxyFactory.proxy(ExpedienteApi.class);
        TareaNotificacionApi notificacionManager = proxyFactory.proxy(TareaNotificacionApi.class);

        //Borra el timer en caso de que no se haya ejecutado
        //BPMUtils.deleteTimer(executionContext);

        //Comprobamos si viene de una transición automática (timer desde generar notificación) o viene de una transición manual (desde el estado anterior)
        //Si es manual borramos los timers, si es automática no podemos borrar timers porque se está ejecutando uno de ellos y se embucla
        if (generaAlerta(executionContext)) {
            BPMUtils.deleteTimer(executionContext, TIMER_TAREA_CE);
            BPMUtils.deleteTimer(executionContext, TIMER_TAREA_RE);
            BPMUtils.deleteTimer(executionContext, TIMER_TAREA_DC);
        }

        //Borra la tarea asociada a RE
        /*Long idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_RE);

        notificacionManager.borrarNotificacionTarea(idTarea);*/
        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);
        notificacionManager.eliminarTareasInvalidasElevacionExpediente(idExpediente, DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE);

        executionContext.setVariable(TAREA_ASOCIADA_RE, null);

        if (logger.isDebugEnabled()) {
            logger.debug("Cambio el estado del expediente a DC");
        }

        expedienteManager.cambiarEstadoItinerarioExpediente(idExpediente, DDEstadoItinerario.ESTADO_DECISION_COMIT);

        //Calcular el comite del expediente
        try {
            expedienteManager.calcularComiteExpediente(idExpediente);
        } catch (GenericRollbackException e) {
            logger.error("No se pudo encontrar un comite para el expediente: " + idExpediente, e);
        }

        //Congela el expediente
        expedienteManager.congelarExpediente(idExpediente);

        executionContext.getProcessInstance().signal();
    }

}
