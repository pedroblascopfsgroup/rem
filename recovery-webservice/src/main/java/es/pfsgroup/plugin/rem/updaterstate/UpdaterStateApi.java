package es.pfsgroup.plugin.rem.updaterstate;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.GastoProveedor;

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
	 * Actualiza los estados de los check de admisión y gestión de la cabecera de los activos (y la disponibilidad comercial)
	 * @param activo
	 */
	public void updaterStates(Activo activo);
	
	/**
	 * Actualiza el estado de disponibilidad comercial del activo
	 * @param activo
	 */
	public void updaterStateDisponibilidadComercial(Activo activo);

	/**
	 * Actualiza el estado de un gasto
	 * @param gasto
	 * @param codigo
	 */
	void updaterStates(GastoProveedor gasto, String codigo);
	
}
