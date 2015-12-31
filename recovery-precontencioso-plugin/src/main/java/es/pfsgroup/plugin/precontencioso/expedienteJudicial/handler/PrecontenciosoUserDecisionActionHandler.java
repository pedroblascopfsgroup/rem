package es.pfsgroup.plugin.precontencioso.expedienteJudicial.handler;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

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
		executionContext.getToken().signal();
	}

}
