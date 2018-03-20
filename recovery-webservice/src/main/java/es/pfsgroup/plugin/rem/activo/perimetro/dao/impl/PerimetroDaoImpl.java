package es.pfsgroup.plugin.rem.activo.perimetro.dao.impl;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.perimetro.dao.PerimetroDao;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

@Repository("PerimetroDao")
public class PerimetroDaoImpl extends AbstractEntityDao<PerimetroActivo, Long> implements PerimetroDao {

	@Override
	public PerimetroActivo getPerimetroActivoByIdActivo(Long idActivo) {
		Criteria criteria = getSession().createCriteria(PerimetroActivo.class);
		criteria.add(Restrictions.eq("activo.id", idActivo));

		return HibernateUtils.castObject(PerimetroActivo.class, criteria.uniqueResult());
	}
}