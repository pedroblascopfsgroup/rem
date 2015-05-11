package es.capgemini.pfs.cobropago.dao;

import java.util.List;

import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Dao para DDSubtipoCobroPago.
 * @author: Lisandro Medrano
 */
public interface DDSubtipoCobroPagoDao extends AbstractDao<DDSubtipoCobroPago, Long> {

    /**
     * @param codigo String
     * @return lista de DDSubtipoCobroPago
     */
    List<DDSubtipoCobroPago> getByTipo(String codigo);
}
