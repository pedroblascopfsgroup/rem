package es.pfsgroup.plugin.gestorDocumental.dto.servicios;


public class CrearActuacionTecnicaDto {

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
	 * Tipo de trabajo
	 */
	private String tipoClase;
	
	/**
	 * Clase de trabajo 
	 */
	private String codClase;
	
	/**
	 * Descripción de la actuacion técnica
	 */
	private String descripcionActuacion;

	/**
	 * Objeto constituido por los metadatos para una actuación técnica
	 */
	private String operacionMetadatos;
	

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

	public String getCodClase() {
		return codClase;
	}
	
	public void setCodClase(String codClase) {
		this.codClase = codClase;
	}

	public String getDescripcionActuacion() {
		return descripcionActuacion;
	}

	public void setDescripcionActuacion(String descripcionActuacion) {
		this.descripcionActuacion = descripcionActuacion;
	}

	public String getOperacionMetadatos() {
		return operacionMetadatos;
	}

	public void setOperacionMetadatos(String operacionMetadatos) {
		this.operacionMetadatos = operacionMetadatos;
	}
	
	
}