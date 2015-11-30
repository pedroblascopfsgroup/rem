package es.pfsgroup.plugin.precontencioso.expedienteJudicial.handler;

import java.text.SimpleDateFormat;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContext;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContextImpl;
import es.pfsgroup.procedimientos.PROGenericEnterActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.ext.turnadodespachos.AplicarTurnadoException;
import es.pfsgroup.recovery.ext.turnadodespachos.TurnadoDespachosManager;

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
	
	@Autowired
	PrecontenciosoProjectContext precontenciosoContext;
	
	@Autowired
	TurnadoDespachosManager turnadoDespachosManager;
	
	@Autowired
	UsuarioManager usuarioManager;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {

		try {
			super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Boolean tareaTemporal = (executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PARALIZAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_ACTIVAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PRORROGA));  //"activarProrroga"
		
		if (!tareaTemporal) {
			try {
				personalizacion(executionContext);
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (AplicarTurnadoException e) {
				e.printStackTrace();
			}
		}
	}

	private void personalizacion(ExecutionContext executionContext) throws IllegalArgumentException, AplicarTurnadoException {

		// executionContext.getProcessDefinition().getName();
		// executionContext.getEventSource().getName();
		// executionContext.getNode().getName();

		Procedimiento prc = getProcedimiento(executionContext);
		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = obtenerValoresTareaByTexId(tex.getId());

		if (PrecontenciosoBPMConstants.PCO_PreTurnadoManual.equals(tex.getTareaProcedimiento().getCodigo())) {
			
			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), PrecontenciosoBPMConstants.PCO_PRETURNADO);
			
		} else if (PrecontenciosoBPMConstants.PCO_PreTurnado.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RegistrarAceptacion.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarNoAceptacion.equals(tex.getTareaProcedimiento().getCodigo())) {
			if(PrecontenciosoProjectContextImpl.RECOVERY_BANKIA.equals(precontenciosoContext.getRecovery())){
				turnadoDespachosManager.turnar(prc.getAsunto().getId(), usuarioManager.getUsuarioLogado().getUsername(), EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);
			}
		} else if (PrecontenciosoBPMConstants.PCO_RevisarExpediente.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_PrepararExpediente.equals(tex.getTareaProcedimiento().getCodigo())) {
			if (prc.getProcessBPM() == null) {
				prc.setProcessBPM(executionContext.getProcessInstance().getId());
			}
			if(!PrecontenciosoProjectContextImpl.RECOVERY_BANKIA.equals(precontenciosoContext.getRecovery())){
				//Si es CONCURSO invocar inicializacion
				if (DDTiposAsunto.CONCURSAL.equals(prc.getAsunto().getTipoAsunto().getCodigo())) {					
					executor.execute("plugin.precontencioso.inicializarPco", prc);
				}
			}
			
			executor.execute("es.pfsgroup.plugin.precontencioso.expedienteJudicial.recalcularTareasPreparacionDocumental", prc.getId());
			
		} else if (PrecontenciosoBPMConstants.PCO_PostTurnado.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RegistrarAceptacionPost.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarNoAceptacionPost.equals(tex.getTareaProcedimiento().getCodigo())) {
			if(PrecontenciosoProjectContextImpl.RECOVERY_BANKIA.equals(precontenciosoContext.getRecovery())){
				turnadoDespachosManager.turnar(prc.getAsunto().getId(), usuarioManager.getUsuarioLogado().getUsername(), EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);
			}
		} else if (PrecontenciosoBPMConstants.PCO_EnviarExpedienteLetrado.equals(tex.getTareaProcedimiento().getCodigo())) {
			
			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), PrecontenciosoBPMConstants.PCO_PREPARADO);

		} else if (PrecontenciosoBPMConstants.PCO_RegistrarTomaDec.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarSubsanacion.equals(tex.getTareaProcedimiento().getCodigo())) {
			
			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), PrecontenciosoBPMConstants.PCO_SUBSANAR);
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarSubsanacionCONC.equals(tex.getTareaProcedimiento().getCodigo())) {
			
			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), PrecontenciosoBPMConstants.PCO_SUBSANAR);
			
		} else if (PrecontenciosoBPMConstants.PCO_IniciarProcJudicial.equals(tex.getTareaProcedimiento().getCodigo())) {
			
//			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), PrecontenciosoBPMConstants.PCO_FINALIZADO);
//			
//	        ProcedimientoPCO pco = (ProcedimientoPCO) executor.execute("plugin.precontencioso.getPCOByProcedimientoId", prc.getId());
//	        final TipoProcedimiento tipoProcedimientoHijo = (Checks.esNulo(pco.getTipoProcIniciado()) ? 
//	        		pco.getTipoProcPropuesto() : pco.getTipoProcIniciado());
//
//	        creaProcedimientoHijo(executionContext, tipoProcedimientoHijo, prc, null, null);
//	        
//	        //Avanzamos la tarea
//	        executionContext.getToken().signal();
			
		} else if (PrecontenciosoBPMConstants.PCO_SubsanarIncidenciaExp.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_ValidarCambioProc.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_SubsanarCambioProc.equals(tex.getTareaProcedimiento().getCodigo())) {
			
			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), PrecontenciosoBPMConstants.PCO_SUBSANAR_POR_CAMBIO);

		} else if (PrecontenciosoBPMConstants.PCO_AsignacionGestores.equals(tex.getTareaProcedimiento().getCodigo())) {
			
			executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), PrecontenciosoBPMConstants.PCO_PREPARACION);

		}
		
	}

	public List<EXTTareaExternaValor> obtenerValoresTareaByTexId(Long texId) {
		return genericDao.getList(EXTTareaExternaValor.class, genericDao
				.createFilter(FilterType.EQUALS, "tareaExterna.id", texId),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

}
