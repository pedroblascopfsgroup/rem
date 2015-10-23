package es.pfsgroup.recovery.integration;

import org.springframework.security.Authentication;
import org.springframework.security.AuthenticationException;
import org.springframework.security.userdetails.AuthenticationUserDetailsService;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.util.Assert;

import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.commons.utils.Checks;

/**
 * Autenticación de usaurio con los UserDetails que se pasan 
 * @author gonzalo
 *
 */
public class AuthenticationPayloadService implements AuthenticationUserDetailsService {

	private String userNameprefix;
	
	public String getUserNameprefix() {
		return userNameprefix;
	}

	public void setUserNameprefix(String userNameprefix) {
		this.userNameprefix = userNameprefix;
	}

	/**
	 * Get a UserDetails object based on the user name contained in the given
	 * token, and the GrantedAuthorities as returned by the
	 * GrantedAuthoritiesContainer implementation as returned by
	 * the token.getDetails() method.
	 */
	@Override
	public final UserDetails loadUserDetails(Authentication token) throws AuthenticationException {
		Assert.notNull(token.getDetails());
		Assert.isInstanceOf(UsuarioSecurity.class, token.getDetails());
		UsuarioSecurity ud = (UsuarioSecurity)token.getDetails();
		if (!Checks.esNulo(this.userNameprefix)) {
			String username = clearUserName(ud.getUsername());
			String newUserName = String.format("%s%s", userNameprefix, username);
			ud.setUsername(newUserName);
		}
		return ud;
	}
	
	private String clearUserName(String userName) {
		if (userName==null || userNameprefix==null) return null;
		return userName.replace(userNameprefix, ""); 
	}
}
