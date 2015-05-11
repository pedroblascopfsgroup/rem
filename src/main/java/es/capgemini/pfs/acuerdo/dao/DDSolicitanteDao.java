package es.capgemini.pfs.acuerdo.dao;

import es.capgemini.pfs.acuerdo.model.DDSolicitante;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Mariano Ruiz
 *
 */
public interface DDSolicitanteDao extends AbstractDao<DDSolicitante, Long> {

    /**
     * Busca un DDSolicitante.
     * @param codigo String: el codigo del DDSolicitante
     * @return DDSolicitante
     */
    DDSolicitante buscarPorCodigo(String codigo);
}
