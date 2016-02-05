package es.pfsgroup.plugin.precontencioso.expedienteJudicial.handler;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContext;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContextImpl;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ProcedimientoPcoApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDTipoGestionRevisarExpJudicial;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.ext.turnadodespachos.AplicarTurnadoException;

public class PrecontenciosoLeaveActionHandler extends PROGenericLeaveActionHandler {
	private static final String BO_PLUGIN_PRECONTENCIOSO_CAMBIAR_ESTADO_EXPEDIETE = "plugin.precontencioso.cambiarEstadoExpediete";

	private static final String BO_PLUGIN_PRECONTENCIOSO_INICIALIZAR_PCO = "plugin.precontencioso.inicializarPco";

	private static final String TAREA_REVISAR_EXPDIG_DOC_COMPLETA = "docCompleta";

	/**
	 * 
	 */
	private static final long serialVersionUID = -5583230911255732281L;

	private static final String TAREA_REGISTRAR_TOMA_DEC_COMBO_PROC_INICIAR = "proc_a_iniciar";
	private static final String TAREA_REVISAR_EXPEDIENTE_ASIGNAR_LETRADO = "expediente_correcto";
	private static final String PROYECTO_HAYA = "HAYA";
	private static final String USU_MIGRACION_PCO = "MIGRAPCO";

	private static final String TAREA_REVISAR_EXPEDIENTE_PREPARAR_COMBO_GESTION = "gestion";	
	private static final String TAREA_REVISAR_EXPEDIENTE_PREPARAR_PROC_INICIAR = "proc_iniciar";
	
	
	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;
	
