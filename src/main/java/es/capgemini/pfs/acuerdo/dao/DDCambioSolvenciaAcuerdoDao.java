package es.capgemini.pfs.acuerdo.dao;

import es.capgemini.pfs.acuerdo.model.DDCambioSolvenciaAcuerdo;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author pamuller
 *
 */
public interface DDCambioSolvenciaAcuerdoDao extends AbstractDao<DDCambioSolvenciaAcuerdo, Long> {

    /**
     * Busca un DDCambioSolvenciaAcuerdo.
     * @param codigo String: el codigo del DDCambioSolvenciaAcuerdo
     * @return DDCambioSolvenciaAcuerdo.
     */
    DDCambioSolvenciaAcuerdo buscarPorCodigo(String codigo);
}
