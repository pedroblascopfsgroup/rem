package es.pfsgroup.plugin.rem.activo.publicacion.dao.impl;

import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.HistoricoFasePublicacionActivoDao;
import es.pfsgroup.plugin.rem.model.HistoricoFasePublicacionActivo;

@Repository("HistoricoFasePublicacionActivoDao")
public class HistoricoFasePublicacionActivoDaoImpl extends AbstractEntityDao<HistoricoFasePublicacionActivo, Long> implements HistoricoFasePublicacionActivoDao {

	@Override
	public HistoricoFasePublicacionActivo getHistoricoFasesPublicacionActivoActualById(Long idActivo) {
		Criteria criteria = getSession().createCriteria(HistoricoFasePublicacionActivo.class);
		criteria.add(Restrictions.eq("activo.id", idActivo));
		criteria.add(Restrictions.isNotNull("fechaInicio"));
		criteria.add(Restrictions.isNull("fechaFin"));
		criteria.add(Restrictions.eq("auditoria.borrado", false));
		
		return HibernateUtils.castObject(HistoricoFasePublicacionActivo.class, criteria.uniqueResult());
	}

}
