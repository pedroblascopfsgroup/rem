package es.pfsgroup.plugin.precontencioso.expedienteJudicial.api;

import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ActualizarProcedimientoPcoDtoInfo;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.HistoricoEstadoProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.ProcedimientoPCODTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;


public interface ProcedimientoPcoApi {

	public static final String BO_PCO_EXPEDIENTE_OBTENER_TIPO_GESTOR = "plugin.precontencioso.getTipoGestor";
	public static final String BO_PCO_EXPEDIENTE_IS_TIPO_DESPACHO_PREDOC = "plugin.precontencioso.isTipoDespachoPredoc";
	public static final String BO_PCO_EXPEDIENTE_IS_TIPO_DESPACHO_GESTORIA = "plugin.precontencioso.isTipoDespachoGestoria";
	public static final String BO_PCO_EXPEDIENTE_IS_SUPERVISOR = "plugin.precontencioso.isSupervisor";
	public static final String BO_PCO_EXPEDIENTE_BUSQUEDA_POR_PRC_ID = "plugin.precontencioso.getPrecontenciosoPorProcedimientoId";
	public static final String BO_PCO_FINALIZAR_PREPARACION_EXPEDIENTE_JUDICIAL_POR_PRC_ID = "plugin.precontencioso.finalizarPreparacionExpedienteJudicialPorProcedimientoId";
	public static final String BO_PCO_ACTUALIZAR_PROCEDIMIENTO_Y_PCO = "plugin.precontencioso.actualizaProcedimientoPco";
	
	/*
	 * Producto-234 Control de botones y rellenado de grids dependiendo del usuario logado
	
	@BusinessOperationDefinition(BO_PCO_EXPEDIENTE_OBTENER_TIPO_GESTOR)
	String getTipoGestor(Long prcId);
	
	@BusinessOperationDefinition(BO_PCO_EXPEDIENTE_IS_TIPO_DESPACHO_PREDOC)
	boolean isTipoDespachoPredoc(Long prcId);
	
	@BusinessOperationDefinition(BO_PCO_EXPEDIENTE_IS_TIPO_DESPACHO_GESTORIA)
	boolean isTipoDespachoGestoria(Long prcId);
	
	@BusinessOperationDefinition(BO_PCO_EXPEDIENTE_IS_SUPERVISOR)
	boolean isSupervisor(Long prcId);
	*/
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
	
	@BusinessOperationDefinition(BO_PCO_ACTUALIZAR_PROCEDIMIENTO_Y_PCO)
	void actualizaProcedimiento(ActualizarProcedimientoPcoDtoInfo dto);
}
