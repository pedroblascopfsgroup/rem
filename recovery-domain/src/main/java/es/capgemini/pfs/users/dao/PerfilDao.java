package es.capgemini.pfs.users.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Perfil;

/**
 * Dao perfil.
 * @author jbosnjak
 *
 */
public interface PerfilDao extends AbstractDao<Perfil, Long> {

    /**
     * Recupera el perfil correspondiente al codigo indicado.
     * @param codigo String
     * @return perfil
     */
    Perfil buscarPorCodigo(String codigo);
}
