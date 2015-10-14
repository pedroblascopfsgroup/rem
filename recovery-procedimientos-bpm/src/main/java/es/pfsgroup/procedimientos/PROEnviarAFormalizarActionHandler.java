package es.pfsgroup.procedimientos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.api.TareaNotificacionApi;

/**
 * Handler Del Nodo Enviar a Revision.
 * @author C.Perez
 *
 */
public class PROEnviarAFormalizarActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants {

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

    private boolean esAvanceAutomatico(ExecutionContext executionContext) {    	
    	return Checks.esNulo(JBPMProcessManager.getFixeBooleanValue(executionContext, AVANCE_AUTOMATICO)) ? false : JBPMProcessManager.getFixeBooleanValue(executionContext, AVANCE_AUTOMATICO) ;
    }
    /**Este metodo debe llamar a la creacion del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        logger.debug("---------ENTRE EN EnviarAFormalizarPropuestaActionHandler---------");

        ExpedienteApi expedienteManager = proxyFactory.proxy(ExpedienteApi.class);
        TareaNotificacionApi notificacionManager = proxyFactory.proxy(TareaNotificacionApi.class);
        
        //Borra el timer en caso de que no se haya ejecutado
        //BPMUtils.deleteTimer(executionContext);

        //Comprobamos si viene de una transici�n autom�tica (timer desde generar notificaci�n) o viene de una transici�n manual (desde el estado anterior)
        //Si es manual borramos los timers, si es autom�tica no podemos borrar timers porque se est� ejecutando uno de ellos y se embucla
        if (!esAvanceAutomatico(executionContext)) {
            BPMUtils.deleteTimer(executionContext, TIMER_TAREA_CE);
            BPMUtils.deleteTimer(executionContext, TIMER_TAREA_RE);
            BPMUtils.deleteTimer(executionContext, TIMER_TAREA_DC);            
            BPMUtils.deleteTimer(executionContext, TIMER_TAREA_FP);
        }
        executionContext.setVariable(AVANCE_AUTOMATICO, Boolean.FALSE);

        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);

        notificacionManager.eliminarTareasInvalidasElevacionExpediente(idExpediente, DDEstadoItinerario.ESTADO_DECISION_COMIT);

        if (logger.isDebugEnabled()) {
            logger.debug("Cambio el estado del expediente a FP");
        }
        executionContext.setVariable(TAREA_ASOCIADA_DC, null);

        expedienteManager.cambiarEstadoItinerarioExpediente(idExpediente, DDEstadoItinerario.ESTADO_FORMALIZAR_PROPUESTA);

        executionContext.getProcessInstance().signal();
    }

}
