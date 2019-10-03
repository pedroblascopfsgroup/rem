package es.pfsgroup.plugin.gestorDocumental.dto.servicios;


public class CrearTributoDto {

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
	 * Clase de expediente 
	 */
	private String codClase;
	
	/**
	 * Tipo de expediente 
	 */
	
	private String codTipo;
	
	/**
	 * Descripción del expediente de gasto
	 */
	private String descripcionExpediente;

	/**
	 * Objeto constituido por los metadatos para un expediente de gasto
	 */
	private String tributoMetadatos;
	
	private String tributoDescripcion;

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

	public String getCodClase() {
		return codClase;
	}
	
	public void setCodClase(String codClase) {
		this.codClase = codClase;
	}
	
	public String getCodTipo() {
		return codTipo;
	}

	public void setCodTipo(String codTipo) {
		this.codTipo = codTipo;
	}

	public String getDescripcionExpediente() {
		return descripcionExpediente;
	}

	public void setDescripcionExpediente(String descripcionExpediente) {
		this.descripcionExpediente = descripcionExpediente;
	}

	public String getTributoMetadatos() {
		return tributoMetadatos;
	}

	public void setTributoMetadatos(String tributoMetadatos) {
		this.tributoMetadatos = tributoMetadatos;
	}

	public String getTributoDescripcion() {
		return tributoDescripcion;
	}

	public void setTributoDescripcion(String tributoDescripcion) {
		this.tributoDescripcion = tributoDescripcion;
	}


	
}