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
	 * Este método obtiene una valoración de tipo venta web por el ID de agrupacion.
	 *
	 * @param idAgrupacion : ID de la agrupación para obtener la valoración.
	 * @return Devuelve el importe de la valoración.
	 */
	Double getImporteValoracionVentaWebPorIdAgrupacion(Long idAgrupacion);

	/**
	 * Este método obtiene una valoración de tipo renta web por el ID de agrupacion.
	 *
	 * @param idAgrupacion : ID de la agrupacion para obtener la valoración.
	 * @return Devuelve el importe de la valoración.
	 */
	Double getImporteValoracionRentaWebPorIdAgrupacion(Long idAgrupacion);
}
