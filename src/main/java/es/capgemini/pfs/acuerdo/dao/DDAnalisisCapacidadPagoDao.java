package es.capgemini.pfs.acuerdo.dao;

import es.capgemini.pfs.acuerdo.model.DDAnalisisCapacidadPago;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author pamuller
 *
 */
public interface DDAnalisisCapacidadPagoDao extends AbstractDao<DDAnalisisCapacidadPago, Long> {

    /**
     * Busca un DDAnalisisCapacidadPago.
     * @param codigo String: el codigo del DDAnalisisCapacidadPago
     * @return DDAnalisisCapacidadPago
     */
    DDAnalisisCapacidadPago buscarPorCodigo(String codigo);
}
