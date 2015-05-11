package es.capgemini.pfs.acuerdo.dao;

import es.capgemini.pfs.acuerdo.model.DDTipoPagoAcuerdo;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Mariano Ruiz
 *
 */
public interface DDTipoPagoAcuerdoDao extends AbstractDao<DDTipoPagoAcuerdo, Long> {

    /**
     * Busca un DDTipoPagoAcuerdo.
     * @param codigo String: el codigo del DDTipoPagoAcuerdo
     * @return DDTipoPagoAcuerdo
     */
    DDTipoPagoAcuerdo buscarPorCodigo(String codigo);
}
