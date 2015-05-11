package es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.Dto;

import es.capgemini.devon.dto.WebDto;

public class DtoNotarios extends WebDto {

	private static final long serialVersionUID = 6573433170556529971L;
	
	private Long id;

	private String codigo;  
	    
	private String descripcion;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	
}
