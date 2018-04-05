package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.validate.validator.DtoPublicacionValidaciones;

import java.sql.SQLException;


public interface ActivoEstadoPublicacionApi {

	/**
	 * Método que obtiene el estado de publicación actual de un activo.
	 *
	 * @param idActivo
	 * @return DtoCambioEstadoPublicacion
	 */
	DtoCambioEstadoPublicacion getState(Long idActivo);

	/**
	 * Método que cambia el estado de publicación de un activo en base a los check marcados en la pestaña datos de la publicación, aplicando TODAS las validaciones para publicar
	 *
	 * @param dtoCambioEstadoPublicacion: DTO con la información obtenida.
	 * @throws SQLException
	 * @throws JsonViewerException
	 */
	boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion) throws SQLException, JsonViewerException;

	/**
	 * Método que cambia el estado de publicación de un activo en base a los check marcados en la pestaña datos de la publicación, permitiendo configurar las validaciones necesarias para publicar
	 *
	 * @param dtoCambioEstadoPublicacion
	 * @param validacionesPublicacion
	 * @return
	 * @throws SQLException
	 * @throws JsonViewerException
	 */
	boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion, DtoPublicacionValidaciones validacionesPublicacion) throws SQLException, JsonViewerException;

	/**
	 * Método que obtiene el estado de publicación por el ID del activo, así como su motivo y las observaciones si tuviese.
	 *
	 * @param id: ID del activo a filtrar.
	 * @return Devuelve el estado de publicación en el que se encuentra el activo.
	 */
	DtoCambioEstadoPublicacion getHistoricoEstadoPublicacionByActivo(Long id);

	/**
	 * Cambia al NUEVO ESTADO DE PUBLICACION y REGISTRA EN EL HISTORICO DE PUBLICACION
	 *
	 * @param activo
	 * @param motivo
	 * @param filtro
	 * @param estadoPublicacionActual
	 * @param isPublicacionForzada
	 * @param isPublicacionOrdinaria
	 * @return
	 * @throws JsonViewerException
	 * @throws SQLException
	 */
	boolean cambiarEstadoPublicacionAndRegistrarHistorico(Activo activo, String motivo, Filter filtro, DDEstadoPublicacion estadoPublicacionActual, Boolean isPublicacionForzada, Boolean
			isPublicacionOrdinaria) throws SQLException, JsonViewerException;

	/**
	 * Este método obtiene los datos de publicación referente al ID de activo que recibe.
	 *
	 * @param idActivo: ID del activo para obtener los datos.
	 * @return Devuelve un DTO con los datos de publicación del activo.
	 */
	DtoDatosPublicacionActivo getDatosPublicacionActivo(Long idActivo);

	/**
	 * Este método persiste en la DB los datos de la pantalla de datos de publicación del activo por ID de activo.
	 *
	 * @param dto: dto con los datos a guardar en la DB.
	 * @return Devuelve True si la operación ha sido satisfactoria.
	 * @throws JsonViewerException Devuelve una excepción con un mensaje hacia la interfaz si el método falla.
	 */
	Boolean setDatosPublicacionActivo(DtoDatosPublicacionActivo dto) throws JsonViewerException;

	/**
	 * Este método obtiene el histórico de estados de publicación por los que ha pasado un activo
	 * con tipo de comercialización venta.
	 *
	 * @param dto: dto con el ID del activo para filtrar los datos.
	 * @return Devuleve un listado de DtoEstadoPublicacion con los datos obtenidos.
	 */
	DtoPaginadoHistoricoEstadoPublicacion getHistoricoEstadosPublicacionVentaByIdActivo(DtoPaginadoHistoricoEstadoPublicacion dto);

	/**
	 * Este método obtiene el histórico de estados de publicación por los que ha pasado un activo
	 * con tipo de comercialización alquiler.
	 *
	 * @param dto: dto con el ID del activo para filtrar los datos.
	 * @return Devuleve un listado de DtoEstadoPublicacion con los datos obtenidos.
	 */
	DtoPaginadoHistoricoEstadoPublicacion getHistoricoEstadosPublicacionAlquilerByIdActivo(DtoPaginadoHistoricoEstadoPublicacion dto);
	
	/**
	 * Este método obtiene el estado de publicar sin precio para venta y alquiler dado un id de activo
	 * @param idActivo: id del activo para obtener su publicar sin precio
	 * @return devuelve un dto con los datos
	 */
	DtoDatosPublicacionActivo getPublicarSinPrecioVentaAlquilerByIdActivo(Long idActivo);

	/**
	 * Este método comprueba si un activo consta de precio de venta web.
	 *
	 * @param idActivo: ID del activo a comprobar.
	 * @return Devuelve True si el activo tiene precio de venta web, False si no tiene el precio establecido.
	 */
	Boolean tienePrecioVentaByIdActivo(Long idActivo);

	/**
	 * Este método comprueba si un activo consta de precio de renta web.
	 *
	 * @param idActivo: ID del activo a comprobar.
	 * @return Devuelve True si el activo tiene precio de renta web, False si no tiene el precio establecido.
	 */
	Boolean tienePrecioRentaByIdActivo(Long idActivo);
}
