package es.capgemini.pfs.comite.dao;

import java.util.List;

import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * @author Andr�s Esteban
 *
 */
public interface ComiteDao extends AbstractDao<Comite, Long> {

    /**
     * Busca el comit� al que se enviar�a un expediente en el caso de querer elevarlo.
     * @param c el comit� actual
     * @return el nuevo comit� o null si no hay ninguno.
     */
    Comite buscarComiteParaElevar(Comite c);

    /**
    * Busca los comit�s a los que podr�a delegar.
    * @param comite el comit� actual.
    * @return la lista de comit�s a los que puede delegar.
    */
    List<Comite> buscarComitesParaDelegar(Comite comite);

    /**
     * Recupera los comit�s v�lidos (abiertos, con expedientes o preasuntos) de un usuario dado
     * @param usuario
     * @return
     */
    List<Comite> findComitesValidosCurrentUser(Usuario usuario);
}
