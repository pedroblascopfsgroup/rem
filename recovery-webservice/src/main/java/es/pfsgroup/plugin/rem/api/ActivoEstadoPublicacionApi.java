package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;

public interface ActivoEstadoPublicacionApi {

	/**
	 * Método que obtiene el estado de publicación actual de un activo.
	 * @param idActivo
	 * @return DtoCambioEstadoPublicacion
	 */
	public DtoCambioEstadoPublicacion getState(Long idActivo);
	
	/**
	 * Método que cambia el estado de publicación de un activo en base a los check marcados en la pestaña
	 * datos de la publicación
	 * @param dtoCambioEstadoPublicacion
	 */
	public boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion);
}
