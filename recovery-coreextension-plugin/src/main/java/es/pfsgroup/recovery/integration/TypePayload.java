package es.pfsgroup.recovery.integration;

import com.fasterxml.jackson.annotation.JsonTypeInfo;

@JsonTypeInfo(use = JsonTypeInfo.Id.CLASS, include = JsonTypeInfo.As.PROPERTY, property = "@class")
public class TypePayload {

	public final static String HEADER_MSG_ENTIDAD = "rec-msg-entity";
	public final static String HEADER_MSG_TYPE = "rec-msg-type";
	public final static String HEADER_MSG_DESC = "rec-msg-desc";
	
	/**
	 * Campo más importante, tipo de mensaje
	 */
	private final String tipo;
	private final String entidad;
	private String descripcion;

	public TypePayload(String tipo, String entidad) {
		this.tipo = tipo;
		this.entidad = entidad;
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

}
