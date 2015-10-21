package es.pfsgroup.plugin.precontencioso.expedienteJudicial.handler;

import org.jbpm.graph.exe.ExecutionContext;
import org.jbpm.graph.exe.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.dao.SubtipoTareaDao;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.manager.ProcedimientoPcoManager;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;

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
		} else if (PrecontenciosoBPMConstants.PCO_PreTurnado.equals(getNombreNodo(executionContext)) || 
				PrecontenciosoBPMConstants.PCO_PostTurnado.equals(getNombreNodo(executionContext))) {
			
				pcoManager.obtenerNuevoLetrado(prc);
			
		}
		
		// Avanzamos BPM
		executionContext.getToken().signal();
	}

}
