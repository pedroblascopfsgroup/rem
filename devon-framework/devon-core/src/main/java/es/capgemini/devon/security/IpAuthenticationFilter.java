package es.capgemini.devon.security;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.ui.WebAuthenticationDetails;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.util.PatternMatchUtils;

import es.capgemini.devon.net.IP;
import es.capgemini.devon.net.IPList;
import es.capgemini.devon.utils.DatabaseUtils;

/**
 * Filtro utilizado durante la autenticación para bloquear/permitir el acceso según la IP del usuario que se conecte.<br/>
 * <br/>
 * El proceso de filtrado se basa en 2 listas de permisos, que se evalúan en orden:
 * <il>
 * <ul>1. IPs NO permitidas para el usuario o para los authorities del usuario</ul>
 * <ul>3. IPs permitidas para el usuario o para los authorities del usuario</ul>
 * </il>
 * <br/>
 * Si el usuario o algún authority del usuario está en la primer lista, se deniega el acceso.<br/>
 * Si ni el usuario ni los authorities del usuario están en la segunda lista se deniega el acceso.<br/>
 * <br/>
 * La lista de permisos se configura en forma de Properties, por ejemplo:<br/>
 * <br/>
 * # El admin puede entrar desde cualquier lado<br/>
 * admin = *.*.*.*<br/>
 * <br/>
 * # El usuario "user11" no puede ingresar desde localhost<br/>
 * user11 = !127.0.0.1<br/>
 * <br/>
 * # Los usuarios que comience con "user" pueden ingresar desde localhost, 10.68.8.68 y wxpvdval01.corp.capgemini.com<br/>
 * user* = 127.0.0.1, 10.68.8.68, wxpvdval01.corp.capgemini.com<br/>
 * <br/>
 * # El authority COMISION no puede ingresar desde 10.68.1.1 pero si desde 10.68.1.2<br/> 
 * [COMISION] = !10.68.1.1, 10.68.1.2<br/>
 * <br/>
 * @author Nicolás Cornaglia
 */
public class IpAuthenticationFilter implements AuthenticationFilter {

    protected static final Log logger = LogFactory.getLog(DatabaseUtils.class);

    private Map<String, IPList> allowedIps = new HashMap<String, IPList>();
    private Map<String, IPList> notAllowedIps = new HashMap<String, IPList>();

    /**
     * @see es.capgemini.devon.security.AuthenticationFilter#check(org.springframework.security.userdetails.UserDetails, org.springframework.security.providers.UsernamePasswordAuthenticationToken)
     */
    @Override
    public void check(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws IpNotAllowedException {
        if (!isIPAllowed(userDetails.getUsername(), userDetails.getAuthorities(), ((WebAuthenticationDetails) authentication.getDetails())
                .getRemoteAddress())) {
            throw new IpNotAllowedException("Ip not allowed for user", "user:" + userDetails.getUsername() + " ip:"
                    + ((WebAuthenticationDetails) authentication.getDetails()).getRemoteAddress());
        }
    }

    /**
     * @param username
     * @param authorities
     * @param ip
     * @return
     */
    private boolean isIPAllowed(String username, GrantedAuthority[] authorities, String host) {
        // Asegurar que el usuario NO esté en la lista de ips bloqueadas
        if (isHostInList(notAllowedIps, username, host)) {
            logger.warn("ip " + host + " not allowed for " + username);
            return false;
        }

        // Asegurar que los authorities del usuario NO estén en la lista de ips bloqueadas
        for (GrantedAuthority authority : authorities) {
            if (isHostInList(notAllowedIps, "[" + authority.getAuthority() + "]", host)) {
                logger.warn("ip " + host + " not allowed for [" + username + ":" + authority.getAuthority() + "]");
                return false;
            }

        }

        // Verificar si el usuario esté en la lista de ips permitidas
        if (isHostInList(allowedIps, username, host)) {
            return true;
        }

        // Verificar si algún authority del usuario está en la lista de ips permitidas
        for (GrantedAuthority authority : authorities) {
            if (isHostInList(allowedIps, "[" + authority.getAuthority() + "]", host)) {
                return true;
            }

        }

        logger.warn("no ip allowed for " + username);
        return false;
    }

    private boolean isHostInList(Map<String, IPList> ips, String name, String host) {
        IP userIp = IPList.getIP(host);
        for (Map.Entry<String, IPList> entry : ips.entrySet()) {
            String key = entry.getKey();
            if (PatternMatchUtils.simpleMatch(key, name)) {
                if (entry.getValue().contains(userIp)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Construye los maps de ips a filtrar 
     * 
     * @param filterIps the filterIps to set
     */
    public void setFilterIps(Properties filterIps) {
        for (Map.Entry<Object, Object> entry : filterIps.entrySet()) {
            String role = (String) entry.getKey();
            String[] ipsArray = ((String) entry.getValue()).split(",");
            for (String ipMask : ipsArray) {
                Map<String, IPList> putMap = null;
                if (ipMask.startsWith("!")) {
                    ipMask = ipMask.substring(1);
                    putMap = notAllowedIps;
                } else {
                    putMap = allowedIps;
                }
                IPList putList = putMap.get(role);
                if (putList == null) {
                    putList = new IPList();
                    putMap.put(role, putList);
                }
                putList.add(ipMask.trim());
            }
        }
    }

}
