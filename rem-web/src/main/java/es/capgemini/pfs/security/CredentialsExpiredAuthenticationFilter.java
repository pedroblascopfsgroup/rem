package es.capgemini.pfs.security;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.userdetails.UserDetails;

import es.capgemini.devon.security.AuthenticationFilter;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.capgemini.pfs.utils.FormatUtils;

/**
 * @author MartÃ­n IÃ±igo
 */
public class CredentialsExpiredAuthenticationFilter implements AuthenticationFilter {


    protected static final Log logger = LogFactory.getLog(CredentialsExpiredAuthenticationFilter.class);

    /**
     * Manager de la entidad UsuarioSecurity.
     */
    @Autowired
    private UsuarioSecurityManager usuarioSecurityManager;

    /**
     * Controla que la contraseÃ±a no haya expirado.
     * @param userDetails
     * @param authentication
     * @throws RSIAuthenticationException
     */
    @Override
    public void check(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws CredentialsExpiredAuthenticationException {
    	
    	UsuarioSecurity usuarioSecurity = usuarioSecurityManager.getByUsername(userDetails.getUsername());
    	
    	Date vigenciaPassword = usuarioSecurity.getFechaVigenciaPassword();
    	
		Date toDay = FormatUtils.fechaSinHora(new Date());
		
		if (vigenciaPassword.compareTo(toDay) <= 0 ){
			CredentialsExpiredAuthenticationException credentialExpireException = new CredentialsExpiredAuthenticationException("ContraseÃ±a Expirada", "user:" + userDetails.getUsername());
			throw credentialExpireException;
    	}    
	}

}
