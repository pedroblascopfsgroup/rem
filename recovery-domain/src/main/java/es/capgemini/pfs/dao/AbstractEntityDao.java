package es.capgemini.pfs.dao;

import java.io.Serializable;

import javax.annotation.Resource;

import org.hibernate.SessionFactory;

/**
 * TODO Documentar.
 *
 * @author Nicolás Cornaglia
 *
 * @param <DomainObject>
 * @param <KeyType>
 */
public abstract class AbstractEntityDao<DomainObject extends Serializable, KeyType extends Serializable> extends
        AbstractHibernateDao<DomainObject, KeyType> {


    /**
     * @param entitySessionFactory SessionFactory
     */
    @Resource
    public void setEntitySessionFactory(SessionFactory entitySessionFactory) {
        super.setSessionFactory(entitySessionFactory);
    }

}
