package es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.dto;

import java.io.Serializable;

import es.capgemini.devon.pagination.PaginationParamsImpl;


public class SociedadProcuradoresDto extends PaginationParamsImpl implements Serializable {

	private static final long serialVersionUID = 2981071737733535390L;
	

	private Long id;
	private String nombre;
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	
}