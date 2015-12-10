package es.capgemini.devon.hibernate.dao;

import java.io.Serializable;
import java.util.List;

/**
 * @author Nicolás Cornaglia
 */
public interface HibernateDao<DomainObject extends Serializable, KeyType extends Serializable> {

    public DomainObject get(KeyType id);

    public DomainObject load(KeyType id);

    public void update(DomainObject object);

    public KeyType save(DomainObject object);

    public void delete(DomainObject object);

    public void deleteById(KeyType id);

    public List<DomainObject> getList();

    public void deleteAll();

    public int count();

    public void saveOrUpdate(DomainObject object);

}