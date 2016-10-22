package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;

public interface ResolucionComiteApi {

	
	
	/**
	 * Crea una nueva ResolucionComite a partir de la información pasada por
	 * parámetro.
	 * 
	 * @param resolucionComiteDto con la información de la resolucion a dar de alta
	 * @return ResolucionComiteBankia
	 */
	public ResolucionComiteBankia saveResolucionComite(ResolucionComiteDto resolucionComiteDto) throws Exception ;

}
