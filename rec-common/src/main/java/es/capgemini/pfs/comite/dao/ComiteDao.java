package es.capgemini.pfs.comite.dao;

import java.util.List;

import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * @author Andrés Esteban
 *
 */
public interface ComiteDao extends AbstractDao<Comite, Long> {

    /**
     * Busca el comité al que se enviaría un expediente en el caso de querer elevarlo.
     * @param c el comité actual
     * @return el nuevo comité o null si no hay ninguno.
     */
    Comite buscarComiteParaElevar(Comite c);

    /**
    * Busca los comités a los que podría delegar.
    * @param comite el comité actual.
    * @return la lista de comités a los que puede delegar.
    */
    List<Comite> buscarComitesParaDelegar(Comite comite);

    /**
     * Recupera los comités válidos (abiertos, con expedientes o preasuntos) de un usuario dado
     * @param usuario
     * @return
     */
    List<Comite> findComitesValidosCurrentUser(Usuario usuario);
}
