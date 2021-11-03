package es.pfsgroup.plugin.rem.recomendacion.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.model.ConfiguracionRecomendacion;
import es.pfsgroup.plugin.rem.recomendacion.dao.RecomendacionDao;

@Repository("RecomendacionDao")
public class RecomendacionDaoImpl extends AbstractEntityDao<ConfiguracionRecomendacion, Long> implements RecomendacionDao {
	
	@Override
	public void deleteConfigRecomendacionById(Long id) {
		
		StringBuilder sb = new StringBuilder("delete from ConfiguracionRecomendacion cor where cor.id = :id ");
		this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).setParameter("id", id).executeUpdate();

	}

}
