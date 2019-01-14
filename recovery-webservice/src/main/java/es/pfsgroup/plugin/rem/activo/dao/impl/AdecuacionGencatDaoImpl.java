package es.pfsgroup.plugin.rem.activo.dao.impl;


import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.dao.AdecuacionGencatDao;
import es.pfsgroup.plugin.rem.model.AdecuacionGencat;

@Repository("AdecuacionGencat")
public class AdecuacionGencatDaoImpl extends AbstractEntityDao<AdecuacionGencat, Long> implements AdecuacionGencatDao {

	@Override
	public AdecuacionGencat getAdecuacionByComunicacionGencat(Long comunicacionId) {

		return null;
		
	}
		
}
