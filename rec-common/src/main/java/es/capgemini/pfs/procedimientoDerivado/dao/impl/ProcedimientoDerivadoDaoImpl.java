package es.capgemini.pfs.procedimientoDerivado.dao.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Expression;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procedimientoDerivado.dao.ProcedimientoDerivadoDao;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;

/**
 * Creado el Thu Jan 15 12:48:24 CET 2009.
 *
 * @author: Lisandro Medrano
 */
@Repository("ProcedimientoDerivadoDao")
public class ProcedimientoDerivadoDaoImpl extends AbstractEntityDao<ProcedimientoDerivado, Long> implements ProcedimientoDerivadoDao {

	@Override
	public ProcedimientoDerivado getByGuid(String guid) {
		
		DetachedCriteria criteria = DetachedCriteria.forClass(ProcedimientoDerivado.class, "prd");
		criteria.add(Expression.eq("prd.guid", guid));
		
		@SuppressWarnings("unchecked")
		List<ProcedimientoDerivado> list = getHibernateTemplate().findByCriteria(criteria);
		if(list.size() > 0) {
			return list.get(0);
		}
		else {
			return null;
		}
	}
}
