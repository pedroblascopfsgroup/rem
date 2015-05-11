package es.pfsgroup.plugin.recovery.mejoras.historicoProcedimiento;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.core.api.registro.HistoricoProcedimientoApi;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecision;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecisionFinalizar;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecisionParalizar;
import es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.HistoricoAsuntoAbrirDetalleHandler;

@Component
public class HistoricoAsuntoAbrirDetalleDecisionProcedimiento implements HistoricoAsuntoAbrirDetalleHandler{

	@Autowired
	private Executor executor;
	
	@Override
	public String getJspName() {
		return "plugin/mejoras/procedimientos/decision";
	}

	@SuppressWarnings("unchecked")
	@Override
	public Object getViewData(Long idTarea, Long idTraza, Long idEntidad) {
		DecisionProcedimiento dp = (DecisionProcedimiento)executor.execute("decisionProcedimientoManager.get", idEntidad);
		
		//List<DDCausaDecision> causaDecision = (List<DDCausaDecision>) executor.execute("dictionaryManager.getList","DDCausaDecision");
		List<DDCausaDecisionFinalizar> causaDecisionFinalizar = (List<DDCausaDecisionFinalizar>) executor.execute("dictionaryManager.getList","DDCausaDecisionFinalizar");
		List<DDCausaDecisionParalizar> causaDecisionParalizar = (List<DDCausaDecisionParalizar>) executor.execute("dictionaryManager.getList","DDCausaDecisionParalizar");		
		List<DDEstadoDecision> estadoDecision = (List<DDEstadoDecision>) executor.execute("dictionaryManager.getList","DDEstadoDecision");
		List<DDTipoActuacion> tiposActuacion = (List<DDTipoActuacion>) executor.execute("procedimientoManager.getTiposActuacion");
		List<TipoProcedimiento> tiposProcedimiento = (List<TipoProcedimiento>) executor.execute("procedimientoManager.getTiposProcedimiento");
		List<DDTipoReclamacion> tiposReclamacion = (List<DDTipoReclamacion>) executor.execute("procedimientoManager.getTiposReclamacion");
		List<Persona> personas = (List<Persona>)  executor.execute("procedimientoManager.getPersonasAfectadas", dp.getProcedimiento().getId());
	
		Map<String,Object> res = new HashMap<String,Object>();
		res.put("decisionProcedimiento", dp);
		//res.put("causaDecision",causaDecision);
		res.put("causaDecisionFinalizar",causaDecisionFinalizar);
		res.put("causaDecisionParalizar",causaDecisionParalizar);		
		res.put("estadoDecision",estadoDecision);
		res.put("tiposActuacion",tiposActuacion);
		res.put("tiposProcedimiento",tiposProcedimiento);
		res.put("tiposReclamacion",tiposReclamacion);
		res.put("personas",personas);
		res.put("isConsulta",true);
		res.put("readOnly",true);
		res.put("esGestor",false);
		res.put("esSupervisor",false);
		return res;
	}
	
	@Override
	public String getValidString() {
		return HistoricoProcedimientoApi.TIPO_PROPUESTA_DECISION;
	}

	public void setExecutor(Executor executor) {
		this.executor = executor;
	}

	public Executor getExecutor() {
		return executor;
	}

	

}
