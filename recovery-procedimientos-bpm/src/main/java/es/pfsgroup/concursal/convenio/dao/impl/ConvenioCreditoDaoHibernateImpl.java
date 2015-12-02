package es.pfsgroup.concursal.convenio.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.concursal.convenio.dao.ConvenioCreditoDao;
import es.pfsgroup.concursal.convenio.model.ConvenioCredito;

@Repository("ConvenioCreditoDao")
public class ConvenioCreditoDaoHibernateImpl extends AbstractEntityDao<ConvenioCredito, Long> implements ConvenioCreditoDao{

	@SuppressWarnings("unchecked")
	@Override
	public List<ConvenioCredito> findByIdConvenio(Long idConvenio) {
		if (Checks.esNulo(idConvenio)) throw new IllegalArgumentException("idConvenio null");
		HQLBuilder hql = new HQLBuilder("from ConvenioCredito");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "borrado", 0);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "convenio.id", idConvenio);
		Query query = getSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(query, hql);
		return query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ConvenioCredito> findByIdCredito(Long idCredito) {
		if (Checks.esNulo(idCredito)) throw new IllegalArgumentException("idCredito null");
		HQLBuilder hql = new HQLBuilder("from ConvenioCredito");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "borrado", 0);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "credito.id", idCredito);
		Query query = getSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(query, hql);
		return query.list();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<ConvenioCredito> findByIdConvenioIdCredito(Long idConvenio, Long idCredito) {
		if (Checks.esNulo(idConvenio)) throw new IllegalArgumentException("idConvenio null");
		if (Checks.esNulo(idCredito)) throw new IllegalArgumentException("idCredito null");
		HQLBuilder hql = new HQLBuilder("from ConvenioCredito");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "borrado", 0);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "convenio.id", idConvenio);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "credito.id", idCredito);
		Query query = getSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(query, hql);
		return query.list();
	}
	
}
