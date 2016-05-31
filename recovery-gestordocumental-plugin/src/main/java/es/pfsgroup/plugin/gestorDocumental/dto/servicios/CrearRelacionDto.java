package es.pfsgroup.plugin.gestorDocumental.dto.servicios;

public class CrearRelacionDto {

	/**
	 * Login del usuario que llama al servicio
	 */
	private String usuario;
	
	/**
	 * Password del usuario
	 */
	private String password;
	
	/**
	 * Tipo de expediente origen
	 */
	private String codTipoOrigen;
	
	/**
	 * Clase de expediente origen
	 */
	private String codClaseOrigen;
	
	/**
	 * Identificador interno del expediente en Haya origen
	 */
	private String idExpedienteHayaOrigen;
	
	/**
	 * Tipo de expediente destino
	 */
	private String codTipoDestino;
	
	/**
	 * Clase de expediente destino
	 */
	private String codClaseDestino;
	
	/**
	 * Identificador interno del expediente en Haya destino
	 */
	private String idExpedienteHayaDestino;

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

	public String getCodTipoOrigen() {
		return codTipoOrigen;
	}

	public void setCodTipoOrigen(String codTipoOrigen) {
		this.codTipoOrigen = codTipoOrigen;
	}

	public String getCodClaseOrigen() {
		return codClaseOrigen;
	}

	public void setCodClaseOrigen(String codClaseOrigen) {
		this.codClaseOrigen = codClaseOrigen;
	}

	public String getIdExpedienteHayaOrigen() {
		return idExpedienteHayaOrigen;
	}

	public void setIdExpedienteHayaOrigen(String idExpedienteHayaOrigen) {
		this.idExpedienteHayaOrigen = idExpedienteHayaOrigen;
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

	public String getIdExpedienteHayaDestino() {
		return idExpedienteHayaDestino;
	}

	public void setIdExpedienteHayaDestino(String idExpedienteHayaDestino) {
		this.idExpedienteHayaDestino = idExpedienteHayaDestino;
	}

}