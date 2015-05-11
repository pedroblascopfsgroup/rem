package es.capgemini.pfs.acuerdo.dao;

import es.capgemini.pfs.acuerdo.model.DDResultadoAcuerdoActuacion;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Mariano Ruiz
 *
 */
public interface DDResultadoAcuerdoActuacionDao extends AbstractDao<DDResultadoAcuerdoActuacion, Long> {

    /**
     * Busca un DDResultadoAcuerdoActuacion.
     * @param codigo String: el codigo del DDResultadoAcuerdoActuacion
     * @return DDResultadoAcuerdoActuacion
     */
    DDResultadoAcuerdoActuacion buscarPorCodigo(String codigo);
}
