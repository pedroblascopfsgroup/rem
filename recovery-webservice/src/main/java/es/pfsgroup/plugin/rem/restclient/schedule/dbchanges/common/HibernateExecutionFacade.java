package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.dao.AbstractEntityDao;

@Component
public class HibernateExecutionFacade {

	public List<Object[]> sqlRunList(Session session, String queryString) {
		List<Object[]> resultado;
		Query query = createQuery(session, queryString);
		resultado = (List<Object[]>) query.list();
		return resultado;
	}

	public Object[] sqlRunUniqueResult(Session session, String selectDatoHistorico) {
		return (Object[]) session.createSQLQuery(selectDatoHistorico).uniqueResult();
	}

	public int sqlRunExecuteUpdate(Session session, String queryDelete) {
		return createQuery(session, queryDelete).executeUpdate();
	}

	public Criteria createCriteria(Session session, Class persitentClass) {
		return session.createCriteria(persitentClass);
	}

	public Object criteriaRunUniqueResult(Criteria criteria) {
		return criteria.uniqueResult();
	}

	private SQLQuery createQuery(Session session, String queryString) {
		return session.createSQLQuery(queryString);
	}

}
