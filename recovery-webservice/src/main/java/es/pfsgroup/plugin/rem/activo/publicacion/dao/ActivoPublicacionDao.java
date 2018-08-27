package es.pfsgroup.plugin.rem.activo.publicacion.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionActivo;

import java.util.Date;

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
	 * Este método obtiene el estado del check de publicación sin precio para venta dado un ID de activo.
	 *
	 * @param idActivo: ID del activo del que obtener el check.
	 * @return Devuelve True si el check de publicar sin precio está marcado, False si no está marcado.
	 */
	Boolean getCheckSinPrecioVentaPorIdActivo(Long idActivo);

	/**
	 * Este método obtiene el estado del check de publicación sin precio para alquiler dado un ID de activo.
	 *
	 * @param idActivo: ID del activo del que obtener el check.
	 * @return Devuelve True si el check de publicar sin precio está marcado, False si no está marcado.
	 */
	Boolean getCheckSinPrecioAlquilerPorIdActivo(Long idActivo);

	/**
	 * Este método obtiene la fecha de inicio del estado de publicación venta en el que se encuentra el activo.
	 *
	 * @param idActivo: ID del activo del que obtener la fecha de inicio de estado de publicación venta.
	 * @return Devuelve un objeto fecha si el activo consta de estado de publicación, null de otro modo.
	 */
	Date getFechaInicioEstadoActualPublicacionVenta(Long idActivo);
}