package es.pfsgroup.plugin.gestorDocumental.dto.documentos;


public class DocumentosExpedienteDto {

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
	 * Identificador que diferencia el tipo de relación (por expediente o por
	 * clases)
	 */
	private String tipoConsulta;

	/**
	 * Parámetro para indicar si se incluyen aquellos documentos que tienen la
	 * relación Expediente-Documento con el expediente introducido (El
	 * expediente tiene el código DOCUMENTO del XReference)
	 */
	private Boolean vinculoDocumento;
	
	/**
	 * Parámetro para indicar si se incluyen aquellos documentos que están en un
	 * expediente con relación Expediente-Expediente (El expediente tiene el
	 * código PROYECTO_1 o PROYECTO_2 del XReference)
	 */
	private Boolean vinculoExpediente;
	
	private String blacklistmatriculas;
	
	private Boolean metadatatdn1;
	

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

	public String getTipoConsulta() {
		return tipoConsulta;
	}

	public void setTipoConsulta(String tipoConsulta) {
		this.tipoConsulta = tipoConsulta;
	}

	public Boolean getVinculoDocumento() {
		return vinculoDocumento;
	}

	public void setVinculoDocumento(Boolean vinculoDocumento) {
		this.vinculoDocumento = vinculoDocumento;
	}
	
	public Boolean getVinculoExpediente() {
		return vinculoExpediente;
	}
	
	public void setVinculoExpediente(Boolean vinculoExpediente) {
		this.vinculoExpediente = vinculoExpediente;
	}

	public String getUsuarioOperacional() {
		return usuarioOperacional;
	}

	public void setUsuarioOperacional(String usuarioOperacional) {
		this.usuarioOperacional = usuarioOperacional;
	}

	public String getBlacklistmatriculas() {
		return blacklistmatriculas;
	}

	public void setBlacklistmatriculas(String blacklistmatriculas) {
		this.blacklistmatriculas = blacklistmatriculas;
	}

	public Boolean getMetadatatdn1() {
		return metadatatdn1;
	}

	public void setMetadatatdn1(Boolean metadatatdn1) {
		this.metadatatdn1 = metadatatdn1;
	}
	
}