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
	 * @param dtoCambioEstadoPublicacion: DTO con la información obtenida.
	 */
	public boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion);

	/**
	 * Método que obtiene el estado de publicación por el ID del activo, así como su motivo y las observaciones si tuviese.
	 * 
	 * @param id: ID del activo a filtrar.
	 * @return Devuelve el estado de publicación en el que se encuentra el activo.
	 */
	public DtoCambioEstadoPublicacion getHistoricoEstadoPublicacionByActivo(Long id);
}
