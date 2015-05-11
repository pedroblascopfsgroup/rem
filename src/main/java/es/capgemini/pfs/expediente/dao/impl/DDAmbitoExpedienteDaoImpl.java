package es.capgemini.pfs.expediente.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.dao.DDAmbitoExpedienteDao;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;

/**
 * {@inheritDoc}
 *
 * @author pajimene
 */
@Repository("DDAmbitoExpedienteDao")
public class DDAmbitoExpedienteDaoImpl extends AbstractEntityDao<DDAmbitoExpediente, Long> implements DDAmbitoExpedienteDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public DDAmbitoExpediente getByCodigo(String codigo) {
        String hql = "from DDAmbitoExpediente where codigo = ?";
        List<DDAmbitoExpediente> lista = getHibernateTemplate().find(hql, new Object[] { codigo });
        if (lista.size() > 0) { return lista.get(0); }
        return null;
    }
}
