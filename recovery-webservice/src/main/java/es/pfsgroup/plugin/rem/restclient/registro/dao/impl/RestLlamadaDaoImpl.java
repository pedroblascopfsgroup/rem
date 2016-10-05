package es.pfsgroup.plugin.rem.restclient.registro.dao.impl;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;

@Repository
public class RestLlamadaDaoImpl extends AbstractEntityDao<RestLlamada, Long> implements RestLlamadaDao{
	

	@Override
	public void guardaRegistro(final RestLlamada obj) {
		Session session = getSessionFactory().openSession();
		Transaction tx = session.beginTransaction();
		try{
			Auditoria.save(obj);
			session.persist(obj);
			tx.commit();
		}finally{
			if (session.isOpen()){
				session.flush();
				session.close();
			}
		}
		
		
	}

}
