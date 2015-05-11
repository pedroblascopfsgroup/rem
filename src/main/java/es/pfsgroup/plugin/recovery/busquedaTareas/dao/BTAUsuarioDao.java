package es.pfsgroup.plugin.recovery.busquedaTareas.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;

public interface BTAUsuarioDao extends AbstractDao<Usuario, Long>{
	
    /**
     * Recupera el Usuario por el nombre.
     * @param usernameToFind string
     * @return Usuario
     */
    Usuario getByUsername(String usernameToFind);

}
