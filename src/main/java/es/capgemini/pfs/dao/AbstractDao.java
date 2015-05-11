package es.capgemini.pfs.dao;

import java.io.Serializable;
import java.util.List;

import es.capgemini.devon.hibernate.dao.HibernateDao;

/**
 * Dao generico.
 * @param <DomainObject>
 * @param <KeyType>
 */
public interface AbstractDao<DomainObject extends Serializable, KeyType extends Serializable> extends
        HibernateDao<DomainObject, KeyType> {

    /**
     * Metodo que lista todos los obj incluidos los eliminados mediante auditoria.
     *
     * @return lista FULL de todos los obj
     */
    List<DomainObject> getListFull();

}
