package es.pfsgroup.plugin.rem.api.services.webcom;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;

public interface ServiciosWebcomApi {

	/**
	 * Envia a WEBCOM una actualización del estado del Trabajo
	 * 
	 * @param estadoTrabajo
	 *            Lista de DTO's con los cambios de estado que queremos
	 *            notificar
	 */
	public void enviaActualizacionEstadoTrabajo(List<EstadoTrabajoDto> estadoTrabajo);

	/**
	 * Envia a WEBCOM una actualización del estado de una Oferta.
	 * 
	 * @param estadoOferta
	 *            Lista de DTO's con los cambios de estado que queremos
	 *            notificar.
	 */
	public void enviaActualizacionEstadoOferta(List<EstadoOfertaDto> estadoOferta);

	/**
	 * Envia a WEBCOM una actualización del stock de activos
	 * 
	 * @param stock
	 *            Stock de activos (alta/modificación)
	 */
	public void enviarStock(List<StockDto> stock);

	/**
	 * Honorarios asociados a una oferta una vez se apruebe ésta, también viaja
	 * las observaciones del gestor comercial a la NO aceptación de los mismos
	 * por el mediador.
	 * 
	 * @param notificaciones
	 */
	public void estadoNotificacion(List<NotificacionDto> notificaciones);

	/**
	 * Honorarios asociados a una oferta una vez se apruebe ésta, también viaja
	 * las observaciones del gestor comercial a la NO aceptación de los mismos
	 * por el mediador.
	 * 
	 * @param comisiones
	 */
	public void ventasYcomisiones(List<ComisionesDto> comisiones);

}
