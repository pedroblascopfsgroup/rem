package es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dto;

import es.capgemini.devon.dto.WebDto;

public class MEJEditaAdjuntoDto extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1728254575616133265L;
	
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
