package es.capgemini.pfs.acuerdo.dao;

import es.capgemini.pfs.acuerdo.model.DDValoracionActuacionAmistosa;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Mariano Ruiz
 *
 */
public interface DDValoracionActuacionAmistosaDao extends AbstractDao<DDValoracionActuacionAmistosa, Long> {

    /**
     * Busca un DDValoracionActuacionAmistosa.
     * @param codigo String: el codigo del DDValoracionActuacionAmistosa
     * @return DDValoracionActuacionAmistosa
     */
    DDValoracionActuacionAmistosa buscarPorCodigo(String codigo);
}
