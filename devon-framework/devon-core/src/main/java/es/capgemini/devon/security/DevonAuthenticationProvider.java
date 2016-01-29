package es.capgemini.devon.security;

import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.security.AuthenticationCredentialsNotFoundException;
import org.springframework.security.AuthenticationException;
import org.springframework.security.AuthenticationServiceException;
import org.springframework.security.BadCredentialsException;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.providers.dao.AbstractUserDetailsAuthenticationProvider;
import org.springframework.security.providers.dao.SaltSource;
import org.springframework.security.providers.encoding.PasswordEncoder;
import org.springframework.security.providers.encoding.PlaintextPasswordEncoder;
import org.springframework.security.ui.WebAuthenticationDetails;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.security.userdetails.UserDetailsService;
import org.springframework.util.Assert;

/**
 * @author Nicolás Cornaglia
 */
public class DevonAuthenticationProvider extends AbstractUserDetailsAuthenticationProvider {

    private PasswordEncoder passwordEncoder = new PlaintextPasswordEncoder();
    private SaltSource saltSource;
    private UserDetailsService userDetailsService;
    private boolean includeDetailsObject = true;

    private List<AuthenticationFilter> preAuthenticationFilters = new ArrayList<AuthenticationFilter>();
    private List<AuthenticationFilter> postAuthenticationFilters = new ArrayList<AuthenticationFilter>();

    /**
     * Ejecuta los filtros com oparte adicional a la validación de usuario/contraseña
     * 
     * @see org.springframework.security.providers.dao.DaoAuthenticationProvider#additionalAuthenticationChecks(org.springframework.security.userdetails.UserDetails, org.springframework.security.providers.UsernamePasswordAuthenticationToken)
     */
    @Override
    protected void additionalAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication)
            throws AuthenticationException {

        doPreAuthenticationChecks(userDetails, authentication);

        // Checkear el usuario/contraseña por el método normal
        doAuthenticationCheck(userDetails, authentication);

        doPostAuthenticationChecks(userDetails, authentication);
    }

    protected void doPreAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication)
            throws AuthenticationException {
        for (AuthenticationFilter filter : preAuthenticationFilters) {
            filter.check(userDetails, authentication);
        }
    }

    protected void doAuthenticationCheck(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        Object salt = null;

        if (this.saltSource != null) {
            salt = this.saltSource.getSalt(userDetails);
        }

        if (authentication.getCredentials() == null) {
            throw new AuthenticationCredentialsNotFoundException(messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials"));
        }

        String presentedPassword = authentication.getCredentials().toString();

        if (!passwordEncoder.isPasswordValid(userDetails.getPassword(), presentedPassword, salt)) {
            throw new BadCredentialsException(messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials", "Bad credentials"),
                    includeDetailsObject ? userDetails : null);
        }
    }

    protected void doPostAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication)
            throws AuthenticationException {
        for (AuthenticationFilter filter : postAuthenticationFilters) {
            filter.check(userDetails, authentication);
        }
    }

    @Override
    protected void doAfterPropertiesSet() throws Exception {
        Assert.notNull(this.userDetailsService, "A UserDetailsService must be set");
    }

    @Override
    protected UserDetails retrieveUser(String username, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        UserDetails loadedUser;

        try {
            loadedUser = this.getUserDetailsService().loadUserByUsername(username);
            WebAuthenticationDetails ad = (WebAuthenticationDetails) authentication.getDetails();
            ((SecurityUserInfo) loadedUser).setLoginTime(System.currentTimeMillis());
            if (ad != null) {
                ((SecurityUserInfo) loadedUser).setRemoteAddress(ad.getRemoteAddress());
            }
        } catch (DataAccessException repositoryProblem) {
            throw new AuthenticationServiceException(repositoryProblem.getMessage(), repositoryProblem);
        }

        if (loadedUser == null) {
            throw new AuthenticationServiceException("UserDetailsService returned null, which is an interface contract violation");
        }
        return loadedUser;
    }

    /**
     * @param preAuthenticationFilters the preAuthenticationFilters to set
     */
    public void setPreAuthenticationFilters(List<AuthenticationFilter> preAuthenticationFilters) {
        this.preAuthenticationFilters = preAuthenticationFilters;
    }

    /**
     * @param postAuthenticationFilters the postAuthenticationFilters to set
     */
    public void setPostAuthenticationFilters(List<AuthenticationFilter> postAuthenticationFilters) {
        this.postAuthenticationFilters = postAuthenticationFilters;
    }

    /**
     * Sets the PasswordEncoder instance to be used to encode and validate passwords.
     * If not set, {@link PlaintextPasswordEncoder} will be used by default.
     *
     * @param passwordEncoder The passwordEncoder to use
     */
    public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }

    protected PasswordEncoder getPasswordEncoder() {
        return passwordEncoder;
    }

    /**
     * The source of salts to use when decoding passwords. <code>null</code>
     * is a valid value, meaning the <code>DaoAuthenticationProvider</code>
     * will present <code>null</code> to the relevant <code>PasswordEncoder</code>.
     *
     * @param saltSource to use when attempting to decode passwords via the <code>PasswordEncoder</code>
     */
    public void setSaltSource(SaltSource saltSource) {
        this.saltSource = saltSource;
    }

    protected SaltSource getSaltSource() {
        return saltSource;
    }

    public void setUserDetailsService(UserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }

    protected UserDetailsService getUserDetailsService() {
        return userDetailsService;
    }

    protected boolean isIncludeDetailsObject() {
        return includeDetailsObject;
    }

}
