package es.capgemini.pfs.utils.hibernate.page;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;

import es.capgemini.devon.pagination.PaginationParams;

public class PageHibernateOptimizada extends
		es.capgemini.devon.hibernate.pagination.PageHibernate {

	private static final long serialVersionUID = 1L;

	private final Log logger = LogFactory.getLog(getClass());

	private HashMap<String, Object> parameters = new HashMap<String, Object>();

	public PageHibernateOptimizada(String queryString,
			PaginationParams paginationParams) {
		super(queryString, paginationParams);
	}

	public PageHibernateOptimizada(String queryString,
			PaginationParams paginationParams,
			HashMap<String, Object> parameters) {
		super(queryString, paginationParams, parameters);
		this.parameters = parameters;
	}

	public Object doInHibernate(Session session) throws HibernateException {

		try {
			String queryStr = creaQuery();
			HQLOptimized hqlO = new HQLOptimized(queryStr);

			if (hqlO.canOptimize()) {
				// Hacemos un count de los ids a devolver.
				Query q = session.createSQLQuery("SELECT COUNT(1) FROM ("
						+ hqlToSql(hqlO.getOptimizedHQL(), session) + ")");
				setParameters(q);
				List<?> count = q.list();
				this.setTotalCount(Integer.parseInt(count.get(0).toString()));

				if (this.getTotalCount() > 0) {
					// Obtenemos la lista de ids paginados
					Query query = session.createQuery(hqlO.getOptimizedHQL());
					setParameters(query);
					query.setFirstResult(getStart());
					query.setMaxResults(getResultsPerPage());

					final List<Long> idList = convertToLongSiPuede(query.list());
					if (idList.isEmpty()) {
						throw new IllegalStateException(
								"idList no puede estar vacío, se esperaban "
										+ this.getTotalCount() + " elementos.");
					}

					// Obtenemos los objetos
					Query qObj = session.createQuery(
							"from " + hqlO.getObjectHibernate()
									+ " obj where obj.id in (:idList)")
							.setParameterList("idList", idList);
					results = qObj.list();

				} else {
					results = new ArrayList();
				}
				return results;
			}
		} catch (Exception ex) {
			logger.debug("ERROR optimizing hibernate query. Runing default", ex);

		}
		return super.doInHibernate(session);
	}

	/**
	 * Devuelve una lista de Long si se pasa una lista de BigDecimal. Si la
	 * lista que se pasa no contiene BigDecimal la deja tal cual
	 * 
	 * @param list
	 * @return
	 */
	private List convertToLongSiPuede(final List list) {
		if ((list == null) || list.isEmpty()) {
			return list;
		}

		if (list.get(0) instanceof Long) {
			return list;
		}

		final ArrayList newList = new ArrayList();
		for (Object o : list) {
			if (o instanceof BigDecimal) {
				newList.add(((BigDecimal) o).longValue());
			}
		}
		return newList;
	}

	/**
	 * Sobreescribimos el método del padre para el pase de parámetros
	 */
	protected void setParameters(Query query) {
		if (parameters == null) {
			return;
		}
		for (String key : parameters.keySet()) {
			Object param = parameters.get(key);
			if (param instanceof Collection) {
				query.setParameterList(key, (Collection) param);
			} else if (param instanceof Object[]) {
				query.setParameterList(key, (Object[]) param);
			} else {
				query.setParameter(key, param);
			}

		}
	}

}