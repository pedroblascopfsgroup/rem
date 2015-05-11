package es.capgemini.pfs.security;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

public interface KerberosDriver {

	public List<String> obtenerListaAutorizaciones(String username);

	public String obtenerUsername(String username, HttpServletRequest request);

	boolean pwCorrecta(String username, String password);
	
}
