package es.pfsgroup.recovery.integration;

import com.fasterxml.jackson.annotation.JsonTypeInfo;

import es.capgemini.devon.utils.DbIdContextHolder;

@JsonTypeInfo(use = JsonTypeInfo.Id.CLASS, include = JsonTypeInfo.As.PROPERTY, property = "@class")
public class TypePayload {

	public final static String HEADER_MSG_TYPE = "rec-msg-type";
	public final static String HEADER_MSG_DESC = "rec-msg-desc";
	
	/**
	 * Campo más importante, tipo de mensaje
	 */
	private final String tipo;
	private final Long entidad;
	private String descripcion;

	public TypePayload(String tipo) {
		this.tipo = tipo;
		this.entidad = DbIdContextHolder.getDbId();
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

	public Long getEntidad() {
		return entidad;
	}

}
