package es.capgemini.pfs.acuerdo.dao;

import es.capgemini.pfs.acuerdo.model.DDPeriodicidadAcuerdo;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author marruiz
 *
 */
public interface DDPeriodicidadAcuerdoDao extends AbstractDao<DDPeriodicidadAcuerdo, Long> {

    /**
     * Busca un DDPeriodicidadAcuerdo.
     * @param codigo String: el codigo del DDPeriodicidadAcuerdo
     * @return DDPeriodicidadAcuerdo
     */
    DDPeriodicidadAcuerdo buscarPorCodigo(String codigo);
}
