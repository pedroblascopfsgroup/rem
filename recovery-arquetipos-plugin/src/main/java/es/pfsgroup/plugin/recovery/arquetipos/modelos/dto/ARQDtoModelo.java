package es.pfsgroup.plugin.recovery.arquetipos.modelos.dto;

import es.capgemini.devon.dto.WebDto;

public class ARQDtoModelo extends WebDto{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -8708311959197256033L;

	private Long id;
	
	private String descripcion;
	
	private String nombre;
	
	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNombre() {
		return nombre;
	}

}
