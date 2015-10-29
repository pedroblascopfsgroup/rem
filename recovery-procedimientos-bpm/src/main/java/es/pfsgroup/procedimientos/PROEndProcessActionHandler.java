package es.pfsgroup.procedimientos;

import static es.capgemini.pfs.BPMContants.TOKEN_JBPM_PADRE;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;
import es.pfsgroup.recovery.integration.bpm.payload.ProcedimientoPayload;


/**
 * PONER JAVADOC FO.
 */
public class PROEndProcessActionHandler extends PROBaseActionHandler {

	private static final long serialVersionUID = 1L;

	@Autowired
	IntegracionBpmService bpmIntegrationService; 
	
	private String transicionIntegracion;

	/**
	 * Transición que enviará el sistema de notificaciones.
	 *  
	 * @return
	 */
	public String getTransicionIntegracion() {
		return transicionIntegracion;
	}

	/**
	 * Transición que enviará el sistema de notificaciones.
	 * 
	 * @param transicion
	 */
	public void setTransicionIntegracion(String transicionIntegracion) {
		this.transicionIntegracion = transicionIntegracion;
	}
	
	protected String getTransicion(ExecutionContext executionContext) {
        String transitionName = (Checks.esNulo(this.getTransicionIntegracion()))
        		? getNombreProceso(executionContext)
        		: this.getTransicionIntegracion();
        return transitionName;
	}
	
	protected String getGuidTAROrigen(ExecutionContext executionContext) {
        String guidTARorigen = "";
        //si este proceso ha sido iniciado por otro, lanzar� una se�al con su nombre
        if (hasVariable(ProcedimientoPayload.JBPM_TAR_GUID_ORIGEN, executionContext)) {
        	guidTARorigen = (String)getVariable(ProcedimientoPayload.JBPM_TAR_GUID_ORIGEN, executionContext);
        }
        return guidTARorigen;
	}

    /**
     * PONER JAVADOC FO.
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {

        logger.debug("Llegamos al final del BPM [" + getNombreProceso(executionContext) + "]");

        String transitionName = getTransicion(executionContext);
        String guidTARorigen = getGuidTAROrigen(executionContext);;
        
        Procedimiento procedimiento = getProcedimiento(executionContext);
        bpmIntegrationService.notificaFinBPM(procedimiento, guidTARorigen, transitionName);
        
        //si este proceso ha sido iniciado por otro, lanzar� una se�al con su nombre
        if (hasVariable(TOKEN_JBPM_PADRE, executionContext)) {

            Long idToken = (Long) getVariable(TOKEN_JBPM_PADRE, executionContext);

            //Si cuando vayamos a avisar al nodo, existe ese nodo activo y existe una transici�n correcta
            if (proxyFactory.proxy(JBPMProcessApi.class).hasTransitionToken(idToken, transitionName)) {
            	proxyFactory.proxy(JBPMProcessApi.class).signalToken(idToken, transitionName);
            }
        }
    }


}
