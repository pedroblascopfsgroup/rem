package es.capgemini.pfs.users.dao;

import java.util.List;
import java.util.Set;

import org.springframework.security.GrantedAuthority;

import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Dao para Usuario.
 */
public interface UsuarioDao extends AbstractDao<Usuario, Long> {

    /**
     * Buscar usuarios por nombre.
     * @param usernameToFind string
     * @return Lista de usuarios
     */
    List<Usuario> findByUsername(String usernameToFind);

    /**
     * Buscar usuarios por nombre.
     * @param usernameToFind string
     * @param tableParams PaginationParams
     * @return Page
     */
    Page findByUsername(String usernameToFind, PaginationParams tableParams);

    /**
     * Recupera el Usuario por el nombre.
     * @param usernameToFind string
     * @return Usuario
     */
    Usuario getByUsername(String usernameToFind);

    /**
     * Recupera los Authorities del usuario.
     * @param usuario Usuario
     * @return Set de GrantedAuthority
     */
    @Deprecated
    Set<GrantedAuthority> getAuthorities(Usuario usuario);

    /**
     * Devuelve los usuarios que estén en esa zona y perfil.
     * @param idZona Zona del usuario
     * @param idPerfil Perfil del usuario
     * @return lista de usuarios
     */
    List<Usuario> getUsuariosZonaPerfil(Long idZona, Long idPerfil);

    /**
     * Recupera los usuarios que tienen email y son de una entidad en concreto.
     * @param idEntidad Entidad de la que estoy buscando usuarios
     * @return Listado de usuarios con email
     */
    List<Usuario> getUsuariosWithMail(Long idEntidad);

    /**
     * Recupera el objeto UsuarioSecurity a partir de su id
     * @param idUsuario
     * @return
     */
    UsuarioSecurity getUsuarioSecurity(Long idUsuario);
    
    /**
     * Recupera la lista de grantedAuthorities de un usuario a partir de su id (usado en el cambio de entidad de usuario)
     * @param idUsuario
     * @return
     */
    Set<GrantedAuthority> getAuthoritiesCambioEntidad(Long idUsuario);

}