	@Autowired
	UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	PrecontenciosoProjectContext precontenciosoContext;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		
		Boolean tareaTemporal = (executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PARALIZAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_ACTIVAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PRORROGA));  //"activarProrroga"
		
		if (!tareaTemporal) {
			try {
				personalizacion(executionContext);
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (AplicarTurnadoException e) {
				// TODO Auto-generated catch block
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
			
		} else if (PrecontenciosoBPMConstants.PCO_PreTurnado.equals(tex.getTareaProcedimiento().getCodigo())) {

		} else if (PrecontenciosoBPMConstants.PCO_RegistrarAceptacion.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarNoAceptacion.equals(tex.getTareaProcedimiento().getCodigo())) {

		} else if (PrecontenciosoBPMConstants.PCO_RevisarExpediente.equals(tex.getTareaProcedimiento().getCodigo())) {
			if(PrecontenciosoProjectContextImpl.RECOVERY_HAYA.equals(precontenciosoContext.getRecovery())){
				executor.execute(BO_PLUGIN_PRECONTENCIOSO_INICIALIZAR_PCO, prc);
			}
		} else if (PrecontenciosoBPMConstants.PCO_PrepararExpediente.equals(tex.getTareaProcedimiento().getCodigo())) {

			// Funcionalidad incluida en el botón de Finalizar
			//proxyFactory.proxy(ProcedimientoPcoApi.class).cambiarEstadoExpediente(prc.getId(), DDEstadoPreparacionPCO.PREPARADO);
			
		} else if (PrecontenciosoBPMConstants.PCO_PostTurnado.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RegistrarAceptacionPost.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarNoAceptacionPost.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_EnviarExpedienteLetrado.equals(tex.getTareaProcedimiento().getCodigo())) {
				
			executor.execute(BO_PLUGIN_PRECONTENCIOSO_CAMBIAR_ESTADO_EXPEDIETE, prc.getId(), PrecontenciosoBPMConstants.PCO_ENVIADO);

		} else if (PrecontenciosoBPMConstants.PCO_RegistrarTomaDec.equals(tex.getTareaProcedimiento().getCodigo())) {
			actualizarProcIniciar(prc, listado, TAREA_REGISTRAR_TOMA_DEC_COMBO_PROC_INICIAR);			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarSubsanacion.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_IniciarProcJudicial.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_SubsanarIncidenciaExp.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_ValidarCambioProc.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_SubsanarCambioProc.equals(tex.getTareaProcedimiento().getCodigo())) {
			
		} else if (PrecontenciosoBPMConstants.PCO_AsignacionGestores.equals(tex.getTareaProcedimiento().getCodigo())) {
			if(PROYECTO_HAYA.equalsIgnoreCase(precontenciosoContext.getRecovery())){
				if(!(!Checks.esNulo(prc.getAuditoria()) && USU_MIGRACION_PCO.equals(prc.getAuditoria().getUsuarioCrear()))){
					executor.execute(BO_PLUGIN_PRECONTENCIOSO_INICIALIZAR_PCO, prc);
				}else{
					executor.execute("plugin.precontencioso.cambiarEstadoExpediete", prc.getId(), DDEstadoPreparacionPCO.PREPARACION);
				}
			} else {
				executor.execute(BO_PLUGIN_PRECONTENCIOSO_INICIALIZAR_PCO, prc);
			}
			
		} else if (PrecontenciosoBPMConstants.PCO_DecTipoProcAutomatica.equals(tex.getTareaProcedimiento().getCodigo())) {
	
		} else if (PrecontenciosoBPMConstants.PCO_RevisarExpedientePreparar.equals(tex.getTareaProcedimiento().getCodigo())) {

			String gestion = obtenerValorVariable(listado, TAREA_REVISAR_EXPEDIENTE_PREPARAR_COMBO_GESTION, "");
			if (!DDTipoGestionRevisarExpJudicial.JUDICIALIZAR.equals(gestion)) {
				executor.execute(BO_PLUGIN_PRECONTENCIOSO_CAMBIAR_ESTADO_EXPEDIETE, prc.getId(), DDEstadoPreparacionPCO.FINALIZADO);
			} else {
				actualizarProcIniciar(prc, listado, TAREA_REVISAR_EXPEDIENTE_PREPARAR_PROC_INICIAR);			
			}
		} else if (PrecontenciosoBPMConstants.PCO_AsignarGestorLiquidacion.equals(tex.getTareaProcedimiento().getCodigo())) {
			if(PrecontenciosoProjectContextImpl.RECOVERY_HAYA.equals(precontenciosoContext.getRecovery()) || 
					PrecontenciosoProjectContextImpl.RECOVERY_CAJAMAR.equals(precontenciosoContext.getRecovery()) ){
				executor.execute(BO_PLUGIN_PRECONTENCIOSO_INICIALIZAR_PCO, prc);
			}			
		} else if (PrecontenciosoBPMConstants.PCO_RevisarExpedienteAsignarLetrado.equals(tex.getTareaProcedimiento().getCodigo())) {
			String exp_correcto = obtenerValorVariable(listado, TAREA_REVISAR_EXPEDIENTE_ASIGNAR_LETRADO, "");
			if(DDSiNo.NO.equals(exp_correcto)) {
				executor.execute(BO_PLUGIN_PRECONTENCIOSO_CAMBIAR_ESTADO_EXPEDIETE, prc.getId(), PrecontenciosoBPMConstants.PCO_PREPARACION);
			}
		} else if (PrecontenciosoBPMConstants.PCO_RevisarExpDigCONC.equals(tex.getTareaProcedimiento().getCodigo())) {
			String docCompleta = obtenerValorVariable(listado, TAREA_REVISAR_EXPDIG_DOC_COMPLETA, DDSiNo.NO);
			if (DDSiNo.SI.equals(docCompleta)) {
				executor.execute(BO_PLUGIN_PRECONTENCIOSO_CAMBIAR_ESTADO_EXPEDIETE, prc.getId(), PrecontenciosoBPMConstants.PCO_FINALIZADO);
			}
		}
	}

	private void actualizarProcIniciar(Procedimiento prc,
			List<EXTTareaExternaValor> listado, String nombreVariableProcIniciar) {
		String procIniciar = obtenerValorVariable(listado,nombreVariableProcIniciar, "");
		ProcedimientoPCO pco = proxyFactory.proxy(ProcedimientoPcoApi.class).getPCOByProcedimientoId(prc.getId());
		if(!Checks.esNulo(procIniciar)) {
			TipoProcedimiento tipoProcInic = (TipoProcedimiento)diccionarioApi.dameValorDiccionarioByCod(TipoProcedimiento.class, procIniciar);
			pco.setTipoProcIniciado(tipoProcInic);
		}
		proxyFactory.proxy(ProcedimientoPcoApi.class).update(pco);
	}

	public List<EXTTareaExternaValor> obtenerValoresTareaByTexId(Long texId) {
		return genericDao.getList(EXTTareaExternaValor.class, genericDao
				.createFilter(FilterType.EQUALS, "tareaExterna.id", texId),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	private String obtenerValorVariable(List<EXTTareaExternaValor> listado, String nombreVariable, String valorDefecto) {
		String valorVariable = valorDefecto;
		for(EXTTareaExternaValor valor : listado) {
			if(nombreVariable.equals(valor.getNombre())){
				valorVariable = valor.getValor();
				break;
			}
		}
		return valorVariable;
	}


}
