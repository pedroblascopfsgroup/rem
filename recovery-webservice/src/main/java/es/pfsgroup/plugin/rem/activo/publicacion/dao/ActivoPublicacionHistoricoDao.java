package es.pfsgroup.plugin.rem.activo.publicacion.dao;



import java.text.ParseException;

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
	
	/**
	 * Este método devuelve el registro actual del histórico de publicaciones
	 *
	 * @param idActivo: ID del activo.
	 * @return Devuelve el ActivoPublicacionHistorico del activo.
	 */
	ActivoPublicacionHistorico getActivoPublicacionHistoricoActual(Long idActivo);
	
	/**
	 * Este método obtiene el conteo de días que se pasa un activo en un mismo estado de publicación para el tipo destino comercial venta. Se limita al estado de 'Publicado'. Para el resto de estados
	 * devuelve 0.
	 *
	 * @param estadoActivo: estado del activo del cual calcular sus días.
	 * @return Devuelve el número de días que ha estado un activo en un mismo estado.
	 * @throws ParseException: Puede lanzar un error al convertir la fecha para los cálculos
	 */
	Long obtenerDiasPorEstadoPublicacionVentaActivo(ActivoPublicacionHistorico estadoActivo) throws ParseException;
	
	/**
	 * Este método obtiene el conteo de días que se pasa un activo en un mismo estado de publicación para el tipo destino comercial alquiler. Se limita al estado de 'Publicado'. Para el resto de
	 * estados devuelve 0.
	 *
	 * @param estadoActivo: estado del activo del cual calcular sus días.
	 * @return Devuelve el número de días que ha estado un activo en un mismo estado.
	 * @throws ParseException: Puede lanzar un error al convertir la fecha para los cálculos.
	 */
	Long obtenerDiasPorEstadoPublicacionAlquilerActivo(ActivoPublicacionHistorico estadoActivo) throws ParseException;
}
