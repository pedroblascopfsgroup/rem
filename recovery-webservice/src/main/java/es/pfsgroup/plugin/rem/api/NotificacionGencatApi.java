package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.NotificacionGencat;

public interface NotificacionGencatApi {
	
	/**
	 * 
	 * Método que devuelve una notificación a partir de un de la comunicación 
	 * 
	 * @param idComunicacionGencat
	 * @return
	 */
	public NotificacionGencat getNotificacionByIdComunicacionGencat(Long idComunicacionnGencat);
			
	/**
	 * Método que realiza la persistencia de datos de un objecto de tipo OfertaGencat
	 * 
	 * @param notificacionGencat
	 */
	public void saveOrUpdate(NotificacionGencat notificacionGencat);

}