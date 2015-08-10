package es.pfsgroup.plugin.precontencioso.expedienteJudicial.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.ExpedienteJudicialApi;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;

@Controller
public class ExpedienteJudicialController {

	private static final String JSON_HISTORICO_ESTADOS = "plugin/precontencioso/historicoEstados/json/historicoEstadosJSON";
	private static final String JSON_RESULTADO_FINALIZAR_PREPARACION = "plugin/precontencioso/acciones/json/resultadoFinalizarPreparacionJSON";

	@Autowired
	ExpedienteJudicialApi expedienteJudicialApi;
	
	@RequestMapping
	public String finalizarPreparacion(@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento, ModelMap model) {
		boolean finalizado = expedienteJudicialApi.finalizarPreparacionExpedienteJudicialPorProcedimientoId(idProcedimiento);
		model.put("finalizado", finalizado);
		return JSON_RESULTADO_FINALIZAR_PREPARACION;
	}	

	@RequestMapping
	public String getHistoricoEstadosPorProcedimientoId(@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento, ModelMap model) {

		List<HistoricoEstadoProcedimientoDTO> historicoEstados = expedienteJudicialApi.getEstadosPorIdProcedimiento(idProcedimiento);
		model.put("historicoEstados", historicoEstados);

		return JSON_HISTORICO_ESTADOS;
	}

}