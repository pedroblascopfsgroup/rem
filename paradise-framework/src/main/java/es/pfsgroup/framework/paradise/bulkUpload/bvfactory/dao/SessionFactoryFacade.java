package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao;

import org.hibernate.Session;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 * Factoría para obtener las sesiones de Hibernate. Se pone esta funcionalidad
 * en una factoría a parte para poder mockearla en los tests
 * 
 * @author bruno
 * 
 */
public interface SessionFactoryFacade {

	/**
	 * Devuelve la sesión actual del DAO
	 * 
	 * @param currentDao
	 *            Dao del que se quiere devolver la sesión En la implementación
	 *            normal este método invoca el método getSession() del dao que
	 *            se pasa como parámetro. Durante los tests se debería devolver
	 *            un mock de la sesión.
	 * @return
	 */
	Session getSession(HibernateDaoSupport currentDao);

}
