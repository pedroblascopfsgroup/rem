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
	
	/**
	 * HREOS-843 Setea la disponibilidad comercial del activo según ciertas características
	 * Criteríos con orden de prioridad, si el primero no cumple, comprueba el siguiente, y así con el resto
	 * 	- No comercializable: Check comercializar del perímetro no esta activado
	 * 	- Disponible venta con oferta: Contiene alguna oferta con estado Aceptada
	 *  - Disponible venta con reserva: Contiene alguna reserva con estado Firmada
	 *  - Disponible condicionado: Si algún condicionante esta activo
	 *  - Disponible venta: Tipo comercializacion del activo = Venta
	 *  - Disponible venta y alquiler: Tipo comercializacion del activo = Alquiler y venta
	 *  - Disponible alquiler: Tipo comercializacion del activo = Solo alquiler
	 * @param activo
	 */
	public void updaterStateDisponibilidadComercial(Activo activo);
}
