package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.OfertaGencat;

public interface OfertaGencatApi {
	
	/**
	 * 
	 * Método que devuelve una oferta a partir de un de la comunicacion 
	 * 
	 * @param idComunicacionGencat
	 * @return
	 */
	public OfertaGencat getOfertaByIdComunicacionGencat(Long idComunicacionGencat);
			
	/**
	 * Método que realiza la persistencia de datos de un objecto de tipo OfertaGencat
	 * 
	 * @param comunicacionGencat
	 */
	public void saveOrUpdate(OfertaGencat ofertaGencat);

}