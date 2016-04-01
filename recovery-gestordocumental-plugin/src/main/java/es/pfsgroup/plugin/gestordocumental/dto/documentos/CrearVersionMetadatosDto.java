package es.pfsgroup.plugin.gestordocumental.dto.documentos;

import java.io.File;

public class CrearVersionMetadatosDto {
	
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

	/**
	 * Objeto constituido por los metadatos generales del documento
	 */
	private String generalDocumentoModif;
	
	/**
	 * Objeto constituido por los metadatos de dónde está archivado físicamente el documento
	 */
	private String archivoFisico;
	

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

	public String getGeneralDocumentoModif() {
		return generalDocumentoModif;
	}

	public void setGeneralDocumentoModif(String generalDocumentoModif) {
		this.generalDocumentoModif = generalDocumentoModif;
	}

	public String getArchivoFisico() {
		return archivoFisico;
	}

	public void setArchivoFisico(String archivoFisico) {
		this.archivoFisico = archivoFisico;
	}

}