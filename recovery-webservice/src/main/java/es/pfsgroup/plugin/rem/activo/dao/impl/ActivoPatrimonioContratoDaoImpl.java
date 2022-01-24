package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioContratoDao;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonioContrato;
import es.pfsgroup.plugin.rem.model.DtoActivoVistaPatrimonioContrato;

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
	public Page getActivosRelacionados(DtoActivoVistaPatrimonioContrato dto) {
		HQLBuilder hb = new HQLBuilder(" from VActivoPatrimonioContrato va");
		HQLBuilder.addFiltroIgualQue(hb, "va.idContrato", dto.getIdContrato());
		HQLBuilder.addFiltroIgualQue(hb, "va.nombrePrinex", dto.getNombrePrinex());
		hb.appendWhere("va.activo != " + dto.getActivo());

		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@Override
	@Transactional
	public ActivoPatrimonio getActivoPatrimonioByActivo(Long idActivo) {
		Criteria criteria = this.getSessionFactory().getCurrentSession().createCriteria(ActivoPatrimonio.class);
		criteria.add(Restrictions.eq("activo.id", idActivo));

		return HibernateUtils.castObject(ActivoPatrimonio.class, criteria.uniqueResult());
	}


}
