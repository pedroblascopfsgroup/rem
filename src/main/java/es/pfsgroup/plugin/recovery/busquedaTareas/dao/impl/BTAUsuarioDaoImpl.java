package es.pfsgroup.plugin.recovery.busquedaTareas.dao.impl;

import java.util.List;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.busquedaTareas.dao.BTAUsuarioDao;

@Repository("BTAUsuarioDao")
public class BTAUsuarioDaoImpl extends AbstractEntityDao<Usuario, Long> implements BTAUsuarioDao {

	@SuppressWarnings("unchecked")
	public Usuario getByUsername(String usernameToFind) {
		List<Usuario> users = getHibernateTemplate().find("from Usuario u where u.username = ?", usernameToFind);
        if (users.size() == 0) {
            return null;
        } else if (users.size() > 1) {
            throw new DataIntegrityViolationException("Duplicate user: " + usernameToFind);
        } else {
            return users.get(0);
        }
	}

}
