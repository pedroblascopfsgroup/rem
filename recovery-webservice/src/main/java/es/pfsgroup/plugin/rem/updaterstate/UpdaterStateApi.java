package es.pfsgroup.plugin.rem.updaterstate;

import es.pfsgroup.plugin.rem.model.Activo;

public interface UpdaterStateApi {
	/**
	 * 
	 * @param activo
	 * @return Devuelve true si el estado de admisión es OK y false si es KO.
	 */
	public Boolean getStateAdmision(Activo activo);
	
	/**
	 * 
	 * @param activo
	 * @return Devuelve true si el estado de gestión es OK y false si es KO.
	 */
	public Boolean getStateGestion(Activo activo);
	
	/**
	 * Actualiza los estados de los check de admisión y gestión de la cabecera de los activos
	 * @param activo
	 */
	public void updaterStates(Activo activo);
}
