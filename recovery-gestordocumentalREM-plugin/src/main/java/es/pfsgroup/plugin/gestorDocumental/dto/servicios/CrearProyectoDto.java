package es.pfsgroup.plugin.gestorDocumental.dto.servicios;


public class CrearProyectoDto {

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
	private String proyectoMetadatos;
	
	private String proyectoDescripcion;

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

	public String getProyectoMetadatos() {
		return proyectoMetadatos;
	}

	public void setProyectoMetadatos(String proyectoMetadatos) {
		this.proyectoMetadatos = proyectoMetadatos;
	}

	public String getProyectoDescripcion() {
		return proyectoDescripcion;
	}

	public void setProyectoDescripcion(String proyectoDescripcion) {
		this.proyectoDescripcion = proyectoDescripcion;
	}

	


	
}