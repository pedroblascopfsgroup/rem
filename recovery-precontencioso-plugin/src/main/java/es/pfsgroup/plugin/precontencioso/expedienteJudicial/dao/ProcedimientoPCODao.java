package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

public interface ProcedimientoPCODao extends AbstractDao<ProcedimientoPCO, Long> {

	ProcedimientoPCO getProcedimientoPcoPorIdProcedimiento(Long idProcedimiento);

	/* BUSQUEDAS COMPLEJAS -> busquedas por filtro que debido a la complejidad se deben de realizar desde ProcedimientoPCO */

	/**
	 * Busqueda de procedimientosPco que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de ProcedimientosPCO que cumplen dicho filtro.
	 */
	List<ProcedimientoPCO> getProcedimientosPcoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de SolicitudDocumentoPCO que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de SolicitudDocumentoPCO que cumplen dicho filtro.
	 */
	List<SolicitudDocumentoPCO> getSolicitudesDocumentoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de LiquidacionPCO que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de LiquidacionPCO que cumplen dicho filtro.
	 */
	List<LiquidacionPCO> getLiquidacionesPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de EnvioBurofaxPCO que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de EnvioBurofaxPCO que cumplen dicho filtro.
	 */
	List<EnvioBurofaxPCO> getEnviosBurofaxPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);
}

