package es.capgemini.pfs.expediente.dao.impl;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.dao.PropuestaExpedienteManualDao;
import es.capgemini.pfs.expediente.model.PropuestaExpedienteManual;

/**
 * Clase que agrupa método para la creación y acceso de datos de los
 * contratos del expedientes.
 *
 * @author jbosnjak
 */
@Repository("PropuestaExpedienteManualDao")
public class PropuestaExpedienteManualDaoImpl extends AbstractEntityDao<PropuestaExpedienteManual, Long> implements
        PropuestaExpedienteManualDao {

    /**
     * {@inheritDoc}
     */
    public PropuestaExpedienteManual getPropuestaDelExpediente(Long idExpediente) {
        String hql = new String();
        hql = "select p from PropuestaExpedienteManual p ";
        hql += " where p.auditoria.borrado = false ";
        hql += " and p.expediente.id = :expId";
        Query query = getSession().createQuery(hql);
        query.setParameter("expId", idExpediente);
        return (PropuestaExpedienteManual) query.uniqueResult();
    }
}
