package es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado.dto;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.devon.dto.WebDto;

public class JUZDtoAltaJuzgado extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -30911386345756660L;
	
	private Long id;
	
	@NotNull(message ="plugin.plazaxJuzgados.noNulo.descripcion")
	@NotEmpty(message ="plugin.plazaxJuzgados.noNulo.descripcion")
	private String descripcion;
	
	private String descripcionLarga;
	
	private String plaza;
	
	private Boolean existePlaza;
	
	private String descripcionPlaza;
	
	private String descripcionLargaPlaza;
	
	
	
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
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	public void setPlaza(String plaza) {
		this.plaza = plaza;
	}
	public String getPlaza() {
		return plaza;
	}
	
	public void setExistePlaza(Boolean existePlaza) {
		this.existePlaza = existePlaza;
	}
	public Boolean getExistePlaza() {
		return existePlaza;
	}
	public void setDescripcionPlaza(String descripcionPlaza) {
		this.descripcionPlaza = descripcionPlaza;
	}
	public String getDescripcionPlaza() {
		return descripcionPlaza;
	}
	public void setDescripcionLargaPlaza(String descripcionLargaPlaza) {
		this.descripcionLargaPlaza = descripcionLargaPlaza;
	}
	public String getDescripcionLargaPlaza() {
		return descripcionLargaPlaza;
	}

}
