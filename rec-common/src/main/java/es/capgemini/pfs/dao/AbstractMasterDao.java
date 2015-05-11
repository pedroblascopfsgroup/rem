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
public abstract class AbstractMasterDao<DomainObject extends Serializable, KeyType extends Serializable> extends
        AbstractHibernateDao<DomainObject, KeyType> {

    /**
     * @param masterSessionFactory SessionFactory
     */
    @Resource
    public void setMasterSessionFactory(SessionFactory masterSessionFactory) {
        super.setSessionFactory(masterSessionFactory);
    }

}
