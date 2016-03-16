package es.pfsgroup.procedimientos.expediente.deuda;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.PropuestaApi;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.api.TareaNotificacionApi;

/**
 * Handler del Nodo Enviar A Comite.
 * @author jbosnjak
 *
 */
public class PROEnviarASancionadoDeudaActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants {

    private final Log logger = LogFactory.getLog(getClass());

    private static final long serialVersionUID = 1L;

    @Autowired
	private PropuestaApi propuestaManager;
    
    @Autowired
	private Executor executor;
    
    private boolean esAvanceAutomatico(ExecutionContext executionContext) {
    	return Checks.esNulo(JBPMProcessManager.getFixeBooleanValue(executionContext, AVANCE_AUTOMATICO)) ? false : JBPMProcessManager.getFixeBooleanValue(executionContext, AVANCE_AUTOMATICO);
    }

    /**Este metodo debe llamar a la creacion del expediente.
     *
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
        logger.debug("---------ENTRE EN EnviarASancionadoDeudaActionHandler---------");
        
        ExpedienteApi expedienteManager = proxyFactory.proxy(ExpedienteApi.class);
        TareaNotificacionApi notificacionManager = proxyFactory.proxy(TareaNotificacionApi.class);
        
        Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);
        Boolean politicasVigentes = false;
        //Borra el timer en caso de que no se haya ejecutado
        //BPMUtils.deleteTimer(executionContext);

        //Comprobamos si viene de una transici�n autom�tica (timer desde generar notificaci�n) o viene de una transici�n manual (desde el estado anterior)
        //Si es manual borramos los timers, si es autom�tica no podemos borrar timers porque se est� ejecutando uno de ellos y se embucla
        if (!esAvanceAutomatico(executionContext)) {
        	 BPMUtils.deleteTimer(executionContext, TIMER_TAREA_CE);
             BPMUtils.deleteTimer(executionContext, TIMER_TAREA_RE);
             BPMUtils.deleteTimer(executionContext, TIMER_TAREA_ENSAN); 
             BPMUtils.deleteTimer(executionContext, TIMER_TAREA_SANC);       
        } 
        
        executionContext.setVariable(AVANCE_AUTOMATICO, Boolean.FALSE);

        //Borra la tarea asociada a RE
        /*Long idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_RE);

        notificacionManager.borrarNotificacionTarea(idTarea);*/
       
        notificacionManager.eliminarTareasInvalidasElevacionExpediente(idExpediente, DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION);

        executionContext.setVariable(TAREA_ASOCIADA_ENSAN, null);

        if (logger.isDebugEnabled()) {
            logger.debug("Cambio el estado del expediente a SANC");
        }

       
        expedienteManager.cambiarEstadoItinerarioExpediente(idExpediente, DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO);
	        
	    executionContext.getProcessInstance().signal();
    }

}
