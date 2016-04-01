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
 * Handler del Nodo Devolver A Completar Expediente.
 * @author jbosnjak
 *
 */
public class PROAprobadoConCondicionesDeudaActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

    

    /**Este metodo debe llamar a la creacion del expediente.
     *
     *
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        logger.debug("---------ENTRE EN AprobadoConCondicionesDeudaActionHandler---------");
        
        ExpedienteApi expedienteManager = proxyFactory.proxy(ExpedienteApi.class);
        TareaNotificacionApi notificacionManager = proxyFactory.proxy(TareaNotificacionApi.class);

        //Borra el timer en caso de que no se haya ejecutado
        BPMUtils.deleteTimer(executionContext, TIMER_TAREA_CE);
        BPMUtils.deleteTimer(executionContext, TIMER_TAREA_RE);
        BPMUtils.deleteTimer(executionContext, TIMER_TAREA_ENSAN); 
        BPMUtils.deleteTimer(executionContext, TIMER_TAREA_SANC);

        //Borra la tarea asociada a RE
        /*Long idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_RE);

        notificacionManager.borrarNotificacionTarea(idTarea);*/
        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);
        notificacionManager.eliminarTareasInvalidasElevacionExpediente(idExpediente, DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO);

        executionContext.setVariable(TAREA_ASOCIADA_SANC, null);

        if (logger.isDebugEnabled()) {
            logger.debug("Vuelvo al estado del expediente a CE");
        }

        expedienteManager.cambiarEstadoItinerarioExpediente(idExpediente, DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);
        
        expedienteManager.desCongelarExpediente(idExpediente);
        
        executionContext.getProcessInstance().signal();
    }

}
