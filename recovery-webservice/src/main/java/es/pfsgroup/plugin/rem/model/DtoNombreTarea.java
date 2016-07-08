package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para mostrar los nombres de las tareas
 * @author Daniel Gutiérrez
 *
 */
public class DtoNombreTarea extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
	
	private String descripcion;
	
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
}