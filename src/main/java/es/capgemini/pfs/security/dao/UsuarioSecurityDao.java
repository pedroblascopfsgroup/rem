package es.capgemini.pfs.security.dao;

import java.util.Set;

import org.springframework.security.GrantedAuthority;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.security.model.UsuarioSecurity;

/**
 * Dao para UsuarioSecurity.
 *
 */
public interface UsuarioSecurityDao extends AbstractDao<UsuarioSecurity, Long> {

    /**
     * Recupera UsuarioSecurity por username.
     * @param username String
     * @return UsuarioSecurity
     */
    UsuarioSecurity getByUsername(String username);

    /**
     * Recupera UsuarioSecurity por username y entidad.
     * @param username String
     * @param workingCode String
     * @return UsuarioSecurity
     */
    UsuarioSecurity getByUsernameAndEntity(String username, String workingCode);

    /**
     * Recupera los GrantedAuthority para el usuario.
     * @param usuario Usuario
     * @return Set GrantedAuthority
     */
    @Deprecated
    Set<GrantedAuthority> getAuthorities(UsuarioSecurity usuario);

}
