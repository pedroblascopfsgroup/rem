package es.pfsgroup.plugin.rem.rest.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.rest.dao.PeticionDao;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;

@Repository("PeticionDaoImpl")
public class PeticionDaoImpl extends AbstractEntityDao<PeticionRest, Long> implements PeticionDao{

	@Transactional
	@Override
	public boolean existePeticionToken(String token,Long idBroker) {
		HQLBuilder hb = new HQLBuilder("from PeticionRest");
		HQLBuilder.addFiltroIgualQue(hb,  "token", token);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "broker.id", idBroker);
		HQLBuilder.addFiltroIgualQue(hb,  "result", "OK");
		return !HibernateQueryUtils.list(this, hb).isEmpty();
	}

	@Override
	public PeticionRest getLastPeticionByToken(String token) {
		PeticionRest peticion = null;
		
		HQLBuilder hb = new HQLBuilder("from PeticionRest");
		HQLBuilder.addFiltroIgualQue(hb,  "token", token);
		List<PeticionRest> peticiones = HibernateQueryUtils.list(this, hb);
		
		if(!Checks.esNulo(peticiones) && peticiones.size() > 0){
			peticion = peticiones.get(peticiones.size()-1);
		}
		return peticion;
	}
	
	
	
}
