package es.pfsgroup.plugin.rem.activo.dao.impl;


import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.dao.ReclamacionGencatDao;
import es.pfsgroup.plugin.rem.model.ReclamacionGencat;

@Repository("ReclamacionGencatDAO")
public class ReclamacionGencatDaoImpl extends AbstractEntityDao<ReclamacionGencat, Long> implements ReclamacionGencatDao {

	@Override
	public ReclamacionGencat getReclamacionByComunicacionGencatId(Long comunicacionId) {
		
		Criteria criteria = getSession().createCriteria(ReclamacionGencat.class);
		criteria.createCriteria("comunicacion").add(Restrictions.eq("id", comunicacionId));
		
		return HibernateUtils.castObject(ReclamacionGencat.class, criteria.uniqueResult());
	}
	   	
}
