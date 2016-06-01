package es.pfsgroup.plugin.precontencioso.expedienteJudicial.handler;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import com.jamonapi.utils.Logger;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.dao.SubtipoTareaDao;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContext;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContextImpl;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.manager.ProcedimientoPcoManager;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.recovery.ext.turnadodespachos.TurnadoDespachosManager;

public class PrecontenciosoUserDecisionActionHandler extends PROBaseActionHandler {

	private static final long serialVersionUID = -2212945246713305195L;

	@Autowired
	private SubtipoTareaDao subtipoTareaDao;
	
	@Autowired
	private ProcedimientoPcoManager pcoManager;

	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Autowired
	Executor executor;
	
	@Autowired
	PrecontenciosoProjectContext precontenciosoContext;
	
	@Autowired
	TurnadoDespachosManager turnadoDespachosManager;
	
	@Autowired
	UsuarioManager usuarioManager;
	
	
	@Override
	public void run(ExecutionContext executionContext) throws Exception {

		System.out.println(this.getClass().getSimpleName() + " llega a " + this.getNombreNodo(executionContext));
		
		Procedimiento prc = getProcedimiento(executionContext);
		logger.info(this.getClass().getSimpleName() + " valor del prc: " + prc.getId());
		System.out.println(this.getClass().getSimpleName() + " valor del prc: " + prc.getId());

		if (PrecontenciosoBPMConstants.PCO_DecTipoProcAutomatica.equals(getNombreNodo(executionContext))) {
			String valorDecision = pcoManager.dameTipoAsuntoPorProc(prc);
			executionContext.setVariable(PrecontenciosoBPMConstants.PCO_DecTipoProcAutomatica + "Decision",valorDecision);
			//Creación del PRC_PCO y estado inicial "En estudio"
			pcoManager.crearProcedimientoPco(prc, DDEstadoPreparacionPCO.EN_ESTUDIO);
		} else if (PrecontenciosoBPMConstants.PCO_IniciarProcJudicial.equals(getNombreNodo(executionContext))) {
			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), PrecontenciosoBPMConstants.PCO_FINALIZADO);
	        ProcedimientoPCO pco = (ProcedimientoPCO) executor.execute("plugin.precontencioso.getPCOByProcedimientoId", prc.getId());
	        final TipoProcedimiento tipoProcedimientoHijo = (Checks.esNulo(pco.getTipoProcIniciado()) ? 
	        		pco.getTipoProcPropuesto() : pco.getTipoProcIniciado());
	        creaProcedimientoHijo(executionContext, tipoProcedimientoHijo, prc, null, null);
	        //Avanzamos la tarea
	        //executionContext.getToken().signal();
		} else if (PrecontenciosoBPMConstants.PCO_PreTurnado.equals(getNombreNodo(executionContext)) 
				&& PrecontenciosoProjectContextImpl.RECOVERY_BANKIA.equals(precontenciosoContext.getRecovery())) {
			String valorDecision = pcoManager.dameTipoTurnado(prc.getId());
			executionContext.setVariable(PrecontenciosoBPMConstants.PCO_PreTurnado + "Decision",valorDecision);
			executor.execute("plugin.precontencioso.inicializarPco", prc);
			if(!DDTiposAsunto.CONCURSAL.equals(prc.getAsunto().getTipoAsunto().getCodigo())) {
				turnadoDespachosManager.turnar(prc.getAsunto().getId(), usuarioManager.getUsuarioLogado().getUsername(), EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);				
			}
		} else if (PrecontenciosoBPMConstants.PCO_PostTurnado.equals(getNombreNodo(executionContext))
				&& PrecontenciosoProjectContextImpl.RECOVERY_BANKIA.equals(precontenciosoContext.getRecovery())) {
			
			System.out.println(this.getClass().getSimpleName() + " Entro en el PostTurnado y el nodo es: " + getNombreNodo(executionContext));
			logger.info(this.getClass().getSimpleName() + " Entro en el PostTurnado y el nodo es: " + getNombreNodo(executionContext));
			System.out.println(this.getClass().getSimpleName() + " El asunto del prc es: " + prc.getAsunto().getId());
			logger.info(this.getClass().getSimpleName() + " El asunto del prc es: " + prc.getAsunto().getId());
			
			turnadoDespachosManager.turnar(prc.getAsunto().getId(), usuarioManager.getUsuarioLogado().getUsername(), EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);
		}else if (PrecontenciosoBPMConstants.P421_DecImporteConcursoAutomatica.equals(getNombreNodo(executionContext))
				&& PrecontenciosoProjectContextImpl.RECOVERY_BANKIA.equals(precontenciosoContext.getRecovery())) {
			String valorDecision;
			if(pcoManager.getEstadoLimiteImporteConcurso(prc.getId()).equals("menor"))
				valorDecision = "menor";
			else
				valorDecision="mayor";
			executionContext.setVariable(PrecontenciosoBPMConstants.P421_DecImporteConcursoAutomatica + "Decision",valorDecision);
		}else if (PrecontenciosoBPMConstants.P421_Turnado.equals(getNombreNodo(executionContext))
				&& PrecontenciosoProjectContextImpl.RECOVERY_BANKIA.equals(precontenciosoContext.getRecovery())) {
			turnadoDespachosManager.turnar(prc.getAsunto().getId(), usuarioManager.getUsuarioLogado().getUsername(), EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);
		}
		// Avanzamos BPM
		System.out.println(this.getClass().getSimpleName() + "Vamos a avanzar el BPM, el token actual es: " + executionContext.getToken().getId());
		System.out.println(this.getClass().getSimpleName() + "La transicion es: " + executionContext.getTransition().getId());
		System.out.println(this.getClass().getSimpleName() + "El nodo es: " + executionContext.getNode().getId());
		logger.info(this.getClass().getSimpleName() + "Vamos a avanzar el BPM, el token actual es: " + executionContext.getToken().getId());
		logger.info(this.getClass().getSimpleName() + "La transicion es: " + executionContext.getTransition().getId());
		logger.info(this.getClass().getSimpleName() + "El nodo es: " + executionContext.getNode().getId());
		
		executionContext.getToken().signal();
	}

}
