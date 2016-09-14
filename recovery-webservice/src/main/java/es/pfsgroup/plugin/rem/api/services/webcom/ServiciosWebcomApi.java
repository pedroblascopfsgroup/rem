package es.pfsgroup.plugin.rem.api.services.webcom;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;

public interface ServiciosWebcomApi {
	
	/**
	 * Envia a WEBCOM una actualización del estado del Trabajo
	 * @param idRem ID del Trabajo en REM (obligatorio)
	 * @param idWebcom ID del Trabajo en WEBCOM (obligatorio)
	 * @param idEstado Estado del Trabajo (obligatorio)
	 * @param motivoRechazo Motivo de rechazo del trabajo.
	 */
	public void enviaActualizacionEstadoTrabajo(Long idRem, Long idWebcom, Long idEstado, String motivoRechazo);
	
	/**
	 * Envia a WEBCOM una actualización del estado de una Oferta.
	 * @param idRem ID de la Oferta en REM (obligatorio)
	 * @param idWebcom ID de la Oferta en WEBCOM (obligatorio)
	 * @param idEstadoOferta  (obligatorio)
	 * @param idActivoHaya ID del Activo 
	 * @param idEstadoExpediente ID del estado del Expediente
	 * @param vendido Flag que indica si el activo está vendido.
	 */
	public void enviaActualizacionEstadoOferta(Long idRem, Long idWebcom, Long idEstadoOferta, Long idActivoHaya, Long idEstadoExpediente, Boolean vendido);
	
	public void enviarStock(List<StockDto> stock);

}
