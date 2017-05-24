package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

public interface NotificacionApi {

	/**
	 * Este método envia al gestor del activo una notificación si no tiene el OK de admisión.
	 * 
	 * @param activo: lista con los activos a comprobar.
	 */
	public void enviarNotificacionKOadmisionPorActivo(List<Activo> activo);
	
	/**
	 * Este método envia al gestor del activo una notificación si no tiene el OK de gestión.
	 * 
	 * @param activo: lista con los activos a comprobar.
	 */
	public void enviarNotificacionKOgestionPorActivo(List<Activo> activo);
	
	/**
	 * Cuando se aprueba un expediente, si alguno de los activos no cuenta con
	 * el OK de admisión o el OK de gestión, se le envia una notificación al
	 * gestor correspondiente.
	 * 
	 * @param expediente: recuperar todos los activos de la oferta del expediente.
	 */
	public void enviarNotificacionPorActivosAdmisionGestion(ExpedienteComercial expediente);

}
