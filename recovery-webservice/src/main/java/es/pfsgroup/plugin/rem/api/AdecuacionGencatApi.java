package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.AdecuacionGencat;

public interface AdecuacionGencatApi {
	
	/**
	 * 
	 * Método que devuelve los registros relacionados con un idActivo
	 * 
	 * @param idActivo
	 * @return
	 */
	public AdecuacionGencat getAdecuacionByIdActivo(Long idActivo);
	
	/**
	 * 
	 * Método que devuelve una adecuacion a partir de un de la comunicacion 
	 * 
	 * @param idComunicacionGencat
	 * @return
	 */
	public AdecuacionGencat getAdecuacionByIdComunicacion(Long idComunicacionGencat);
			
	/**
	 * Método que realiza la persistencia de datos de un objecto de tipo ComunicacionGencat
	 * 
	 * @param comunicacionGencat
	 */
	public void saveOrUpdate(AdecuacionGencat adecuacionGencat);

}