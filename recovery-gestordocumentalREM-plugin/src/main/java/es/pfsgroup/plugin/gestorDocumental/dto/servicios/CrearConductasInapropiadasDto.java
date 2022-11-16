package es.pfsgroup.plugin.gestorDocumental.dto.servicios;


public class CrearConductasInapropiadasDto {

	/**
	 * Login del usuario que llama al servicio
	 */
	private String usuario;
	
	/**
	 * Password del usuario
	 */
	private String password;
	
	/**
	 * Usuario operacional
	 */
	private String usuarioOperacional;
	/**
	 * Tipo de proveedor
	 */
	private String tipoClase;
	
	/**
	 * Descripción del proveedor
	 */
	private String descripcionConductasInapropiadas;

	/**
	 * Objeto constituido por los metadatos para un proveedor
	 */
	private String metadata;
	
	private String metadataExtended;
	

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

	public String getTipoClase() {
		return tipoClase;
	}

	public void setTipoClase(String tipoClase) {
		this.tipoClase = tipoClase;
	}

	public String getDescripcionConductasInapropiadas() {
		return descripcionConductasInapropiadas;
	}

	public void setDescripcionConductasInapropiadas(String descripcionConductasInapropiadas) {
		this.descripcionConductasInapropiadas = descripcionConductasInapropiadas;
	}

	public String getMetadata() {
		return metadata;
	}

	public void setMetadata(String metadata) {
		this.metadata = metadata;
	}
	
	public String getMetadataExtended() {
		return metadataExtended;
	}

	public void setMetadataExtended(String metadataExtended) {
		this.metadataExtended = metadataExtended;
	}
	
	
}