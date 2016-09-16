package es.pfsgroup.plugin.rem.api.services.webcom;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;

public interface ServiciosWebcomApi {
	
	/**
	 * Envia a WEBCOM una actualización del estado del Trabajo
	 * @param usuarioId ID del usuario que realiza la petición
	 * @param idRem ID del Trabajo en REM (obligatorio)
	 * @param idWebcom ID del Trabajo en WEBCOM (obligatorio)
	 * @param codEstado Estado del Trabajo (obligatorio)
	 * @param motivoRechazo Motivo de rechazo del trabajo.
	 */
	public void enviaActualizacionEstadoTrabajo(Long usuarioId, Long idRem, Long idWebcom, String codEstado, String motivoRechazo);
	
	/**
	 * Envia a WEBCOM una actualización del estado de una Oferta.
	 * @param usuarioId ID del usuario que realiza la petición
	 * @param idRem ID de la Oferta en REM (obligatorio)
	 * @param idWebcom ID de la Oferta en WEBCOM (obligatorio)
	 * @param codEstadoOferta  (obligatorio)
	 * @param idActivoHaya ID del Activo 
	 * @param codEstadoExpediente ID del estado del Expediente
	 * @param vendido Flag que indica si el activo está vendido.
	 */
	public void enviaActualizacionEstadoOferta(Long usuarioId, Long idRem, Long idWebcom, String codEstadoOferta, Long idActivoHaya, String codEstadoExpediente, Boolean vendido);
	
	/**
	 * Envia a WEBCOM una actualización del stock de activos
	 * @param usuarioId ID del usuario que realiza la petición
	 * @param stock Stock de activos (alta/modificación)
	 */
	public void enviarStock(Long usuarioId, List<StockDto> stock);

}
