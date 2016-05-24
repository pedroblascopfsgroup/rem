package es.pfsgroup.plugin.precontencioso.observacion.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.precontencioso.obervacion.model.ObservacionPCO;
import es.pfsgroup.plugin.precontencioso.observacion.dao.ObservacionDao;

@Repository
@SuppressWarnings("unchecked")
public class ObservacionDaoImpl extends AbstractEntityDao<ObservacionPCO, Long> implements ObservacionDao {
	
	@Override
	public List<ObservacionPCO> getObservacionesPorIdProcedimientoPCO(Long idProcedimientoPCO) {

		StringBuilder hql = new StringBuilder();
		StringBuilder andHql = new StringBuilder();
		
		hql.append(" from ObservacionPCO obs");
		andHql.append(" and obs.auditoria.borrado = 0");
		
		hql.append(" where obs.procedimientoPCO.id = " + idProcedimientoPCO
				+ andHql);
		hql.append(" order by obs.fechaAnotacion DESC");
		
		Query query = getSession().createQuery(hql.toString());
		
		return (List<ObservacionPCO>) query.list();
		/*Criteria query = getSession().createCriteria(ObservacionPCO.class).setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		query.createAlias("procedimientoPCO", "procedimientoPCO");
		query.add(Restrictions.eq("procedimientoPCO.id", idProcedimientoPCO));	
		
		List<ObservacionPCO> observaciones = query.list();
		return observaciones;*/
	}

}
