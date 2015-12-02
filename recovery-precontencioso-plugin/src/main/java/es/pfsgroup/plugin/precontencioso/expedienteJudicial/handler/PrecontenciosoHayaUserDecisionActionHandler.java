package es.pfsgroup.plugin.precontencioso.expedienteJudicial.handler;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
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

public class PrecontenciosoHayaUserDecisionActionHandler extends PROBaseActionHandler {

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

		 if (PrecontenciosoBPMConstants.PCO_IniciarProcJudicial.equals(getNombreNodo(executionContext))) {
			//executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), PrecontenciosoBPMConstants.PCO_FINALIZADO);
	        ProcedimientoPCO pco = (ProcedimientoPCO) executor.execute("plugin.precontencioso.getPCOByProcedimientoId", prc.getId());
	        final TipoProcedimiento tipoProcedimientoHijo = (Checks.esNulo(pco.getTipoProcIniciado()) ? 
	        		pco.getTipoProcPropuesto() : pco.getTipoProcIniciado());
	        creaProcedimientoHijo(executionContext, tipoProcedimientoHijo, prc, null, null);
	        //Avanzamos la tarea
	        //executionContext.getToken().signal();
		} 
		// Avanzamos BPM
		executionContext.getToken().signal();
	}

}
