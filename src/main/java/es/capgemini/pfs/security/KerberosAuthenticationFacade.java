package es.capgemini.pfs.security;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.AuthenticationException;
import org.springframework.security.BadCredentialsException;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.autenticacionLog.AuthenticationLogApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

@Service
public class KerberosAuthenticationFacade {

	private static final String DRIVER_KERBEROS = "autorizacion.kerberos.driver";
	private static final String PERFILES_BANKIA = "autorizacion.kerberos.perfiles";
	private static final String PERFIL_ACCESO = "autorizacion.kerberos.perfil.acceso";

	private UserDetails userDetails;
	private HttpServletRequest request;

	@Resource
	private Properties appProperties;

	private final Log logger = LogFactory.getLog(getClass());

	private KerberosDriver driver;

	private String username;

	@Autowired
	private ApiProxyFactory proxyFactory;

	public String getUsername(String username, HttpServletRequest request) {

		this.username = username;

		obtenerDriver();

		if (driver == null) {
			throw new BadCredentialsException(
					"No está configurado el sistema de seguridad", null);
		} else {
			this.username = driver.obtenerUsername(username, request);
		}

		return this.username;
	}

	public void checkAuthentication(UserDetails userDetails,
			HttpServletRequest request) throws AuthenticationException {

		this.setUserDetails(userDetails);
		this.setRequest(request);

		String username = userDetails.getUsername();

		obtenerDriver();

		if (driver == null) {
			throw new BadCredentialsException(
					"No está configurado el sistema de seguridad", null);
		} else {

			// Recuperar los perfiles de Bankia que se contemplan para Recovery
			List<String> perfilesBankia = null;
			if (appProperties.containsKey(PERFILES_BANKIA)) {
				String propiedadPerfilesBankia = appProperties
						.getProperty(PERFILES_BANKIA);
				perfilesBankia = Arrays.asList(propiedadPerfilesBankia
						.split(","));
			}

			boolean ok = false;

			// Comprobar que se dispone de la autorización de acceso a Recovery
			// Y al menos de una más
			String perfilAcceso = "FPFSRACCESO";
			if (appProperties.containsKey(PERFIL_ACCESO)) {
				perfilAcceso = appProperties.getProperty(PERFIL_ACCESO);
			}

			// Comprobar que alguna de las autorizaciones LDAP del usuario se
			// corresponde con las de Recovery
			if (perfilesBankia != null && !perfilesBankia.isEmpty()) {
				List<String> autorizaciones = driver
						.obtenerListaAutorizaciones(username);
				if (autorizaciones != null && autorizaciones.size() > 0) {
					logger.info("checkAuthentication: " + autorizaciones.toString());
					if (autorizaciones.contains(perfilAcceso)) {
						for (String aut : autorizaciones) {
							if (perfilesBankia.contains(aut)) {
								ok = true;
								break;
							}
						}
					}
				}
			} else {
				logger.error("checkAuthentication: Mal configurado fichero de propiedades.");
			}

			String remoteIP = request.getRemoteAddr();
			//obtener IP del servidor
			String ipHost = "127.0.0.1";
			try {
				ipHost = InetAddress.getByName(request.getServerName()).getHostAddress();
			} catch (UnknownHostException e) {
				logger.error("checkAuthentication: error al obtener la IP del servidor.");
			} 
			if (!ok) {
				proxyFactory.proxy(AuthenticationLogApi.class).registrarLoginError(ipHost, remoteIP, username);
				logger.error("checkAuthentication: El usuario " + username + " no tiene los perfiles necesarios en el LDAP.");
				throw new BadCredentialsException("El usuario no tiene los perfiles necesarios en el LDAP", null);
			} else {
				proxyFactory.proxy(AuthenticationLogApi.class).registrarLogin(ipHost, remoteIP, username);				
			}

		}

	}

	public UserDetails getUserDetails() {
		return userDetails;
	}

	public void setUserDetails(UserDetails userDetails) {
		this.userDetails = userDetails;
	}

	public HttpServletRequest getRequest() {
		return request;
	}

	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}

	public KerberosDriver getDriver() {
		return driver;
	}

	public void setDriver(KerberosDriver driver) {
		this.driver = driver;
	}

	private void obtenerDriver() {

		String classNameDriver = "es.capgemini.pfs.security.KerberosStubDriver";

		// Recuperar las autorizaciones de Bankia (o del Stub)
		if (driver == null) {
			if (appProperties.containsKey(DRIVER_KERBEROS)) {
				classNameDriver = appProperties.getProperty(DRIVER_KERBEROS);
			}
			try {
				driver = (KerberosDriver) (Class.forName(classNameDriver)
						.newInstance());
			} catch (InstantiationException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
		}

	}

}
