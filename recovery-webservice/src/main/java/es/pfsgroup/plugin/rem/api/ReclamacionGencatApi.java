package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.ReclamacionGencat;

public interface ReclamacionGencatApi {
	
	/**
	 * 
	 * Método que devuelve una reclamacion a partir de un de la comunicación 
	 * 
	 * @param idComunicacionGencat
	 * @return
	 */
	public List<ReclamacionGencat> getReclamacionByIdComunicacionGencat(Long idComunicacionnGencat);
			
	/**
	 * Método que realiza la persistencia de datos de un objecto de tipo ReclamacionGencat
	 * 
	 * @param notificacionGencat
	 */
	public void saveOrUpdate(ReclamacionGencat reclamacionGencat);

}