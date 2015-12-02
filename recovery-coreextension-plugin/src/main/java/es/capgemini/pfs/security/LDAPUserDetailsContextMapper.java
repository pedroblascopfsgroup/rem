package es.capgemini.pfs.security;

import java.util.Set;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ldap.core.DirContextAdapter;
import org.springframework.ldap.core.DirContextOperations;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.security.userdetails.UsernameNotFoundException;
import org.springframework.security.userdetails.ldap.UserDetailsContextMapper;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.DataSourceManager;
import es.capgemini.pfs.security.model.UsuarioSecurity;
 
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = true)
public class LDAPUserDetailsContextMapper implements UserDetailsContextMapper {

    @Autowired
    private UsuarioSecurityManager usuarioManager;
	
	@Override
	public UserDetails mapUserFromContext(DirContextOperations ctx, String username, GrantedAuthority[] authority) {
        UsuarioSecurity usuario = usuarioManager.getByUsername(username);
        if (usuario == null) {
            //TODO i18n el mensaje, como?
            throw new UsernameNotFoundException("Usuario no encontrado en recovery");
        }
        setDBAndLoadAuthorities(usuario);
		return usuario;
	}

	@Override
	public void mapUserToContext(UserDetails user, DirContextAdapter ctx) {
		
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
