package es.pfsgroup.plugin.rem.rest.dao.impl;

import java.io.Serializable;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.rest.dao.GenericRestDao;

@Repository("genericaRestDaoImp")
public class GenericaRestDaoImp extends AbstractEntityDao<Serializable, Serializable> implements GenericRestDao {

	@Override
	public void deleteInformeMediador(ActivoInfoComercial informeComerical) throws Exception {
		
		Query query = null;
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoInfraestructura where infoComercial=:ID");
		query.setParameter("ID", informeComerical);
		query.executeUpdate();
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoCarpinteriaInterior where infoComercial=:ID");
		query.setParameter("ID", informeComerical);
		query.executeUpdate();
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoCarpinteriaExterior where infoComercial=:ID");
		query.setParameter("ID", informeComerical);
		query.executeUpdate();
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoParamentoVertical where infoComercial=:ID");
		query.setParameter("ID", informeComerical);
		query.executeUpdate();
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoSolado where infoComercial=:ID");
		query.setParameter("ID", informeComerical);
		query.executeUpdate();
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoCocina where infoComercial=:ID");
		query.setParameter("ID", informeComerical);
		query.executeUpdate();
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoBanyo where infoComercial=:ID");
		query.setParameter("ID", informeComerical);
		query.executeUpdate();
		
		
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoZonaComun where infoComercial=:ID");
		query.setParameter("ID", informeComerical);
		query.executeUpdate();
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoDistribucion where infoComercial=:ID");
		query.setParameter("ID", informeComerical);
		query.executeUpdate();
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoZonaComun where infoComercial=:ID");
		query.setParameter("ID", informeComerical);
		query.executeUpdate();
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoInstalacion where infoComercial=:ID");
		query.setParameter("ID", informeComerical);
		query.executeUpdate();
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoEdificio where infoComercial=:ID");
		query.setParameter("ID", informeComerical);
		query.executeUpdate();
		
		//query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoAnejo where infoComercial=:ID");
		//query.setParameter("ID", informeComerical);
		//query.executeUpdate();
		
		query = this.getSessionFactory().getCurrentSession().createQuery("delete ActivoInfoComercial where id=:ID");
		query.setParameter("ID", informeComerical.getId());
		query.executeUpdate();	
	
		
	}
	
	public void doFlush(){
		this.getHibernateTemplate().flush();
	}

}
