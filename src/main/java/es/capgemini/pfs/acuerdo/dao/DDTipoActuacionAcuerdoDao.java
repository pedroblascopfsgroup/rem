package es.capgemini.pfs.acuerdo.dao;

import es.capgemini.pfs.acuerdo.model.DDTipoActuacionAcuerdo;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Mariano Ruiz
 *
 */
public interface DDTipoActuacionAcuerdoDao extends AbstractDao<DDTipoActuacionAcuerdo, Long> {

    /**
     * Busca un DDTipoActuacionAcuerdo.
     * @param codigo String: el codigo del DDTipoActuacionAcuerdo
     * @return DDTipoActuacionAcuerdo
     */
    DDTipoActuacionAcuerdo buscarPorCodigo(String codigo);
}
