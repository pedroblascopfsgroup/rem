package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao;

import org.hibernate.Session;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 * Factor�a para obtener las sesiones de Hibernate. Se pone esta funcionalidad
 * en una factor�a a parte para poder mockearla en los tests
 * 
 * @author bruno
 * 
 */
public interface SessionFactoryFacade {

	/**
	 * Devuelve la sesi�n actual del DAO
	 * 
	 * @param currentDao
	 *            Dao del que se quiere devolver la sesi�n En la implementaci�n
	 *            normal este m�todo invoca el m�todo getSession() del dao que
	 *            se pasa como par�metro. Durante los tests se deber�a devolver
	 *            un mock de la sesi�n.
	 * @return
	 */
	Session getSession(HibernateDaoSupport currentDao);

}
