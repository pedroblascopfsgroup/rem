package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao;

import java.util.HashMap;
import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.ProcedimientoPcoGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;

public interface ProcedimientoPCODao extends AbstractDao<ProcedimientoPCO, Long> {

	ProcedimientoPCO getProcedimientoPcoPorIdProcedimiento(Long idProcedimiento);

	/**
	 * Busqueda de procedimientosPco que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de ProcedimientosPCO que cumplen dicho filtro.
	 */
	List<HashMap<String, Object>> busquedaProcedimientosPcoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de documentos que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de documentos que cumplen dicho filtro.
	 */
	List<HashMap<String, Object>> busquedaDocumentosPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de liquidaciones que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de Liquidaciones que cumplen dicho filtro.
	 */
	List<HashMap<String, Object>> busquedaLiquidacionesPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda de burofaxes que cumplan el filtro enviado por parametro
	 * @param filtro
	 * @return Listado de burofaxes que cumplen dicho filtro.
	 */
	List<HashMap<String, Object>> busquedaBurofaxPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Busqueda los tipos de gestores asignados al asunto cuyo id se pasa como parámetro
	 * @param idAsunto
	 * @return Listado de códigos de tipo de gestor que cumplen dicho filtro.
	 */
	List<String> getTiposGestoresAsunto(Long idAsunto);

	/**
	 * Devuelve el numero de resultados que va a devolver la consulta con el filtro enviado por parametro
	 * @param filtro
	 * @return numero de resultados
	 */
	Integer countBusquedaProcedimientosPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

	/**
	 * Devuelve el numero de resultados que va a devolver la consulta con el filtro enviado por parametro
	 * @param filtro
	 * @return numero de resultados
	 */
	Integer countBusquedaElementosPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

}

