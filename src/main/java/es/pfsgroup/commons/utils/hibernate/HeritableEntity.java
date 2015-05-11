package es.pfsgroup.commons.utils.hibernate;

import java.io.Serializable;
import java.lang.reflect.Method;

import org.hibernate.proxy.HibernateProxy;
import org.hibernate.proxy.HibernateProxyHelper;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

/**
 * Entity heredable.
 * 
 * Se utiliza para convertir una Entity en una de sus Sublcases
 * 
 * @author bruno
 * 
 */
public class HeritableEntity {

	private static final String GENERIC_DAO_BEAN_NAME = "genericABMDao";

	private Class heritable;
	private GenericABMDao dao;
	private Long id;
	boolean isnull = false;

	/**
	 * Crea una Entity heredable
	 * 
	 * @param entity
	 */
	public HeritableEntity(Serializable entity) {
		if (entity != null) {
			if (entity instanceof HibernateProxy) {
				heritable = HibernateProxyHelper
						.getClassWithoutInitializingProxy(entity);
			} else {
				heritable = entity.getClass();
			}

			try {
				dao = (GenericABMDao) ApplicationContextUtil
						.getApplicationContext().getBean(GENERIC_DAO_BEAN_NAME);
			} catch (Exception e) {
				throw new HeritableEntityError(GENERIC_DAO_BEAN_NAME
						+ " is not accessible");
			}

			Class c = heritable;
			Method m = null;
			while (c != Object.class) {
				try {
					m = c.getDeclaredMethod("getId");
					if (m != null && m.getReturnType().equals(Long.class)) {
						id = (Long) m.invoke(entity);
					}
					c = c.getSuperclass();
				} catch (Exception me) {
					c = c.getSuperclass();
					continue;
				}

			}
			if (m == null){
				throw new HeritableEntityError("missing method Long getId() on " + heritable);
			}
			if (id == null){
				throw new HeritableEntityError("no id for entity " + entity);
			}

		} else {
			isnull = true;
		}
	}

	/**
	 * Devuelve la Entity como una sublcase
	 * 
	 * @param <T>
	 * @param clazz
	 *            Subclase
	 * @return
	 */
	public <T extends Serializable> T getInerited(Class<T> clazz) {
		if (isnull) {
			return null;
		}
		if (heritable.isAssignableFrom(clazz)) {
			return dao
					.get(clazz, dao.createFilter(FilterType.EQUALS, "id", id));
		} else {
			throw new HeritableEntityError(clazz + " is not a " + heritable);
		}

	}
}
