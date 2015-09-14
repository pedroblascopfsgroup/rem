package es.pfsgroup.plugin.precontencioso.expedienteJudicial.handler;

import java.text.SimpleDateFormat;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class PrecontenciosoLeaveActionHandler extends PROGenericLeaveActionHandler {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5583230911255732281L;

	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		
		Boolean tareaTemporal = (executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PARALIZAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_ACTIVAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PRORROGA));  //"activarProrroga"
		
		if (!tareaTemporal) {
			personalizacion(executionContext);
		}
	}

	private void personalizacion(ExecutionContext executionContext) {

		// executionContext.getProcessDefinition().getName();
		// executionContext.getEventSource().getName();
		// executionContext.getNode().getName();

		Procedimiento prc = getProcedimiento(executionContext);
		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = obtenerValoresTareaByTexId(tex.getId());

		if (PrecontenciosoBPMConstants.PCO_PreTurnadoManual.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_PreTurnado.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RegistrarAceptacion.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarNoAceptacion.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarExpediente.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_PrepararExpediente.equals(tex.getTareaProcedimiento().getCodigo())) {
			
			// Funcionalidad incluida en el botón de Finalizar
			//proxyFactory.proxy(ProcedimientoPcoApi.class).cambiarEstadoExpediente(prc.getId(), DDEstadoPreparacionPCO.PREPARADO);
			
		} else if (PrecontenciosoBPMConstants.PCO_PostTurnado.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RegistrarAceptacionPost.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarNoAceptacionPost.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_EnviarExpedienteLetrado.equals(tex.getTareaProcedimiento().getCodigo())) {
				
			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), PrecontenciosoBPMConstants.PCO_ENVIADO);

		} else if (PrecontenciosoBPMConstants.PCO_RegistrarTomaDec.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarSubsanacion.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_IniciarProcJudicial.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_SubsanarIncidenciaExp.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_ValidarCambioProc.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_SubsanarCambioProc.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} 
		
	}

	public List<EXTTareaExternaValor> obtenerValoresTareaByTexId(Long texId) {
		return genericDao.getList(EXTTareaExternaValor.class, genericDao
				.createFilter(FilterType.EQUALS, "tareaExterna.id", texId),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

}
