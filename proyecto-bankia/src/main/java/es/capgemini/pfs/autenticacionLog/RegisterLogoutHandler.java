package es.capgemini.pfs.autenticacionLog;

import java.net.InetAddress;
import java.net.UnknownHostException;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.Authentication;
import org.springframework.security.ui.logout.LogoutHandler;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Component("myLogoutHandler")
public class RegisterLogoutHandler implements LogoutHandler {

	private static final String X_FORWARDED_FOR_2 = "HTTP_X_FORWARDED_FOR";

	private static final String X_FORWARDED_FOR_1 = "X-Forwarded-For";

	private final Log logger = LogFactory.getLog(getClass());

    @Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	public void logout(HttpServletRequest request,
			HttpServletResponse response, Authentication authentication) {

    	String remoteIP = obtenerIPCliente(request);
    	String username = "DUMMY";
    	if (request != null && request.getRemoteUser() != null) {
    		username = request.getRemoteUser();
    	} else if (authentication != null && authentication.getName() != null) {
    		username = authentication.getName();
    	}
		//obtener IP del servidor
		String ipHost = "127.0.0.1";
		try {
			ipHost = InetAddress.getByName(request.getServerName()).getHostAddress();
		} catch (UnknownHostException e) {
			logger.error("RegisterLogoutHandler.logout: error al obtener la IP del servidor.");
		} 
		proxyFactory.proxy(AuthenticationLogApi.class).registrarLogout(ipHost, remoteIP, username);
		
//		try {
//			response.sendRedirect("/endauth");
//		} catch (IOException e) {
//			logger.info("RegisterLogoutHandler.logout: error al redigir a /endauth: "  + e.getMessage());
//		}
		
//		try {
//			ValidarUsuarioLDAP validar = new ValidarUsuarioLDAP();
//			validar.desconectar();
//		} catch (ValidarUsuarioLDAPException e) {
//			logger.info("RegisterLogoutHandler.logout: error al desconectar de LDAP. " + e.getCodigoError() + " - " + e.getDescripcionError());
//		}

		eraseCookies(request, response);

		//Reforzar la invalidaci�n de sesi�n
		request.getSession().invalidate();
		if (request.getSession(false) == null) {
			logger.info("RegisterLogoutHandler.logout: sesion nula.");
		}
		//authentication.setAuthenticated(false);

	}
	
	private void eraseCookies(HttpServletRequest req, HttpServletResponse resp) {
	    Cookie[] cookies = req.getCookies();
	    if (cookies != null)
	        for (int i = 0; i < cookies.length; i++) {
        		//logger.info("RegisterLogoutHandler.logout: " + cookies[i].getName() + "=" + cookies[i].getPath() + "=" + cookies[i].getValue());
	        	if (cookies[i].getName().startsWith("JSESSIONID")) {
		            cookies[i].setValue("");
		            cookies[i].setPath("/");
		            cookies[i].setMaxAge(0);
		            resp.addCookie(cookies[i]);
	        	}
	        }
	}

	private String obtenerIPCliente(HttpServletRequest request) {
		
		//logger.error("obtenerIPCliente: " + request.getHeader(X_FORWARDED_FOR_1) + "-"+ request.getHeader(X_FORWARDED_FOR_2) + "-"+ request.getRemoteAddr() );
		String ipAddress = request.getHeader(X_FORWARDED_FOR_1);
		if (ipAddress == null) {
			ipAddress = request.getHeader(X_FORWARDED_FOR_2);
		}
		if (ipAddress == null) {
			ipAddress = request.getRemoteAddr();
		}
		return ipAddress;
		
	}

}
