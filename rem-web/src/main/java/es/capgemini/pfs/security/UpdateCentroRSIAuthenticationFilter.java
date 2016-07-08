package es.capgemini.pfs.security;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.ui.WebAuthenticationDetails;
import org.springframework.security.userdetails.UserDetails;

import es.capgemini.devon.security.AuthenticationFilter;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.zona.ZonaManager;
import es.capgemini.pfs.zona.dao.ZonaDao;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * @author NicolÃ¡s Cornaglia
 */
public class UpdateCentroRSIAuthenticationFilter implements AuthenticationFilter {

    protected static final Log logger = LogFactory.getLog(UpdateCentroRSIAuthenticationFilter.class);

    @Autowired
    private ZonaDao zonaDao;

    @Autowired
    private ZonaManager zonaManager;

    @Autowired
    private UsuarioManager usuarioManager;

    /**
     * @see es.capgemini.devon.security.AuthenticationFilter#check(org.springframework.security.userdetails.UserDetails, org.springframework.security.providers.UsernamePasswordAuthenticationToken)
     */
    @Override
    public void check(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws RSIAuthenticationException {
        // Update de la zonificaciÃ³n del usuario en base al centro
        String centro = ((RSIWebAuthenticationDetails) authentication.getDetails()).getCentro();
        DDZona zona = zonaManager.getZonaPorCentro(centro);
        if (zona == null) { throw new RSIAuthenticationException("Centro inexistente", "centro:" + centro + " user:" + userDetails.getUsername()
                + " ip:" + ((WebAuthenticationDetails) authentication.getDetails()).getRemoteAddress()); }

        Long idZona = zona.getId();
        Long idUsuario = usuarioManager.getByUsername(userDetails.getUsername()).getId();

        zonaDao.updateZonaUsuarioItinerante(idUsuario, idZona);
        // Update de la zonificaciÃ³n del usuario en base al centro
    }

}
