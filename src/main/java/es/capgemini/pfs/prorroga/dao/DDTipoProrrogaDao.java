package es.capgemini.pfs.prorroga.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.prorroga.model.DDTipoProrroga;

/**
 * Clase que agrupa método para la creación y acceso de datos de los
 * Tipos de prorroga.
 */

public interface DDTipoProrrogaDao extends AbstractDao<DDTipoProrroga, Long> {

    /**
     * Devuelve un tipo de prorroga por su código.
     * @param codigo el codigo
     * @return el estado expediente.
     */
    DDTipoProrroga getByCodigo(String codigo);
}
