package es.pfsgroup.plugin.rem.activo.dao.impl;


import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.dao.ComunicacionGencatDao;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionGencat;

@Repository("ComunicacionGencat")
public class ComunicacionGencatDaoImpl extends AbstractEntityDao<ComunicacionGencat, Long> implements ComunicacionGencatDao {

	@Override
	public ComunicacionGencat getComunicacionByActivoIdAndEstadoComunicado(String numHayaActivo) {
		
		Criteria criteria = getSession().createCriteria(ComunicacionGencat.class);
		
		criteria.createCriteria("activo")
				.add(Restrictions.eq("numActivo", Long.parseLong(numHayaActivo)));
		
		criteria.createCriteria("estadoComunicacion")
				.add(Restrictions.eq("codigo", DDEstadoComunicacionGencat.COD_COMUNICADO));
		
		return HibernateUtils.castObject(ComunicacionGencat.class, criteria.uniqueResult());
	}	   	
}
