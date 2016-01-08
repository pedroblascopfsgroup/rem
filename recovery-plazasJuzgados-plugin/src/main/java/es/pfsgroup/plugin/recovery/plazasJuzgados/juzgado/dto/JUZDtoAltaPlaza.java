package es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado.dto;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.devon.dto.WebDto;

public class JUZDtoAltaPlaza extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8153918952327927257L;
	
	private Long id;
	
	@NotNull(message ="plugin.plazasJuzgados.noNulo.codigo")
	@NotEmpty(message ="plugin.plazasJuzgados.noNulo.codigo")
	private String codigo;
	@NotNull(message ="plugin.plazaxJuzgados.noNulo.descripcion")
	@NotEmpty(message ="plugin.plazaxJuzgados.noNulo.descripcion")
	private String descripcion;
	private String descripcionLarga;
	
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getId() {
		return id;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getCodigo() {
		return codigo;
	}

}
