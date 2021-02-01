package es.pfsgroup.plugin.rem.updaterstate;

import java.util.HashMap;
import java.util.List;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;

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
	 * 
	 * @param activo
	 */
	public void updaterStateDisponibilidadComercialAndSave(Activo activo);
	
	/**
	 * Actualiza el estado de disponibilidad comercial del activo, guarda el cambio en bddd
	 * @param activo
	 */
	public void updaterStateDisponibilidadComercialAndSave(Activo activo, Boolean express);
	
	/**
	 * Actualiza el tipo de comercialización del activo (Singular / Retail)
	 * @param activo
	 */
	public void updaterStateTipoComercializacion(Activo activo);
	
	/**
	 * Calcula la participación de cada activo dependiendo de la cartera. 
	 * Sólo funciona en trabajos de obtención documental o actuación técnica.
	 * @param codigoTipoTrabajo : se pasan el codigo del trabajo.
	 * @param activosLista : se pasan la lista de todos los activos a calcular(Se puede dejar en null si solamente se quiere calcular un activo).
	 * @param activo_check : es el activo que se calcula.
	 */
	public Double calcularParticipacionPorActivo(String codigoTipoTrabajo, List<Activo> activosLista, Activo activo_check, HashMap<Activo, List<ActivoValoraciones>> valoraciones);
	
	/**
	 * Recalcula la participación de cada activo dependiendo de la cartera. 
	 * Sólo funciona en trabajos de obtención documental o actuación técnica.
	 * Sólo funciona para trabajos ya creados.
	 * @param idTrabajo : se pasan el codigo del trabajo.
	 */
	public void recalcularParticipacion(Long idTrabajo);
	
	public Double calcularParticipacionValorPorActivo(String codigoTipoTrabajo, Activo activo);
	
	public HashMap<Activo, List<ActivoValoraciones>> obtenerValoracionesActivos(List<Activo> activosLista);
}
