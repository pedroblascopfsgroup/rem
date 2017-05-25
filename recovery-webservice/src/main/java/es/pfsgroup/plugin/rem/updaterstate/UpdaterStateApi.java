package es.pfsgroup.plugin.rem.updaterstate;

import java.util.List;

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
	 * Actualiza el estado de disponibilidad comercial del activo, guarda el cambio en bddd
	 * @param idActivo
	 */
	public void updaterStateDisponibilidadComercialAndSave(Long idActivo);
	
	/**
	 * Actualiza el estado de disponibilidad comercial del activo, guarda el cambio en bddd
	 * @param activo
	 */
	public void updaterStateDisponibilidadComercialAndSave(Activo activo);
	
	/**
	 * Actualiza el tipo de comercialización del activo (Singular / Retail)
	 * @param activo
	 */
	public void updaterStateTipoComercializacion(Activo activo);
	
	/**
	 * Calcula la participación de cada activo dependiendo de la cartera.
	 * @param codigoTipoTrabajo : se pasan el codigo del trabajo.
	 * @param activosLista : se pasan la lista de todos los activos a calcular.
	 * @param activo : es el activo que se calcula.
	 */
	public String calcularParticipacionPorActivo(String codigoTipoTrabajo, List<Activo> activosLista, Activo activo_check);

	
}
