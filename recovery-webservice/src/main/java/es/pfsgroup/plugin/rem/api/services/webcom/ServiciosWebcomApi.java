package es.pfsgroup.plugin.rem.api.services.webcom;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;

public interface ServiciosWebcomApi {
	
	/**
	 * Envia a WEBCOM una actualización del estado del Trabajo
	 * @param estadoTrabajo Lista de DTO's con los cambios de estado que queremos notificar
	 */
	public void enviaActualizacionEstadoTrabajo(List<EstadoTrabajoDto> estadoTrabajo);
	
	/**
	 * Envia a WEBCOM una actualización del estado de una Oferta.
	 * @param estadoOferta Lista de DTO's con los cambios de estado que queremos notificar.
	 */
	public void enviaActualizacionEstadoOferta(List<EstadoOfertaDto> estadoOferta);
	
	/**
	 * Envia a WEBCOM una actualización del stock de activos
	 * @param usuarioId ID del usuario que realiza la petición
	 * @param stock Stock de activos (alta/modificación)
	 */
	public void enviarStock(List<StockDto> stock);

}
