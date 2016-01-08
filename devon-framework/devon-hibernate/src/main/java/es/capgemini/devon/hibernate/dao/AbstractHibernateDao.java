package es.capgemini.devon.hibernate.dao;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 * @author Nicolás Cornaglia
 */
@SuppressWarnings("unchecked")
public abstract class AbstractHibernateDao<DomainObject extends Serializable, KeyType extends Serializable> extends HibernateDaoSupport {

    protected Class<DomainObject> domainClass = getDomainClass();

    protected Class<DomainObject> getDomainClass() {
        Object type = getClass().getGenericSuperclass();
        if (type instanceof ParameterizedType) {
            return (Class<DomainObject>) ((ParameterizedType) type).getActualTypeArguments()[0];
        } else {
            return (Class<DomainObject>) type.getClass();
        }
    }

    // Hibernate default implementations

    public DomainObject get(KeyType id) {
        return (DomainObject) getHibernateTemplate().get(domainClass, id);
    }

    public DomainObject load(KeyType id) {
        return (DomainObject) getHibernateTemplate().load(domainClass, id);
    }

    public void update(DomainObject t) {
        getHibernateTemplate().update(t);
    }

    public KeyType save(DomainObject t) {
        return (KeyType) getHibernateTemplate().save(t);
    }

    public void saveOrUpdate(DomainObject t) {
        getHibernateTemplate().saveOrUpdate(t);
    }

    public void delete(DomainObject t) {
        getHibernateTemplate().delete(t);
    }

    public List<DomainObject> getList(boolean cacheable) {
        /*return (getHibernateTemplate().find("from " + domainClass.getName() + " x"));*/
        return getSession().createQuery("from " + domainClass.getName()).setCacheable(cacheable).list();
    }

    public List<DomainObject> getList() {
        return getList(true);
    }

    public void deleteById(KeyType id) {
        Object obj = load(id);
        getHibernateTemplate().delete(obj);
    }

    public void deleteAll() {
        getHibernateTemplate().execute(new HibernateCallback() {

            public Object doInHibernate(Session session) throws HibernateException {
                String hqlDelete = "delete " + domainClass.getName();
                int deletedEntities = session.createQuery(hqlDelete).executeUpdate();
                return null;
            }

        });
    }

    public int count() {
        List<Integer> list = getHibernateTemplate().find("select count(*) from " + domainClass.getName() + " x");
        Integer count = list.get(0);
        return count.intValue();
    }

}