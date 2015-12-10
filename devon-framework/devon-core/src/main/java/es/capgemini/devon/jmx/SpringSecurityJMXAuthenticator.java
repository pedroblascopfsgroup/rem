package es.capgemini.devon.jmx;

import java.util.List;

import javax.management.remote.JMXAuthenticator;
import javax.management.remote.JMXPrincipal;
import javax.security.auth.Subject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.Authentication;
import org.springframework.security.AuthenticationManager;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;

public class SpringSecurityJMXAuthenticator implements JMXAuthenticator {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private List<String> rolesAllowed;

    public Subject authenticate(Object credentials) {

        if (!(credentials instanceof String[])) {
            if (credentials == null) {
                throw new SecurityException("Credentials required");
            }
            throw new SecurityException("Credentials should be String[]");
        }

        String[] aCredentials = (String[]) credentials;
        if (aCredentials.length != 2) {
            throw new SecurityException("Credentials should have 2 elements (username/password)");
        }

        // Authenticate the user with Spring Security
        Authentication authentication = new UsernamePasswordAuthenticationToken(aCredentials[0], aCredentials[1]);
        authentication = authenticationManager.authenticate(authentication); //throws AuthenticationException

        // Check the allowed roles
        boolean allowed = false;
        for (GrantedAuthority authority : authentication.getAuthorities()) {
            for (String rol : rolesAllowed) {
                if (rol.equals(authority.getAuthority())) {
                    allowed = true;
                    break;
                }
            }
        }
        if (!allowed) {
            throw new SecurityException("Unauthorized access");
        }

        // Set the Spring Security User
        SecurityContextHolder.getContext().setAuthentication(authentication);

        // Generate the Security User
        Subject subject = new Subject();
        subject.getPrincipals().add(new JMXPrincipal(aCredentials[0]));
        return subject;
    }

    public void setAuthenticationManager(AuthenticationManager authenticationManager) {
        this.authenticationManager = authenticationManager;
    }

    public void setRolesAllowed(List<String> rolesAllowed) {
        this.rolesAllowed = rolesAllowed;
    }

}
