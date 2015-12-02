package es.pfsgroup.recovery.integration;

import com.fasterxml.jackson.annotation.JsonTypeInfo;

import es.capgemini.devon.security.SecurityUtils;

@JsonTypeInfo(use = JsonTypeInfo.Id.CLASS, include = JsonTypeInfo.As.PROPERTY, property = "@class")
public class TypePayload {

	public final static String HEADER_MSG_ENTIDAD = "rec-msg-entity";
	public final static String HEADER_MSG_TYPE = "rec-msg-type";
	public final static String HEADER_MSG_GROUP = "rec-msg-grp";
	
	/**
	 * Campo más importante, tipo de mensaje
	 */
	private final String tipo;
	private final String entidad;
	private String descripcion;
	private final String username;

	public TypePayload(String tipo, String entidad) {
		this.tipo = tipo;
		this.entidad = entidad;

		// Usuario
		this.username  = (SecurityUtils.getCurrentUser() != null) 
			? SecurityUtils.getCurrentUser().getUsername() 
			: "NO_USER"; 
	}

	public String getTipo() {
		return tipo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getEntidad() {
		return entidad;
	}

	public String getUsername() {
		return username;
	}

}
