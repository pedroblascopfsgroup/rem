package es.pfsgroup.procedimientos.expedienteJudicial.handler;

import java.text.SimpleDateFormat;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.procedimientos.PROGenericEnterActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class PrecontenciosoEnterActionHandler extends PROGenericEnterActionHandler {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5583230911255732281L;

	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private Executor executor;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {

		try {
			super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
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
			
//			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), DDEstadoPreparacionPCO.PRETURNADO);
			
		} else if (PrecontenciosoBPMConstants.PCO_PreTurnado.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RegistrarAceptacion.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarNoAceptacion.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarExpediente.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_PrepararExpediente.equals(tex.getTareaProcedimiento().getCodigo())) {
			
//			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), DDEstadoPreparacionPCO.PRETURNADO);
			
		} else if (PrecontenciosoBPMConstants.PCO_PostTurnado.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RegistrarAceptacionPost.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarNoAceptacionPost.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_EnviarExpedienteLetrado.equals(tex.getTareaProcedimiento().getCodigo())) {

		} else if (PrecontenciosoBPMConstants.PCO_RegistrarTomaDec.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarSubsanacion.equals(tex.getTareaProcedimiento().getCodigo())) {
						
//			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), DDEstadoPreparacionPCO.PRETURNADO);
			
		} else if (PrecontenciosoBPMConstants.PCO_IniciarProcJudicial.equals(tex.getTareaProcedimiento().getCodigo())) {
			
//			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), DDEstadoPreparacionPCO.PRETURNADO);
			
		} else if (PrecontenciosoBPMConstants.PCO_SubsanarIncidenciaExp.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_ValidarCambioProc.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_SubsanarCambioProc.equals(tex.getTareaProcedimiento().getCodigo())) {
			
//			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), DDEstadoPreparacionPCO.PRETURNADO);

		} 
		
	}

	public List<EXTTareaExternaValor> obtenerValoresTareaByTexId(Long texId) {
		return genericDao.getList(EXTTareaExternaValor.class, genericDao
				.createFilter(FilterType.EQUALS, "tareaExterna.id", texId),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

}
