package es.pfsgroup.plugin.rem.jbpm.handler;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.ActivoGenericActionHandler.ConstantesBPMPFS;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

public class ResultadoPBCEnterActionHandler extends ActivoGenericEnterActionHandler {

	private static final long serialVersionUID = -2997523481794698821L;
	private static final String INSTRUCCIONES_RESERVA = "T013_InstruccionesReserva";
	@Autowired
	OfertaApi ofertaApi;
	
	@Autowired
	TareaExternaManager tareaExternaManager;
	
	/**
	 * PONER JAVADOC FO.
	 * 
	 * @param delegateTransitionClass
	 *            delegateTransitionClass
	 * @param delegateSpecificClass
	 *            delegateSpecificClass
	 * @return 
	 * @throws Exception
	 */
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) throws Exception {
	
		//Primero ejecuta la entrada (creacion) de la tarea
		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		
		TareaExterna tareaExterna = getTareaExterna(executionContext);
		ActivoTramite tramite = getActivoTramite(executionContext);
		
		Boolean saltando = !Checks.esNulo((Boolean) getVariable("saltando", executionContext)) ? (Boolean) getVariable("saltando", executionContext) : false;
		
		// Si hay reserva, se bloquea (borra) la tarea en espera de que el estado de la reserva este firmada
		//(avanzando tarea "Obtencion contrato reserva")
		
		if(!Checks.esNulo(tareaExterna) && ofertaApi.checkReserva(tareaExterna) && !ofertaApi.checkEsExpress(tareaExterna) && !saltando && (!ofertaApi.checkEsYubai(tareaExterna) || INSTRUCCIONES_RESERVA.equals(executionContext.getVariable(ConstantesBPMPFS.NOMBRE_NODO_SALIENTE)))) {
			tareaExterna.getTareaPadre().getAuditoria().setBorrado(true);
		}

	}
}