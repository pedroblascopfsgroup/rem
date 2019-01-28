package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.VisitaGencat;

public interface VisitaGencatApi {
	
	/**
	 * 
	 * Método que devuelve una visita a partir de un de la comunicación 
	 * 
	 * @param idComunicacionGencat
	 * @return
	 */
	public VisitaGencat getVisitaByIdComunicacionGencat(Long idComunicacionnGencat);
			
	/**
	 * Método que realiza la persistencia de datos de un objecto de tipo VisitaGencat
	 * 
	 * @param visitaGencat
	 */
	public void saveOrUpdate(VisitaGencat visitaGencat);

}