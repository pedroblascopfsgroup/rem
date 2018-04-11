package es.pfsgroup.plugin.gestorDocumental.dto.documentos;

public class CrearRelacionExpedienteDto {

	/**
	 * Login del usuario que llama al servicio
	 */
	private String usuario;
	
	/**
	 * Password del usuario
	 */
	private String password;
	
	/**
	 * Usuario operacional que realiza la petición
	 */
	private String usuarioOperacional;
	
	/**
	 * Tipo de relacion del con el expediente
	 */
	private String tipoRelacion;
	
	/**
	 * Identificador opentext del documento
	 */
	private String idOpentext;
	
	/**
	 * Tipo de expediente destino
	 */
	private String codTipoDestino;
	
	/**
	 * Clase de expediente destino
	 */
	private String codClaseDestino;
	
	/**
	 * Identificador del activo
	 */
	private String idActivo;
	
	/**
	 * Operacion
	 */
	private String operacion;


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

	public String getTipoRelacion() {
		return tipoRelacion;
	}

	public void setTipoRelacion(String tipoRelacion) {
		this.tipoRelacion = tipoRelacion;
	}

	public String getIdOpentext() {
		return idOpentext;
	}

	public void setIdOpentext(String idOpentext) {
		this.idOpentext = idOpentext;
	}

	public String getCodTipoDestino() {
		return codTipoDestino;
	}

	public void setCodTipoDestino(String codTipoDestino) {
		this.codTipoDestino = codTipoDestino;
	}

	public String getCodClaseDestino() {
		return codClaseDestino;
	}

	public void setCodClaseDestino(String codClaseDestino) {
		this.codClaseDestino = codClaseDestino;
	}

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}

	public String getOperacion() {
		return operacion;
	}

	public void setOperacion(String operacion) {
		this.operacion = operacion;
	}

}