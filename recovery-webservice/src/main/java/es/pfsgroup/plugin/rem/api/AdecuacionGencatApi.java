package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.AdecuacionGencat;

public interface AdecuacionGencatApi {
	
	/**
	 * 
	 * Método que devuelve los registros relacionados con un idActivo
	 * 
	 * @param idActivo
	 * @return
	 */
	public AdecuacionGencat getByIdActivo(Long idActivo);
			
	/**
	 * Método que realiza la persistencia de datos de un objecto de tipo ComunicacionGencat
	 * 
	 * @param comunicacionGencat
	 */
	public void saveOrUpdate(AdecuacionGencat adecuacionGencat);

}