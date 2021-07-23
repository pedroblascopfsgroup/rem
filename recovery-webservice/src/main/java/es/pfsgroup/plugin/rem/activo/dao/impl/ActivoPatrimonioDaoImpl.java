package es.pfsgroup.plugin.rem.activo.dao.impl;

import org.hibernate.Criteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.dd.DDAdecuacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;

@Repository("ActivoPatrimonioDao")
public class ActivoPatrimonioDaoImpl extends AbstractEntityDao<ActivoPatrimonio, Long>  implements ActivoPatrimonioDao{

		
	@Override
	@Transactional
	public ActivoPatrimonio getActivoPatrimonioByActivo(Long idActivo) {
		Criteria criteria = this.getSessionFactory().getCurrentSession().createCriteria(ActivoPatrimonio.class);
		criteria.add(Restrictions.eq("activo.id", idActivo));

		return HibernateUtils.castObject(ActivoPatrimonio.class, criteria.uniqueResult());
	}

	@Override
	public DDAdecuacionAlquiler getAdecuacionAlquilerFromPatrimonioByIdActivo(Long idActivo) {
		Criteria criteria = this.getSessionFactory().getCurrentSession().createCriteria(ActivoPatrimonio.class);
		criteria.setProjection(Projections.property("adecuacionAlquiler"));
		criteria.add(Restrictions.eq("activo.id", idActivo));

		return HibernateUtils.castObject(DDAdecuacionAlquiler.class, criteria.uniqueResult());
	}

	@Override
	public boolean isAlquilerLibreByActivo(Activo activo) {
		ActivoPatrimonio patrimonio = this.getActivoPatrimonioByActivo(activo.getId());
		if ( patrimonio != null && patrimonio.getTipoEstadoAlquiler() != null) {
			return DDTipoEstadoAlquiler.ESTADO_ALQUILER_LIBRE.equals(patrimonio.getTipoEstadoAlquiler().getCodigo());	
		}
		return false;
	}


}
