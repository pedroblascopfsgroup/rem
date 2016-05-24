package es.pfsgroup.plugin.recovery.procuradores.categorias.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;

public class CategoriaDto extends PaginationParamsImpl{


	private static final long serialVersionUID = -5741199826953307072L;
	
	private Long id;
	private Long idcategorizacion;
	private String nombre; 
	private String descripcion;
	private Integer orden;
	private String borrar;
	
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public Long getIdcategorizacion() {
		return idcategorizacion;
	}
	
	public void setIdcategorizacion(Long idcategorizacion) {
		this.idcategorizacion = idcategorizacion;
	}
	
	public String getNombre() {
		return nombre;
	}
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	public String getDescripcion() {
		return descripcion;
	}
	
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Integer getOrden() {
		return orden;
	}

	public void setOrden(Integer orden) {
		this.orden = orden;
	} 
	
	public String getBorrar() {
		return borrar;
	}

	public void setBorrar(String borrar) {
		this.borrar = borrar;
	}

}
