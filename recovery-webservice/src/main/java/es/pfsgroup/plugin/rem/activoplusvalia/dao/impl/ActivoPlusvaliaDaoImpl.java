package es.pfsgroup.plugin.rem.activoplusvalia.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activoplusvalia.dao.ActivoPlusvaliaDao;
import es.pfsgroup.plugin.rem.model.ActivoPlusvalia;

@Repository("ActivoPlusvaliaDao")
public class ActivoPlusvaliaDaoImpl extends AbstractEntityDao<ActivoPlusvalia, Long> implements ActivoPlusvaliaDao{
			
	@Override
	public ActivoPlusvalia getPlusvaliaByIdActivo(Long idActivo) {
		Criteria criteria = getSession().createCriteria(ActivoPlusvalia.class);
		criteria.add(Restrictions.eq("activo.id", idActivo));

		return HibernateUtils.castObject(ActivoPlusvalia.class, criteria.uniqueResult());
	}
}
