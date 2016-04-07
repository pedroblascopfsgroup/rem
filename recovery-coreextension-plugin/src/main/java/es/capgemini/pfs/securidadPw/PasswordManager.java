package es.capgemini.pfs.securidadPw;

import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.Authentication;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.providers.ldap.LdapAuthenticationProvider;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.core.api.seguridadPw.PasswordApi;
import es.capgemini.pfs.security.KerberosDriver;
import es.capgemini.pfs.users.domain.Usuario;

@Component
public class PasswordManager implements PasswordApi {

	private final Log logger = LogFactory.getLog(getClass());
	
	private static final String DRIVER_KERBEROS = "autorizacion.kerberos.driver";
	private static final String DRIVER_BANKIA = "es.pfs.bankia.security.KerberosBankiaDriver";

	private String classNameDriver = "es.capgemini.pfs.security.KerberosStubDriver";

	@Resource
	private Properties appProperties;
	
	@Autowired(required = false)
	private LdapAuthenticationProvider ldapAuthenticationProvider;

	private KerberosDriver driver;
	private boolean driverBuscado = false;
	
	/**
	 * 
	 * Comprueba si la contrase�a es correcta, teniendo en cuenta el posible caso de que 
	 * caso de que la clase driver de Bankia est� presente habr� que hacer uso de su funci�n correspondiente.
	 * 
	 * @author pedro 
	 * 
	 * @param Usuario usuario
	 * @param password contrae�a a comprobar
	 * @return boolean
	 */
	@Override
	@BusinessOperation(BO_EXT_PASSWORD_MGR_CONTRASENA_CORRECTA)
	public boolean isPwCorrect(Usuario usuario, String password) {
		
		obtenerDriver();
		
		if (driver == null) {
			return checkPwNoDriver(usuario, password);
		} else {
			return (driver.pwCorrecta(usuario.getUsername(), password));
		}
	}
	
	private boolean checkPwNoDriver(Usuario usuario, final String password) {
		final UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(usuario.getUsername(), password);

		//try ldap authentication
		if (ldapAuthenticationProvider != null) {
			try {
				final Authentication authentication = ldapAuthenticationProvider.authenticate(auth);
				return authentication.isAuthenticated();
			} catch (Exception e) {
				logger.error(e.getMessage());
			}
		}

		//db authentication
		return password.equals(usuario.getPassword());
	}

	private void obtenerDriver() {

		// Recuperar el driver de Kerberos Bankia (si existe)
		if (driver == null && !driverBuscado) {
			if (appProperties.containsKey(DRIVER_KERBEROS)) {
				classNameDriver = appProperties.getProperty(DRIVER_KERBEROS);
			}
			if (classNameDriver.equals(DRIVER_BANKIA)) {
				try {
					driver = (KerberosDriver) (Class.forName(classNameDriver)
							.newInstance());
				} catch (InstantiationException e) {
					//e.printStackTrace();
				} catch (IllegalAccessException e) {
					//e.printStackTrace();
				} catch (ClassNotFoundException e) {
					//e.printStackTrace();
				}
			}
			driverBuscado = true;
		}

	}

}

	
