package es.capgemini.pfs.subfase.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.subfase.model.DDFase;

/**
 * Interfaz para el DAO de Fase.
 */

public interface FaseDao extends AbstractDao<DDFase, Long> {

    /**
     * @param codigo String
     * @return Fase
     */
    DDFase getByCodigo(String codigo);
}
