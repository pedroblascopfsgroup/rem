package es.capgemini.pfs.security;

import org.springframework.dao.DataAccessException;
import org.springframework.security.AuthenticationException;
import org.springframework.security.AuthenticationServiceException;
import org.springframework.security.BadCredentialsException;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.userdetails.UserDetails;

import es.capgemini.devon.security.DevonAuthenticationProvider;

/**
 * Untenticador de RSI, basado en URL seguras filtradas previamente por infraestructura.
 * 
 * @author Nicol�s Cornaglia
 */
public class RSIAuthenticationProvider extends DevonAuthenticationProvider {

    @Override
    protected void additionalAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication)
            throws AuthenticationException {

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

        try {
            loadedUser = ((DefaultUserDetailsService) this.getUserDetailsService()).loadUserByUsernameAndEntity(username,
                    ((RSIWebAuthenticationDetails) authentication.getDetails()).getWorkingCode());
        } catch (DataAccessException repositoryProblem) {
            throw new AuthenticationServiceException(repositoryProblem.getMessage(), repositoryProblem);
        }

        if (loadedUser == null) {
            throw new AuthenticationServiceException("UserDetailsService returned null, which is an interface contract violation");
        }
        return loadedUser;
    }

}
