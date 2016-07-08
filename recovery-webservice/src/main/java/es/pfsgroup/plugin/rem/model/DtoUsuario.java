package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para mostrar usuarios
 * @author Daniel Gutiérrez
 *
 */
public class DtoUsuario extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
	
	private String apellidoNombre;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getApellidoNombre() {
		return apellidoNombre;
	}
	
	public void setApellidoNombre(String apellidoNombre) {
		this.apellidoNombre = apellidoNombre;
	}
}