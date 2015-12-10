package es.capgemini.devon.stubs.hibernate.dao;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.util.List;

/**
 * @author Nicolás Cornaglia
 */
@SuppressWarnings("unchecked")
public abstract class StubAbstractHibernateDao<DomainObject extends Serializable, KeyType extends Serializable> {

    protected Class<DomainObject> domainClass = getDomainClass();

    protected Class<DomainObject> getDomainClass() {
        ParameterizedType thisType = (ParameterizedType) getClass().getGenericSuperclass();
        return (Class<DomainObject>) thisType.getActualTypeArguments()[0];
    }

    // Hibernate default implementations

    public DomainObject get(KeyType id) {
        return null;
    }

    public DomainObject load(KeyType id) {
        return null;
    }

    public void update(DomainObject t) {

    }

    public KeyType save(DomainObject t) {
        return null;
    }

    public void saveOrUpdate(DomainObject t) {

    }

    public void delete(DomainObject t) {

    }

    public List<DomainObject> getList() {
        return null;
    }

    public void deleteById(KeyType id) {

    }

    public void deleteAll() {

    }

    public int count() {
        return 0;
    }

}