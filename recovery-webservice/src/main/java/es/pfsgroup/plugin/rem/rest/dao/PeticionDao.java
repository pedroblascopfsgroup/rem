package es.pfsgroup.plugin.rem.rest.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;

public interface PeticionDao  extends AbstractDao<PeticionRest, Long>{
	
	/**
	 * Indica si ya se ha ejecutado una peticion con este token
	 * @param token
	 * @return boolean
	 */
	public boolean existePeticionToken(String token,Long idBroker);
	
	
	/**
	 * Devuelve la última peticion realizada por token
	 * @param token de la peticion a consultar
	 * @return PeticionRest
	 */
	public PeticionRest getLastPeticionByToken(String token);
	

}
