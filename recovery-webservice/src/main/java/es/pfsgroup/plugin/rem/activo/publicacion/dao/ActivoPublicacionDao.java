package es.pfsgroup.plugin.rem.activo.publicacion.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionActivo;

public interface ActivoPublicacionDao extends AbstractDao<ActivoPublicacion, Long> {

	/**
	 * Este método convierte una entidad a un pojo.
	 *
	 * @param entidad: entidad a convertir en un objeto plano.
	 * @return Devuelve un objeto DtoDatosPublicacionActivo relleno con la información de
	 * la entidad.
	 */
	DtoDatosPublicacionActivo convertirEntidadTipoToDto(ActivoPublicacion entidad);

	/**
	 * Este método obtiene los días, para un ID de activo, que se encuentra un activo publicado para
	 * el tipo comercial venta.
	 *
	 * @param idActivo: ID del activo para obtener los días publicados.
	 * @return Devuelve el número de días que ha estado el activo publicado.
	 */
	Integer getDiasEnEstadoActualPublicadoVentaPorIdActivo(Long idActivo);

	/**
	 * Este método obtiene los días, para un ID de activo, que se encuentra un activo publicado para
	 * el tipo comercial alquiler.
	 *
	 * @param idActivo: ID del activo para obtener los días publicados.
	 * @return Devuelve el número de días que ha estado el activo publicado.
	 */
	Integer getDiasEnEstadoActualPublicadoAlquilerPorIdActivo(Long idActivo);

	/**
	 * Este método obtiene el registro de estado de publicación actual del activo por el ID de activo.
	 *
	 * @param idActivo: ID del activo para obtener si estado de publicación.
	 * @return Devuelve una entidad de estado de publicación.
	 */
	ActivoPublicacion getActivoPublicacionPorIdActivo(Long idActivo);
	
	/**
	 * Este método devuelve un listado de publicaciones de un activo por
	 * el ID de activo que recibe.
	 * 
	 * @param dto : dto con el ID de activo para filtrar el listado.
	 * @return Devuelve un listado con los resultados obtenidos.
	 */
	public List<ActivoPublicacion> getPublicacionActivoByIdActivo(DtoDatosPublicacion dto);

	/**
	 * Este método obtiene el registro de estado de publicación actual del activo por el num activo de activo.
	 * 
	 * @param numActivo: NUM_ACTIVO del activo para obtener la publicacion
	 * @return Devuelve una entidad de estado de publicación.
	 * */
	ActivoPublicacion getActivoPublicacionPorNumActivo(Long numActivo);
}