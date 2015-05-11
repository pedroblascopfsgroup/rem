package es.capgemini.pfs.exclusionexpedientecliente.dao.impl;

import java.util.List;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.exclusionexpedientecliente.dao.ExclusionExpedienteClienteDao;
import es.capgemini.pfs.exclusionexpedientecliente.model.ExclusionExpedienteCliente;

/**
 * @author marruiz
 */
@Repository("ExclusionExpedienteClienteDao")
public class ExclusionExpedienteClienteDaoImpl extends AbstractEntityDao<ExclusionExpedienteCliente, Long> implements ExclusionExpedienteClienteDao {

    /**
     * @param idExpediente Long: expediente asociado a la exclusión
     * @return ExclusionExpedienteCliente
     */
    @SuppressWarnings("unchecked")
    public ExclusionExpedienteCliente findByExpedienteId(Long idExpediente) {
        String hql = "select see from ExclusionExpedienteCliente see, Expediente exp "
                   + "where see.expediente = exp and exp.id = ?"
                   + "      and see.auditoria." + Auditoria.UNDELETED_RESTICTION;

        List<ExclusionExpedienteCliente> see = getHibernateTemplate().find(hql, idExpediente);
        if (see.size() == 0) {
            return null;
        } else if (see.size() > 1) {
            throw new DataIntegrityViolationException("Duplicado exclusionExpedienteCliente en expedienteId: " + idExpediente);
        } else {
            return see.get(0);
        }
    }
}
