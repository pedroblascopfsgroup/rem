package es.capgemini.pfs.security;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.security.userdetails.UsernameNotFoundException;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.autenticacionLog.AuthenticationLogApi;
import es.capgemini.pfs.dsm.DataSourceManager;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

public class KerberosUserDetailsService extends DefaultUserDetailsService {
	

	@Resource
	private Properties appProperties;
	
	private final Log logger = LogFactory.getLog(getClass());

	private KerberosAuthenticationFacade facadeKerberos;

    @Autowired
    private UsuarioSecurityManager usuarioManager;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	public KerberosUserDetails loadUserByUsernameAndEntity(String username,
			String workingCode) {

		logger.info("loadUserByUsernameAndEntity:username=" + username + ",workingCode=" + workingCode);

		UsuarioSecurity usuario = usuarioManager.getByUsernameAndEntity(username, workingCode);
        if (usuario == null) {
			logger.error("KerberosUserDetails: El usuario " + username + " no está correctamente configurado en Recovery.");
        	registrarLogErroneo(username);
            throw new UsernameNotFoundException("Usuario no encontrado");
        }
        setDBAndLoadAuthorities(usuario);

        KerberosUserDetails kud = new KerberosUserDetails(usuario, facadeKerberos, workingCode);
		
		return kud;
		
	}

	@Override
	public KerberosUserDetails loadUserByUsername(String username) {

		logger.info("loadUserByUsername:username=" + username);

		UsuarioSecurity usuario = usuarioManager.getByUsername(username);
        if (usuario == null) {
			logger.error("KerberosUserDetails: El usuario " + username + " no está correctamente configurado en Recovery.");
			registrarLogErroneo(username);
            throw new UsernameNotFoundException("Usuario no encontrado");
        }
        setDBAndLoadAuthorities(usuario);
        
		KerberosUserDetails kud = new KerberosUserDetails(usuario, facadeKerberos);
		
		return kud;
		
	}

	public KerberosAuthenticationFacade getFacadeKerberos() {
		return facadeKerberos;
	}

	public void setFacadeKerberos(KerberosAuthenticationFacade facadeKerberos) {
		this.facadeKerberos = facadeKerberos;
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

    private void registrarLogErroneo(String username) {
    	
    	HttpServletRequest request = facadeKerberos.getRequest();
    	String remoteIP = request.getRemoteAddr();
		//obtener IP del servidor
		String ipHost = "127.0.0.1";
		try {
			ipHost = InetAddress.getByName(request.getServerName()).getHostAddress();
		} catch (UnknownHostException e) {
			logger.error("checkAuthentication: error al obtener la IP del servidor.");
		} 
		proxyFactory.proxy(AuthenticationLogApi.class).registrarLoginError(ipHost, remoteIP, username);
		
    }
}
