package es.pfsgroup.commons.utils.hibernate;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.SessionFactory;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.ApplicationContextUtil;

@Component
public class HibernateUtils extends HibernateDaoSupport {
	private static final String HIBERNATE_UTILS = "hibernateUtils";

	public static <T> T merge(T o) {
		HibernateUtils u = (HibernateUtils) ApplicationContextUtil.getBean(HIBERNATE_UTILS);
		return u.mergeObject(o);
	}

	/**
	 * @param entitySessionFactory SessionFactory
	 */
	@Resource
	public void setEntitySessionFactory(SessionFactory entitySessionFactory) {
		super.setSessionFactory(entitySessionFactory);
	}

	@SuppressWarnings("unchecked")
	public <T> T mergeObject(T o) {
		return (T) getSession().merge(o);
	}

	public static void flush() {
		HibernateUtils u = (HibernateUtils) ApplicationContextUtil.getBean(HIBERNATE_UTILS);
		u.flushSession();
	}

	public void flushSession() {
		getSession().flush();
	}

	public static void refresh(Object objeto) {
		HibernateUtils u = (HibernateUtils) ApplicationContextUtil.getBean(HIBERNATE_UTILS);
		u.refreshSession(objeto);
	}

	public void refreshSession(Object objeto) {
		getSession().refresh(objeto);
	}

	/**
	 * Este método define la clase de los objetos contenidos en un listado. Se puede utilizar
	 * en circunstancias donde hibernate nos devuelve una lista con entidades sin tipo de clase.
	 * Permite poder manejar los objetos con propiedad y evita tener que asignar al método la
	 * etiqueta: @SuppressWarnings("unchecked").
	 *
	 * <pre>
	 * Ejemplo:
	 *
	 * {@code
	 * Criteria criteria = getSession().createCriteria(XXXXX.class);
	 * criteria.add(Restrictions.eq("id", dto.getId())).setFirstResult(dto.getStart()).setMaxResults(dto.getLimit()).addOrder(Order.desc("id"));
	 * return HibernateUtils.castList(XXXXX.class, criteria.list());
	 * }
	 * </pre>
	 *
	 * @param clazz: clase a la cual queremos realizar la conversion/cast.
	 * @param collection: listado de entidades que queremos castear.
	 * @return Devuelve un listado de entidades con el tipo de clase definido.
	 */
	public static <T> List<T> castList(Class<? extends T> clazz, Collection<?> collection) {
		HibernateUtils u = (HibernateUtils) ApplicationContextUtil.getBean(HIBERNATE_UTILS);

		List<T> castedCollection = new ArrayList<T>(collection.size());

		for (Object object : collection) {
			castedCollection.add(u.cast(object, clazz));
		}

		return castedCollection;
	}

	/**
	 * Este método define la clase del objeto que recibe. Se puede utilizar
	 * en circunstancias donde hibernate nos devuelve una entidad sin tipo de clase.
	 * Permite poder manejar los objetos con propiedad y evita tener que asignar al método la
	 * etiqueta: @SuppressWarnings("unchecked").
	 *
	 * <pre>
	 * Ejemplo:
	 *
	 * {@code
	 * Criteria criteria = getSession().createCriteria(XXXXX.class);
	 * criteria.add(Restrictions.eq("id", dto.getId()));
	 * return HibernateUtils.castObject(XXXXX.class, criteria.uniqueResult());
	 * }
	 * </pre>
	 *
	 * @param clazz: clase a la cual queremos realizar la conversion/cast.
	 * @param object: objeto que queremos castear.
	 * @return Devuelve un una entidad con el tipo de clase definido.
	 */
	public static <T> T castObject(Class<? extends T> clazz, Object object) {
		HibernateUtils u = (HibernateUtils) ApplicationContextUtil.getBean(HIBERNATE_UTILS);

		return u.cast(object, clazz);
	}

	private <T> T cast(Object object, Class<T> clazz) {
		return clazz.cast(object);
	}

}
