package es.pfsgroup.plugin.rem.oferta.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.VPropuestaAlqBankia;
import es.pfsgroup.plugin.rem.oferta.dao.VPropuestaAlqBankiaDao;

@Repository("VPropuestaAlqBankiaDao")
public class VPropuestaAlqBankiaDaoImpl extends AbstractEntityDao<VPropuestaAlqBankia, Long> implements VPropuestaAlqBankiaDao {
	
	public List<VPropuestaAlqBankia> getListPropuestasAlqBankiaFromView(Long ecoId) {

		HQLBuilder hb = new HQLBuilder(" from VPropuestaAlqBankia vprop");

		if (!Checks.esNulo(ecoId)) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vprop.id", ecoId);
		}

		return HibernateQueryUtils.list(this, hb);

	}


}
