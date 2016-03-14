package es.capgemini.pfs.dao;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Embedded;

import org.apache.commons.lang.NotImplementedException;
import org.springframework.orm.hibernate3.HibernateTemplate;

import es.capgemini.devon.utils.ClassUtils;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que extiende a AbstractHibernateDao para implementar alguna funcionalidad puntual
 * adaptada al proyecto.
 *
 * @author lgiavedoni
 *
 * @param <DomainObject>
 * @param <KeyType>
 */
@SuppressWarnings("unchecked")
public abstract class AbstractHibernateDao<DomainObject extends Serializable, KeyType extends Serializable> extends
        es.capgemini.devon.hibernate.dao.AbstractHibernateDao<DomainObject, KeyType> {

    /**
     * Retorna la lista de objetos.
     * Si el objeto posee embebido el campo de auditoria solo listara los que no poseen borrado logico
     *
     * @return lista de objetos
     */
    @Override
    public List<DomainObject> getList() {
    	HibernateTemplate t = this.getHibernateTemplate();
    	t.setCacheQueries(true);
        if (ClassUtils.containsFieldType(getDomainClass(), Auditoria.class, Embedded.class)) { 
        	/*return (getHibernateTemplate().find("from + domainClass.getName() + " where " + Auditoria.UNDELETED_RESTICTION));*/
//            return getSession().createQuery("from " + domainClass.getName() + " where " + Auditoria.UNDELETED_RESTICTION).setCacheable(true).list();
        	return t.find("from " + domainClass.getName() + " where " + Auditoria.UNDELETED_RESTICTION);        	
        }
        return t.find("from " + domainClass.getName());

    }

    /**
     * Retorna la lista de objetos inculidos los que han sido borrados de forma logica.
     *
     * @return lista de objetos (Incluidos los borrados logicamente)
     */
    public List<DomainObject> getListFull() {
//        return super.getList();
    	HibernateTemplate t = this.getHibernateTemplate();
    	t.setCacheQueries(true);
    	return t.find("from " + domainClass.getName());
    }

    /**
     * Verifica si el objeto posee embebido el campo de auditoria, en tal caso realiza un borrado logico.
     * @param t DomainObject
     * @see es.capgemini.devon.dao.AbstractHibernateDao#delete(java.io.Serializable)
     */
    public void deleteAuditado(DomainObject t) {
        Auditoria.delete((Auditable) t);
        super.save(t);

    }

    /**
    * FIXME Spring me obliga a tener un metodo con la firma delete(Object t) para poder hacer un @Override
    * del metodo delete(DomainObject object).
    * @param t Object
    */
    public void delete(Object t) {
        throw new NotImplementedException("Este código no deber�a haberse ejecutado. Revisar");
    }

    /**
     * Save or udpate.
     * @param t DomainObject
     */
    @Override
    public void saveOrUpdate(DomainObject t) {
        if (esAuditado(t)) {
            Auditoria.save((Auditable) t);
        }
        super.saveOrUpdate(t);
    }

    /**
     * Save.
     * @param t DomainObject
     * @return KeyType
     */
    @Override
    public KeyType save(DomainObject t) {
        if (esAuditado(t)) {
            Auditoria.save((Auditable) t);
        }
        return super.save(t);
    }

    /**
     * Nos informa si el objeto es auditado o no.
     * @param object
     * @return
     */
    boolean esAuditado(DomainObject object) {
        return object instanceof Auditable;

    }

    /**
     * TODO Revisar !! este m�todo no funciona, deber�a ser reemplazado por el que está debajo.
     * @param object DomainObject
     */
    @Override
    public void delete(DomainObject object) {
        if (esAuditado(object)) {
            deleteAuditado(object);
        } else {
            super.delete(object);
        }
    }

    /**
     * @see es.capgemini.devon.dao.AbstractHibernateDao#deleteById(java.io.Serializable)
     *
     * Delegamos en delete porque tenemos que actualizar el objeto auditor�a
     * @param id KeyType
     */
    @Override
    public void deleteById(KeyType id) {
        DomainObject object = get(id);
        delete(object);
    }
}
