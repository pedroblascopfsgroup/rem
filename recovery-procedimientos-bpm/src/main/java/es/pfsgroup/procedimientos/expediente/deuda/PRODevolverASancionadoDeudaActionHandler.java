package es.pfsgroup.procedimientos.expediente.deuda;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.api.TareaNotificacionApi;

/**
 * Handler del Nodo Devolver A Decisión Comité.
 * @author C.Perez
 *
 */
public class PRODevolverASancionadoDeudaActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

    

    /**Este metodo debe llamar a la creacion del expediente.
     *
     *
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        logger.debug("---------ENTRE EN DevolverASancionDeudaActionHandler---------");
        
        ExpedienteApi expedienteManager = proxyFactory.proxy(ExpedienteApi.class);
        TareaNotificacionApi notificacionManager = proxyFactory.proxy(TareaNotificacionApi.class);

        //Borra el timer en caso de que no se haya ejecutado
        BPMUtils.deleteTimer(executionContext, TIMER_TAREA_CE);
        BPMUtils.deleteTimer(executionContext, TIMER_TAREA_RE);
        BPMUtils.deleteTimer(executionContext, TIMER_TAREA_ENSAN); 
        BPMUtils.deleteTimer(executionContext, TIMER_TAREA_SANC);      
        BPMUtils.deleteTimer(executionContext, TIMER_TAREA_FP);

        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);
        notificacionManager.eliminarTareasInvalidasElevacionExpediente(idExpediente, DDEstadoItinerario.ESTADO_FORMALIZAR_PROPUESTA);

        executionContext.setVariable(TAREA_ASOCIADA_FP, null);

        if (logger.isDebugEnabled()) {
            logger.debug("Vuelvo al estado del expediente a SANC");
        }

        expedienteManager.cambiarEstadoItinerarioExpediente(idExpediente, DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO);

        executionContext.getProcessInstance().signal();
    }

}
