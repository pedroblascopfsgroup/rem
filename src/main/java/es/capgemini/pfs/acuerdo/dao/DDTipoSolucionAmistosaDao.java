package es.capgemini.pfs.acuerdo.dao;

import es.capgemini.pfs.acuerdo.model.DDTipoSolucionAmistosa;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Mariano Ruiz
 *
 */
public interface DDTipoSolucionAmistosaDao extends AbstractDao<DDTipoSolucionAmistosa, Long> {

    /**
     * Busca un DDTipoSolucionAmistosa.
     * @param codigo String: el codigo del DDTipoSolucionAmistosa
     * @return DDTipoSolucionAmistosa
     */
    DDTipoSolucionAmistosa buscarPorCodigo(String codigo);
}
