package es.pfsgroup.plugin.rem.bulkAdvisoryNote.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.rem.bulkAdvisoryNote.dao.BulkOfertaDao;
import es.pfsgroup.plugin.rem.model.BulkOferta;

@Repository("BulkOfertaDao")
public class BulkOfertaDaoImpl extends AbstractEntityDao<BulkOferta, Long> implements BulkOfertaDao{
			
	@Override
	public BulkOferta findOne(Long idBulk, Long idOferta, Boolean borrado) {
		
		HQLBuilder hql = new HQLBuilder("from BulkOferta");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "bulkAdvisoryNote.id", idBulk);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "oferta.id", idOferta);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "auditoria.borrado", borrado);
		
		Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(q, hql);
		
		return (BulkOferta) q.uniqueResult();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BulkOferta> getListBulkOfertasByIdBulk(Long idBulk) {

		
		HQLBuilder hql = new HQLBuilder("from BulkOferta");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "bulkAdvisoryNote.id", idBulk);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "auditoria.borrado", false);
		
		Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(q, hql);
		
		return q.list();
	}
	
	public void flush() {
		this.getSessionFactory().getCurrentSession().flush();
	}
}
