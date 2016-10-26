package es.pfsgroup.plugin.rem.rest.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.rest.dao.PeticionDao;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;

@Repository("PeticionDaoImpl")
public class PeticionDaoImpl extends AbstractEntityDao<PeticionRest, Long> implements PeticionDao {

	@Transactional
	@Override
	public boolean existePeticionToken(String token, Long idBroker) {
		HQLBuilder hb = new HQLBuilder("from PeticionRest");
		HQLBuilder.addFiltroIgualQue(hb, "token", token);
		if (idBroker == new Long(-1)) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "broker.id", idBroker);
		}
		HQLBuilder.addFiltroIgualQue(hb, "result", "OK");
		return !HibernateQueryUtils.list(this, hb).isEmpty();
	}

	@Override
	public PeticionRest getLastPeticionByToken(String token) {
		PeticionRest peticion = null;

		HQLBuilder hb = new HQLBuilder("from PeticionRest");
		HQLBuilder.addFiltroIgualQue(hb, "token", token);
		List<PeticionRest> peticiones = HibernateQueryUtils.list(this, hb);

		if (peticiones != null) {
			for (PeticionRest peticionAux : peticiones) {
				if (peticion == null || peticionAux.getAuditoria().getFechaCrear()
						.compareTo(peticion.getAuditoria().getFechaCrear()) > 0) {
					peticion = peticionAux;
				}
			}
		}

		return peticion;
	}

}
