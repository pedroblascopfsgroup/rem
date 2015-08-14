package es.pfsgroup.plugin.precontencioso.expedienteJudicial.api;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;


public interface ProcedimientoPcoApi {

	public static final String BO_PCO_EXPEDIENTE_BUSQUEDA_POR_PRC_ID = "plugin.precontencioso.getPrecontenciosoPorProcedimientoId";
	public static final String BO_PCO_FINALIZAR_PREPARACION_EXPEDIENTE_JUDICIAL_POR_PRC_ID = "plugin.precontencioso.finalizarPreparacionExpedienteJudicialPorProcedimientoId";

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

	@BusinessOperationDefinition(BO_PCO_FINALIZAR_PREPARACION_EXPEDIENTE_JUDICIAL_POR_PRC_ID)
	boolean finalizarPreparacionExpedienteJudicialPorProcedimientoId(Long idProcedimiento);

	/* BUSQUEDAS COMPLEJAS -> busquedas por filtro que debido a la complejidad se deben de realizar desde ProcedimientoPCO */

	/**
	 * Busqueda de procedimientosPco que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de ProcedimientosPCO que cumplen dicho filtro.
	 */
	List<ProcedimientoPCO> busquedaProcedimientosPcoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de SolicitudDocumentoPCO que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de SolicitudDocumentoPCO que cumplen dicho filtro.
	 */
	List<SolicitudDocumentoPCO> busquedaSolicitudesDocumentoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de LiquidacionPCO que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de LiquidacionPCO que cumplen dicho filtro.
	 */
	List<LiquidacionPCO> busquedaLiquidacionesPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de EnvioBurofaxPCO que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de EnvioBurofaxPCO que cumplen dicho filtro.
	 */
	List<EnvioBurofaxPCO> busquedaEnviosBurofaxPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);
}
