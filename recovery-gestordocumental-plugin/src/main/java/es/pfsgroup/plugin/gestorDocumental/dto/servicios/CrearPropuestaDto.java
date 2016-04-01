package es.pfsgroup.plugin.gestorDocumental.dto.servicios;

import es.pfsgroup.plugin.gestorDocumental.model.servicios.PropuestaMetadatos;

public class CrearPropuestaDto {

	/**
	 * Login del usuario que llama al servicio
	 */
	private String usuario;
	
	/**
	 * Password del usuario
	 */
	private String password;
	
	/**
	 * Clase de expediente inmobiliario (Suelo, obra en curso, obra terminada…)
	 */
	private Integer codClase;
	
	/**
	 * Descripción del expediente
	 */
	private String descripcionExpediente;

	/**
	 * Objeto constituido por los metadatos para un expediente de propuestas
	 */
	private PropuestaMetadatos propuestaMetadatos;
	

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

	public Integer getCodClase() {
		return codClase;
	}

	public void setCodClase(Integer codClase) {
		this.codClase = codClase;
	}

	public String getDescripcionExpediente() {
		return descripcionExpediente;
	}

	public void setDescripcionExpediente(String descripcionExpediente) {
		this.descripcionExpediente = descripcionExpediente;
	}

	public PropuestaMetadatos getPropuestaMetadatos() {
		return propuestaMetadatos;
	}
	
	public void setPropuestaMetadatos(PropuestaMetadatos propuestaMetadatos) {
		this.propuestaMetadatos = propuestaMetadatos;
	}
}