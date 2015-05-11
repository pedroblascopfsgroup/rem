package es.pfsgroup.plugin.recovery.config.perfiles.dto;

import es.capgemini.devon.dto.WebDto;

public class ADMDtoBuscaPerfil extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1052022991810809954L;

	private Long id;
	
	private String descripcion;

	private String descripcionLarga;
	
	private String funciones;

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setFunciones(String funciones) {
		this.funciones = funciones;
	}

	public String getFunciones() {
		return funciones;
	}

}
