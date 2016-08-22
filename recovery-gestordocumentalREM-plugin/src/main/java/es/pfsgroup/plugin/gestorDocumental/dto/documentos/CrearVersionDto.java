package es.pfsgroup.plugin.gestorDocumental.dto.documentos;

import java.io.File;

public class CrearVersionDto {

	/**
	 * Login del usuario que llama al servicio
	 */
	private String usuario;
	/**
	 * Password del usuario
	 */
	private String password;
	
	/**
	 * Login del usuario que identifica al usuario en la aplicación externa (control de auditorías)
	 */
	private String usuarioOperacional;

	/**
	 * El fichero que se añadirá como nueva versión
	 */
	private File documento;

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	
	public String getUsuarioOperacional() {
		return usuarioOperacional;
	}
	
	public void setUsuarioOperacional(String usuarioOperacional) {
		this.usuarioOperacional = usuarioOperacional;
	}

	public File getDocumento() {
		return documento;
	}

	public void setDocumento(File documento) {
		this.documento = documento;
	}

}