package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.springframework.stereotype.Component;

@Component
public class HibernateExecutionFacade {

	private final Log logger = LogFactory.getLog(getClass());

	@SuppressWarnings("unchecked")
	public List<Object[]> sqlRunList(Session session, String queryString, InfoTablasBD infoTablas)
			throws CambiosBDDaoError {
		List<Object[]> resultado;
		try {
			if (logger.isDebugEnabled()) {
				logger.trace("Ejecutando: " + queryString);
			}
			Query query = createQuery(session, queryString);
			resultado = (List<Object[]>) query.list();
		} catch (Throwable t) {
			throw new CambiosBDDaoError("Ha ocurrido un error al obtener los registros que difieren", queryString,
					infoTablas, t);
		}
		return resultado;
	}

	public Object[] sqlRunUniqueResult(Session session, String queryString, InfoTablasBD infoTablas)
			throws CambiosBDDaoError {
		Object[] resultado = null;
		try {
			if (logger.isDebugEnabled()) {
				logger.trace("Ejecutando: " + queryString);
			}
			resultado = (Object[]) session.createSQLQuery(queryString).uniqueResult();
		} catch (Throwable t) {
			throw new CambiosBDDaoError("Ha ocurrido un error al obtener el registro en 'datos historicos'",
					queryString, infoTablas, t);
		}
		return resultado;
	}

	public int sqlRunExecuteUpdate(Session session, String queryString) throws CambiosBDDaoError {
		return this.sqlRunExecuteUpdate(session, queryString, null);
	}

	public int sqlRunExecuteUpdate(Session session, String queryString, InfoTablasBD infoTablas)
			throws CambiosBDDaoError {
		if (logger.isDebugEnabled()) {
			logger.trace("Ejecutando: " + queryString);
		}
		int result = 0;
		try {
			result = createQuery(session, queryString).executeUpdate();
		} catch (Throwable t) {
			if (infoTablas != null) {
				throw new CambiosBDDaoError("Ha ocurrido un error al ejecutar la query",
						queryString, infoTablas, t);
			} else {
				throw new CambiosBDDaoError("Ha ocurrido un error al ejecutar la query'",
						queryString, t);
			}
		}
		return result;
	}

	public Criteria createCriteria(Session session, Class<?> persitentClass) {
		return session.createCriteria(persitentClass);
	}

	public Object criteriaRunUniqueResult(Criteria criteria) {
		return criteria.uniqueResult();
	}

	private SQLQuery createQuery(Session session, String queryString) {
		return session.createSQLQuery(queryString);
	}

}
