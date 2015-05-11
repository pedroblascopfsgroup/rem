package es.capgemini.pfs.security;

import java.util.Set;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.security.userdetails.UserDetailsService;
import org.springframework.security.userdetails.UsernameNotFoundException;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.DataSourceManager;

import es.capgemini.pfs.security.model.UsuarioSecurity;

/**
 * TODO Documentar.
 *
 * @author Nicol�s Cornaglia
 * @see EntityDataSource
 */
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = true)
public class DefaultUserDetailsService implements UserDetailsService {

    @Autowired
    private UsuarioSecurityManager usuarioManager;

    /**
     * {@inheritDoc}
     */
    @Override
    public UserDetails loadUserByUsername(String username) {
        UsuarioSecurity usuario = usuarioManager.getByUsername(username);
        if (usuario == null) {
            //TODO i18n el mensaje, como?
            throw new UsernameNotFoundException("Usuario no encontrado");
        }
        setDBAndLoadAuthorities(usuario);
        return usuario;
    }

    /**
     * {@inheritDoc}
     */
    public UserDetails loadUserByUsernameAndEntity(String username, String workingCode) {
        UsuarioSecurity usuario = usuarioManager.getByUsernameAndEntity(username, workingCode);
        if (usuario == null) {
            //TODO i18n el mensaje, como?
            throw new UsernameNotFoundException("Usuario no encontrado");
        }
        setDBAndLoadAuthorities(usuario);
        return usuario;
    }


    private void setDBAndLoadAuthorities(UsuarioSecurity usuario) {
        // Guardar el ID de la entidad como ID de base de datos.
        if (usuario.getEntidad() == null) {
            DbIdContextHolder.setDbId(DataSourceManager.MASTER_DATASOURCE_ID);
        } else {
            String schema = usuario.getEntidad().configValue(DataSourceManager.SCHEMA_KEY, "pfs0" + usuario.getEntidad().getId());
            DbIdContextHolder.setDb(usuario.getEntidad().getId(), schema);
        }
        // Inicializar los perfiles ahora que el id de la base de datos está configurado.
        //usuario.getPerfiles().size();
        Hibernate.initialize(usuario.getPerfiles());

        // Obtener sus "Authorities"
        Set<GrantedAuthority> authorities = usuarioManager.getAuthorities(usuario);
        authorities.add(new GrantedAuthorityImpl("ROLE_USER"));
        authorities.add(new GrantedAuthorityImpl("ROLE_ANONYMOUS"));
        usuario.setAuthorities(authorities);

    }

}
