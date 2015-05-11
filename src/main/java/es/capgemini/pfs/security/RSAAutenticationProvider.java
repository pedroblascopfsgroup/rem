package es.capgemini.pfs.security;

import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.security.AuthenticationException;
import org.springframework.security.AuthenticationServiceException;
import org.springframework.security.BadCredentialsException;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.userdetails.UserDetails;

import es.capgemini.devon.security.DevonAuthenticationProvider;

public class RSAAutenticationProvider extends DevonAuthenticationProvider {


	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Resource
	private Properties appProperties;
	 
	@Override
    protected void additionalAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication)
            throws AuthenticationException {
		logger.info("additionalAuthenticationChecks");
		//System.out.println("additionalAuthenticationChecks");
        doPreAuthenticationChecks(userDetails, authentication);
       
        // Checkear el usuario/contrase�a por el m�todo normal
        try {
            super.doAuthenticationCheck(userDetails, authentication);
        } catch (BadCredentialsException e) {
            // Ignorar... por URL la contrase�a no se valida
        }

        doPostAuthenticationChecks(userDetails, authentication);

        // TODO: Hacer un filter para verificar que el centro está dentro de los permitidos para este usuario

    }

    /**
     * Sobreescrito para obtener el usuario por "workingcode" + "username".
     * 
     * @param username
     * @param authentication
     * @return
     * @throws AuthenticationException
     * @see {@link RSIWebAuthenticationDetails}
     */
    @Override
    protected UserDetails retrieveUser(String username, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        UserDetails loadedUser;
        
        String validez = appProperties.getProperty("security.validezTimeStamp");
		String rutaClavePublica = appProperties.getProperty("security.rutaClavePublica");
		String rutaClavePrivada = appProperties.getProperty("security.rutaClavePrivada");
		
		if(validez == null){
			logger.error("Falta la propiedad security.validezTimeStamp en el devon.properties");
			throw new AuthenticationServiceException("Autentificacion incorrecta");
		}
		if(rutaClavePublica == null ){
			logger.error("Falta la propiedad security.rutaClavePublica en el devon.properties");
			throw new AuthenticationServiceException("Autentificacion incorrecta");
		}
		if( rutaClavePrivada == null){
			logger.error("Falta la propiedad security.rutaClavePrivada en el devon.properties");
			throw new AuthenticationServiceException("Autentificacion incorrecta");
		}
        
        try {
        	Object o = authentication.getDetails();
            RSAUserDetails authDetails = ((RSAUserDetailsService) this.getUserDetailsService()).loadUserByUsernameAndEntity(username,((RSAWebAuthenticationDetails) o).getWorkingCode());
            if (authDetails == null) {
                throw new AuthenticationServiceException("UserDetailsService returned null, which is an interface contract violation");
            }
            loadedUser = authDetails.getUserDetails();
//            boolean res = ((RSAUserDetailsService) this.getUserDetailsService()).comprobarTimeStampParametro(authDetails.getDecrypterStatus());
//            if(!res)
//            	throw new AuthenticationServiceException("Autentificacion incorrecta");
            //loadUser
        } catch (DataAccessException repositoryProblem) {
            throw new AuthenticationServiceException(repositoryProblem.getMessage(), repositoryProblem);
        }
        
        return loadedUser;
        
 
    }
}
