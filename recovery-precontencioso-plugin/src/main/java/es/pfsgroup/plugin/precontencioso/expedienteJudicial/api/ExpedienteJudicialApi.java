package es.pfsgroup.plugin.precontencioso.expedienteJudicial.api;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;

public interface ExpedienteJudicialApi {

	static final String BO_PCO_EXPEDIENTE_BUSQUEDA_POR_PRC_ID = "plugin.preconencioso.getPrecontenciosoPorProcedimientoId";
	
	/**
	 * Obtiene el historico de estados de un procedimientoPCO mediante un id procedimiento.
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	List<HistoricoEstadoProcedimientoDTO> getEstadosPorIdProcedimiento(Long idProcedimiento);

	/**
	 * Obtiene el procedimiento precontencioso por id procedimiento.
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	@BusinessOperationDefinition(BO_PCO_EXPEDIENTE_BUSQUEDA_POR_PRC_ID)
	ProcedimientoPCODTO getPrecontenciosoPorProcedimientoId(Long idProcedimiento);
}
