package es.capgemini.pfs.cliente.dao;

import es.capgemini.pfs.cliente.model.EstadoCliente;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * ClienteContrato DAO.
 * @author jbosnjak
 *
 */
public interface EstadoClienteDao extends AbstractDao<EstadoCliente, Long> {

    /**
     * Devuelve un tipo de estado cliente por su código.
     * @param codigo el codigo
     * @return el estado cliente.
     */
    EstadoCliente getByCodigo(String codigo);
}
