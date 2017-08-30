package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

public class ActivoPropagacionDto implements Serializable {

	private static final long serialVersionUID = 2868343014328376753L;

	private Long id;
	private Long numActivo;
	private String descripcion;

	// subdivision / agrupacion 
	private String parentesco;

	public ActivoPropagacionDto(String parentesco) {
		this.parentesco = parentesco;
	}

	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getParentesco() {
		return parentesco;
	}
	public void setParentesco(String parentesco) {
		this.parentesco = parentesco;
	}
}
