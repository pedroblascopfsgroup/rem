package es.pfsgroup.plugin.rem.api.services.webcom;

public interface ServiciosWebcomApi {
	
	/**
	 * Envia a WEBCOM una actualización del estado del trabajo
	 * @param idRem ID del Trabajo en REM
	 * @param idWebcom ID del Trabajo en WEBCOM
	 * @param idEstado Estado del Trabajo
	 * @param motivoRechazo Motivo de rechazo del trabajo.
	 */
	public void enviaActualizacionEstadoTrabajo(Long idRem, Long idWebcom, Long idEstado, String motivoRechazo);

}
