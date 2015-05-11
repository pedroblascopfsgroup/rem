package es.capgemini.pfs.security;

import java.util.HashSet;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.security.dao.UsuarioSecurityDao;
import es.capgemini.pfs.security.model.FuncionSecurity;
import es.capgemini.pfs.security.model.PerfilSecurity;
import es.capgemini.pfs.security.model.UsuarioSecurity;

/**
 * TODO Documentar.
 * @author Nicolás Cornaglia
 */
@Service
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = true)
public class UsuarioSecurityManager {

    @Autowired
    private UsuarioSecurityDao usuarioDao;

    /**
     * Obtener un usuario por nombre.
     * @param username String
     * @return UsuarioSecurity
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USR_SEC_MGR_GET_BY_USERNAME)
    public UsuarioSecurity getByUsername(String username) {
        return usuarioDao.getByUsername(username);
    }

    /**
     * Obtener un usuario por nombre y entidad.
     * @param username string
     * @param entity string
     * @return UsuarioSecurity
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USR_SEC_MGR_GET_BY_USERNAME_AND_ENTITY)
    public UsuarioSecurity getByUsernameAndEntity(String username, String entity) {
        return usuarioDao.getByUsernameAndEntity(username, entity);
    }

    /**
     * @param id Long
     * @return UsuarioSecurity
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USR_SEC_MGR_GET)
    public UsuarioSecurity get(Long id) {
        return usuarioDao.get(id);
    }

    /**
     * @return UsuarioSecurity
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USR_SEC_MGR_GET_USUARIO_LOGADO)
    public UsuarioSecurity getUsuarioLogado() {
        return (UsuarioSecurity) SecurityUtils.getCurrentUser();
    }

    /**
     * Obtiene una lista de las funciones a las que el usuario puede acceder
     * basado en los perfiles que tiene asignados.
     * @param usuario UsuarioSecurity
     * @return Set GrantedAuthority
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_USR_SEC_MGR_GET_AUTHORITIES)
    public Set<GrantedAuthority> getAuthorities(UsuarioSecurity usuario) {
        // Deprecated: usuarioDao.getAuthorities(usuario);
        Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();

        for (PerfilSecurity perfil : usuario.getPerfiles()) {
            for (FuncionSecurity funcion : perfil.getFunciones()) {
                authorities.add(new GrantedAuthorityImpl(funcion.getDescripcion()));
            }
        }
        return authorities;
    }

}
