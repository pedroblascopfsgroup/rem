package es.pfsgroup.plugin.rem.activo.publicacion.dao;



import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoPublicacionHistorico;
import es.pfsgroup.plugin.rem.model.DtoPaginadoHistoricoEstadoPublicacion;

public interface ActivoPublicacionHistoricoDao extends AbstractDao<ActivoPublicacionHistorico, Long> {

	/**
	 * Este método devuelve un listado paginado de histórico de estados de publicaciones de un activo por el ID de activo que recibe.
	 *
	 * @param dto : dto con el ID de activo para filtrar el listado.
	 * @return Devuelve un listado paginado con los resultados obtenidos.
	 */
	DtoPaginadoHistoricoEstadoPublicacion getListadoPaginadoHistoricoEstadosPublicacionVentaByIdActivo(DtoPaginadoHistoricoEstadoPublicacion dto);

	/**
	 * Este método devuelve un listado paginado de histórico de estados de publicaciones de un activo por el ID de activo que recibe.
	 *
	 * @param dto : dto con el ID de activo para filtrar el listado.
	 * @return Devuelve un listado paginado con los resultados obtenidos.
	 */
	DtoPaginadoHistoricoEstadoPublicacion getListadoHistoricoEstadosPublicacionAlquilerByIdActivo(DtoPaginadoHistoricoEstadoPublicacion dto);

	/**
	 * Este método obtiene la suma de días, para un ID de activo, que ha estado un activo publicado para el tipo comercial venta.
	 *
	 * @param idActivo: ID del activo para obtener los días publicados.
	 * @return Devuelve el número de días que ha estado el activo publicado.
	 */
	Integer getTotalDeDiasEnEstadoPublicadoVentaPorIdActivo(Long idActivo);

	/**
	 * Este método obtiene la suma de días, para un ID de activo, que ha estado un activo publicado para el tipo comercial alquiler.
	 *
	 * @param idActivo: ID del activo para obtener los días publicados.
	 * @return Devuelve el número de días que ha estado el activo publicado.
	 */
	Integer getTotalDeDiasEnEstadoPublicadoAlquilerPorIdActivo(Long idActivo);
	
}
