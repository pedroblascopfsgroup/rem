package es.pfsgroup.commons.utils;

import java.io.Serializable;
import java.util.List;

import org.hibernate.Query;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.hibernate.dao.AbstractHibernateDao;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;

/**
 * Esta clase provee de m�todos para simplificar la ejecuci�n de querys en
 * Hibernate
 * 
 * @author bruno
 * 
 */
public class HibernateQueryUtils {
	
	/**
	 * Obtiene un objeto �nico mediante una consulta a Hibernate.
	 * 
	 * @param dao
	 *            Objeto que queremos ejecute la consulta.
	 * @param hqlbuilder
	 *            Sentencia HQL a ejecutar.
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static <T extends Serializable, K extends Serializable> T uniqueResult(AbstractHibernateDao<T, K> dao, HQLBuilder hqlbuilder) {
		Query q = dao.getSessionFactory().getCurrentSession().createQuery(hqlbuilder.toString());
		HQLBuilder.parametrizaQuery(q, hqlbuilder);
		return (T) q.uniqueResult(); 
	}

	/**
	 * Devuelve una lista de objetos mediante una consulta a Hibernate
	 * 
	 * @param dao
	 *            Objeto que queremos que ejecute la consulta
	 * @param hqlbuilder
	 *            Sentencia HQL a ejecutar
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static <T extends Serializable, K extends Serializable> List<T> list(AbstractHibernateDao<T, K> dao, HQLBuilder hqlbuilder) {

		return dao.getHibernateTemplate().findByNamedParam(hqlbuilder.toString(), hqlbuilder.getParamNames(), hqlbuilder.getParamValues());
	}

	/**
	 * Devuelve una lista de objetos mediante una consulta a Hibernate
	 * 
	 * @param dao
	 *            Dao actual
	 * @param hqlbuilder
	 *            Builder HQL
	 * @param dto
	 *            DTO con informaci�n de paginaci�n
	 * @return
	 */
	public static <T extends Serializable, K extends Serializable> Page page(AbstractHibernateDao<T, K> dao, HQLBuilder hqlbuilder, WebDto dto) {

		return page(dao, hqlbuilder, dto, null);
	}
	
	/**
	 * Devuelve una lista de objetos mediante una consulta a Hibernate
	 * 
	 * @param dao
	 *            Dao actual
	 * @param hqlbuilder
	 *            Builder HQL
	 * @param dto
	 *            DTO con informaci�n de paginaci�n
	 * @return
	 */
	public static <T extends Serializable, K extends Serializable> Page page(AbstractHibernateDao<T, K> dao, HQLBuilder hqlbuilder, PaginationParams dto) {

		return page(dao, hqlbuilder, dto, null);
	}
	
	/**
	 * Devuelve una lista de objetos mediante una consulta a Hibernate. Este
	 * m�todo transforma los resultados a un DTO concreto
	 * 
	 * @param dao
	 *            Dao actual
	 * @param hqlbuilder
	 *            Builder HQL
	 * @param dto
	 *            DTO con informaci�n de paginaci�n
	 * @param clazz
	 *            DTO al que queremos transformar
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static <T extends Serializable, K extends Serializable> Page page(AbstractHibernateDao<T, K> dao, HQLBuilder hqlbuilder, PaginationParams dto, Class clazz) {

		if (clazz == null) {
			return returnPage(dao, hqlbuilder, dto);
		} else {
			return returnPageTransformed(dao, hqlbuilder, dto, clazz);
		}
	}
	
	/**
	 * Devuelve una lista de objetos mediante una consulta a Hibernate. Este
	 * m�todo transforma los resultados a un DTO concreto
	 * 
	 * @param dao
	 *            Dao actual
	 * @param sql
	 *            Sentencia sql
	 * @param clazz
	 *            DTO al que queremos transformar
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static <T extends Serializable, K extends Serializable> Page pageSql(AbstractHibernateDao<T, K> dao, String sql, Class clazz, PaginationParams dto) {

		PageSQLTransformHibernate page = new PageSQLTransformHibernate(sql, clazz, dto);
		dao.getHibernateTemplate().executeFind(page);

		return page;
	}


	private static <T extends Serializable, K extends Serializable> Page returnPage(AbstractHibernateDao<T, K> dao, HQLBuilder hqlbuilder, PaginationParams dto) {
		PageHibernate page;

		if (hqlbuilder.getParameters().isEmpty()) {
			page = new PageHibernate(hqlbuilder.toString(), dto);
		} else {
			page = new PageHibernate(hqlbuilder.toString(), dto, hqlbuilder.getParameters());
		}

		dao.getHibernateTemplate().executeFind(page);

		return page;
	}

	@SuppressWarnings("rawtypes")
	private static <T extends Serializable, K extends Serializable> Page returnPageTransformed(AbstractHibernateDao<T, K> dao, HQLBuilder hqlbuilder, PaginationParams dto, Class clazz) {
		PageTransformHibernate page = new PageTransformHibernate(hqlbuilder.toString(), dto, hqlbuilder.getParameters(), clazz);

		dao.getHibernateTemplate().executeFind(page);

		return page;
	}
}
