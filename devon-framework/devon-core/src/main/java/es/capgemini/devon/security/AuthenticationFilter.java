package es.capgemini.devon.security;

import org.springframework.security.AuthenticationException;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.userdetails.UserDetails;

/**
 * @author Nicol�s Cornaglia
 */
public interface AuthenticationFilter {

    public void check(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException;

}
