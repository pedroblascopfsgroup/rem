package es.pfsgroup.procedimientos;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.PropuestaApi;
import es.pfsgroup.recovery.api.ExpedienteApi;
import es.pfsgroup.recovery.api.TareaNotificacionApi;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

/**
 * Handler del Nodo Enviar A Comite.
 * @author jbosnjak
 *
 */
public class PROEnviarAComiteActionHandler extends PROBaseActionHandler implements ExpedienteBPMConstants {

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
        logger.debug("---------ENTRE EN EnviarAComiteActionHandler---------");
        
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
            BPMUtils.deleteTimer(executionContext, TIMER_TAREA_DC);            
        } else {
        	//Si es avance automático decidimos todas las propuestas
        	 List<EXTAcuerdo> propuestasExp = propuestaManager.listadoPropuestasByExpedienteId(idExpediente);
         	//Las propuestas en estado "Propuesto" se elevan/aceptan
         	for (EXTAcuerdo propuesta : propuestasExp) {
         		if (propuesta.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_PROPUESTO)) {
         			propuestaManager.cambiarEstadoPropuesta(propuesta, DDEstadoAcuerdo.ACUERDO_ACEPTADO, true);
         		}
 			}
         	
         	//Si es automático copiamos las políticas
        	Expediente exp = expedienteManager.getExpediente(idExpediente);
        	politicasVigentes = (Boolean) executor.execute(InternaBusinessOperation.BO_POL_MGR_MARCAR_POLITICAS_VIGENTES, exp, null, false);

            //Si se ha marcado como vigente las pol�ticas, el expediente se decide
			if (politicasVigentes) {
			     DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
			             DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO);
			     
			     exp.setEstadoExpediente(estadoExpediente);
			     expedienteManager.saveOrUpdate(exp);
			
			     //Si no se ha marcado como vigente, se siguie en la elevaci�n del expediente
			}
        }
        executionContext.setVariable(AVANCE_AUTOMATICO, Boolean.FALSE);

        //Borra la tarea asociada a RE
        /*Long idTarea = (Long) executionContext.getVariable(TAREA_ASOCIADA_RE);

        notificacionManager.borrarNotificacionTarea(idTarea);*/
       
        notificacionManager.eliminarTareasInvalidasElevacionExpediente(idExpediente, DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE);

        executionContext.setVariable(TAREA_ASOCIADA_RE, null);

        if (logger.isDebugEnabled()) {
            logger.debug("Cambio el estado del expediente a DC");
        }

        //Si tiene politicasVigentes el exp. se ha decidido y por tanto ya no avanza ni cambia de estado
        if (!politicasVigentes) {
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

}
