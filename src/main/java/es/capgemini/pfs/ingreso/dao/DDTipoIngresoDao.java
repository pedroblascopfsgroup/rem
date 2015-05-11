package es.capgemini.pfs.ingreso.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.ingreso.model.DDTipoIngreso;

/**
 * @author Mariano Ruiz
 */
public interface DDTipoIngresoDao extends AbstractDao<DDTipoIngreso, Long> {

    /**
     * Obtiene el tipo de ingreso por su código.
     * @param codigo String
     * @return DDTipoIngreso
     */
    DDTipoIngreso getByCodigo(String codigo);

}
