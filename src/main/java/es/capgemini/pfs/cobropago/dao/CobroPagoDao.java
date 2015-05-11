package es.capgemini.pfs.cobropago.dao;

import java.util.List;

import es.capgemini.pfs.cobropago.model.CobroPago;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Dao para CobroPago.
 * @author: Lisandro Medrano
 */
public interface CobroPagoDao extends AbstractDao<CobroPago, Long> {

    /**
     * Recupera una lista de CobroPago por Id.
     * @param id long
     * @return lista de CobroPago
     */
    List<CobroPago> getByIdAsunto(Long id);
}
