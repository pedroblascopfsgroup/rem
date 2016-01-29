package es.capgemini.devon.security;

import org.springframework.security.Authentication;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.userdetails.UserDetails;

/** Clase que agrupa funcionalidad relativa a la seguridad
 * @author amarinso
 *
 */
public class SecurityUtils {

    /** Obtiene el usuario logado
     * @return
     */
    public static UserDetails getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication ==null || authentication.getPrincipal() instanceof String) {
            return null;
        }
        return (UserDetails) (authentication == null ? null : authentication.getPrincipal());

    }

}
