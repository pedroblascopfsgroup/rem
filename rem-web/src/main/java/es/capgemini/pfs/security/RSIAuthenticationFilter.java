package es.capgemini.pfs.security;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.AuthenticationException;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.ui.WebAuthenticationDetails;
import org.springframework.security.userdetails.UserDetails;

import es.capgemini.devon.security.AuthenticationFilter;
import es.capgemini.pfs.zona.ZonaManager;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * @author NicolÃ¡s Cornaglia
 */
public class RSIAuthenticationFilter implements AuthenticationFilter {

    protected static final Log logger = LogFactory.getLog(RSIAuthenticationFilter.class);

    @Autowired
    private ZonaManager zonaManager;

    /**
     * @see es.capgemini.devon.security.AuthenticationFilter#check(org.springframework.security.userdetails.UserDetails,
     *      org.springframework.security.providers.UsernamePasswordAuthenticationToken)
     */
    @Override
    public void check(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws RSIAuthenticationException {
        // El workingcode y el centro deben estar siempre presentes
        if (((RSIWebAuthenticationDetails) authentication.getDetails()).getWorkingCode() == null) {
            throw new RSIAuthenticationException("Empty workingcode", "user:" + userDetails.getUsername() + " ip:" + ((WebAuthenticationDetails) authentication.getDetails()).getRemoteAddress());
        }
        if (((RSIWebAuthenticationDetails) authentication.getDetails()).getCentro() == null) {
            throw new RSIAuthenticationException("Empty centro", "user:" + userDetails.getUsername() + " ip:" + ((WebAuthenticationDetails) authentication.getDetails()).getRemoteAddress());
        }
        // El centro debe existir
        String centro = ((RSIWebAuthenticationDetails) authentication.getDetails()).getCentro();
        DDZona zona = zonaManager.getZonaPorCentro(centro);
        if (zona == null) {
            throw new RSIAuthenticationException("Centro inexistente", "centro:" + centro + " user:" + userDetails.getUsername() + " ip:"
                    + ((WebAuthenticationDetails) authentication.getDetails()).getRemoteAddress());
        }
    }

}
