package es.pfsgroup.plugin.rem.funciones.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoFunciones extends WebDto {

	private static final long serialVersionUID = 7419033753286720809L;

	private Long id;
	private String descripcion;
	private String decripcionLarga;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDecripcionLarga() {
		return decripcionLarga;
	}

	public void setDecripcionLarga(String decripcionLarga) {
		this.decripcionLarga = decripcionLarga;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
}
