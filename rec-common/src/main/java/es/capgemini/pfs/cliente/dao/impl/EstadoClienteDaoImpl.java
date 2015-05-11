package es.capgemini.pfs.cliente.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.cliente.dao.EstadoClienteDao;
import es.capgemini.pfs.cliente.model.EstadoCliente;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * DAO de EstadoClienteDao.
 */
@Repository("EstadoClienteDao")
public class EstadoClienteDaoImpl extends AbstractEntityDao<EstadoCliente, Long> implements EstadoClienteDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public EstadoCliente getByCodigo(String codigo) {
        String hql = "from EstadoCliente where codigo = ?";
        List<EstadoCliente> lista = getHibernateTemplate().find(hql, new Object[] { codigo });
        if (lista.size() > 0) {
            return lista.get(0);
        }
        return null;
    }
}
