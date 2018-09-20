package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.impl;

import java.lang.reflect.Method;

import org.hibernate.Session;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import org.springframework.stereotype.Component;

import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.SessionFactoryFacade;

@Component
public class SessionFactoryFacadeImpl implements SessionFactoryFacade {

	@SuppressWarnings("all")
	@Override
	public Session getSession(HibernateDaoSupport dao) {
		// La implementación por defecto simplemente devuelve la misma sesión que se le pasa
		if (dao == null){
			throw new  IllegalArgumentException("currentSession no puede ser NULL");
		}
		try {
			Method m = HibernateDaoSupport.class.getDeclaredMethod("getSession", null);
			m.setAccessible(true);
			return (Session) m.invoke(dao, null);
		} catch (Exception e) {
			throw new IllegalStateException("El método getSession no es accesible para el objeto.",e);
		} 
	}

}
