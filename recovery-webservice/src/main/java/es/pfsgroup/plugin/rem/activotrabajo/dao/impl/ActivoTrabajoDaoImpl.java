package es.pfsgroup.plugin.rem.activotrabajo.dao.impl;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.rem.activotrabajo.dao.ActivoTrabajoDao;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;

@Repository("ActivoTrabajoDao")
public class ActivoTrabajoDaoImpl extends AbstractEntityDao<ActivoTrabajo, Long> implements ActivoTrabajoDao{
			
	@Override
	public ActivoTrabajo findOne(Long idActivo,	Long idTrabajo) {
		
		HQLBuilder hql = new HQLBuilder("from ActivoTrabajo");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "activo", idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "trabajo", idTrabajo);
		
		Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(q, hql);
		
		return (ActivoTrabajo) q.uniqueResult();
	}
}
