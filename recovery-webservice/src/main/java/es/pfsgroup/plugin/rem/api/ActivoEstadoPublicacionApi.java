package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoEstadoPublicacion;

public interface ActivoEstadoPublicacionApi {

	/**
	 * Método que cambia el estado de publicación de un activo en base a los check marcados en la pestaña
	 * datos de la publicación
	 * @param dtoCambioEstadoPublicacion
	 */
	public boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion);
}
