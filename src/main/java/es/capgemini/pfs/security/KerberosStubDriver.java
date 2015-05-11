package es.capgemini.pfs.security;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.jamonapi.utils.Logger;

/**
 * Clase Stub que servir� para simular los posibles casos que se pueden dar al
 * recuperar los perfiles de Bankia desde el LDAP
 * 
 * @author pedro
 * 
 */
public class KerberosStubDriver implements KerberosDriver {

	// Perfiles LDAP contemplados
	public String PERF_ACCESO = "FPFSRACCESO";
	public String PERF_SOPORTE = "FPFSRSOPORT";
	public String PERF_ADMIN = "FPFSRADMIN";
	public String PERF_INTERNO = "FPFSRINT";
	public String PERF_EXTERNO = "FPFSREXT";
	
	// Usuarios de pruebas contemplados
	private String U_SUPER = "BANKMASTER";
	private String U_EXTERNO = "AGE1";
	private String U_EXTERNO2 = "AGE1bis";
	private String U_GRUPO = "GRPAGE1";
	private String U_INTERNO = "PEPE";
	private String U_OTRO = "123";

	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public List<String> obtenerListaAutorizaciones(String username) {

		List<String> listaAutorizaciones = new ArrayList<String>();
		
		if (username.equalsIgnoreCase(U_SUPER)) {
			listaAutorizaciones.add(PERF_ACCESO);
			listaAutorizaciones.add(PERF_ADMIN);
			listaAutorizaciones.add(PERF_INTERNO);
		} else if (username.equalsIgnoreCase(U_EXTERNO) || username.equalsIgnoreCase(U_EXTERNO2) || username.equalsIgnoreCase(U_GRUPO)) {
			listaAutorizaciones.add(PERF_ACCESO);
			listaAutorizaciones.add(PERF_EXTERNO);
		} else if (username.equalsIgnoreCase(U_INTERNO)) {
			listaAutorizaciones.add(PERF_ACCESO);
			listaAutorizaciones.add(PERF_INTERNO);
		} else if (username.equalsIgnoreCase(U_OTRO)) {
			listaAutorizaciones.add(PERF_SOPORTE);
			//NO DEBE PASAR PORQUE NO TIENE EL PERFIL ACCESO
		} else {
			listaAutorizaciones = null;
			logger.info("Usuario " + username + " no tiene autorizaciones.");
		}
		return listaAutorizaciones;
		
	}

	@Override
	public String obtenerUsername(String username, HttpServletRequest request) {

		System.out.println("[KerberosStubDriver:obtenerUsername] " + username);
		return username;
		
	}

	@Override
	public boolean pwCorrecta(String username, String password) {
		return true;
	}
	
}
