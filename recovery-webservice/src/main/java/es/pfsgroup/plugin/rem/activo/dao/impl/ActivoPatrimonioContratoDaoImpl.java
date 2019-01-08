package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioContratoDao;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonioContrato;
import es.pfsgroup.plugin.rem.model.VActivoPatrimonioContrato;

@Repository("ActivoPatrimonioContratoDao")
public class ActivoPatrimonioContratoDaoImpl extends AbstractEntityDao<ActivoPatrimonioContrato, Long>  implements ActivoPatrimonioContratoDao{


	
	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoPatrimonioContrato> getActivoPatrimonioContratoByActivo(Long idActivo) {
		DetachedCriteria criteria = DetachedCriteria.forClass(ActivoPatrimonioContrato.class);
		criteria.add(Restrictions.eq("activo.id", idActivo));
		criteria.addOrder(Order.asc("fechaFirma"));

		return getHibernateTemplate().findByCriteria(criteria);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VActivoPatrimonioContrato> getActivosRelacionados(Long idActivo) {
		DetachedCriteria criteria = DetachedCriteria.forClass(VActivoPatrimonioContrato.class);
		criteria.add(Restrictions.eq("activo.id", idActivo));

		return getHibernateTemplate().findByCriteria(criteria);
	}


}
