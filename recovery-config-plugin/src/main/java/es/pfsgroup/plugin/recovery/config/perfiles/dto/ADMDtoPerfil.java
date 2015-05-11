package es.pfsgroup.plugin.recovery.config.perfiles.dto;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.devon.dto.WebDto;


public class ADMDtoPerfil extends WebDto {
	/**
	 * 
	 */
	private static final long serialVersionUID = 4181880551871721167L;

	private Long id;

	private String descripcionLarga;

	@NotNull (message = "plugin.config.perfiles.nuevo.message.descripcion.null")
	@NotEmpty (message = "plugin.config.perfiles.nuevo.message.descripcion.null")
	private String descripcion;
	
	private String funciones;

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

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

}
