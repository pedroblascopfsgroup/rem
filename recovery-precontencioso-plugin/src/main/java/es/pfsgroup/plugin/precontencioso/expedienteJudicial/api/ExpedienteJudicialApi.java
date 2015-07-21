package es.pfsgroup.plugin.precontencioso.expedienteJudicial.api;

import java.util.List;

import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;

public interface ExpedienteJudicialApi {

	/**
	 * Obtiene el historico de estados de un procedimientoPCO mediante un id procedimiento.
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	List<HistoricoEstadoProcedimientoDTO> getEstadosPorIdProcedimiento(Long idProcedimiento);

}
