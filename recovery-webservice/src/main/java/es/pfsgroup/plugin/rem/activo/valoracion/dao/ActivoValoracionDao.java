package es.pfsgroup.plugin.rem.activo.valoracion.dao;

import java.util.Date;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionActivo;

public interface ActivoValoracionDao extends AbstractDao<ActivoValoraciones, Long> {

	/**
	 * Este método obtiene una valoración de tipo venta web por el ID de activo.
	 *
	 * @param idActivo : ID del activo para obtener la valoración.
	 * @return Devuelve el importe de la valoración.
	 */
	Double getImporteValoracionVentaWebPorIdActivo(Long idActivo);

	/**
	 * Este método obtiene una valoración de tipo renta web por el ID de activo.
	 *
	 * @param idActivo : ID del activo para obtener la valoración.
	 * @return Devuelve el importe de la valoración.
	 */
	Double getImporteValoracionRentaWebPorIdActivo(Long idActivo);
	
	/**
	 * Este método obtiene la fecha del último cambio del precio web del activo.
	 *
	 * @param idActivo : ID del activo para obtener la fecha.
	 * @return Devuelve el la fecha del cambio.
	 */
	Date getDateCambioPrecioWebVenta(Long idActivo);
	
	/**
	 * Este método obtiene la fecha del último cambio del precio  de alquiler web del activo.
	 *
	 * @param idActivo : ID del activo para obtener la fecha.
	 * @return Devuelve el la fecha del cambio.
	 */
	Date getDateCambioPrecioWebAlquiler(Long idActivo);
	
	/**
	 * Este método obtiene la fecha del último cambio del precio  de alquiler web del activo.
	 *
	 * @param idActivo : ID del activo para obtener la fecha.
	 * @return Devuelve la ultima valoracion de alquiler del activo.
	 */
	ActivoValoraciones getUltimaValoracionAlquiler(Long idActivo);
	
	/**
	 * Este método obtiene la fecha del último cambio del precio  de alquiler web del activo.
	 *
	 * @param idActivo : ID del activo para obtener la fecha.
	 * @return Devuelve la ultima valoracion de venta del activo.
	 */
	ActivoValoraciones getUltimaValoracionVenta(Long idActivo);
}
