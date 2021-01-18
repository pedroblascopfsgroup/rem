package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona los elementos de un gasto
 *  
 * @author Lara Pablo
 */
public class DtoComboLineasDetalle extends WebDto {
	

	private static final long serialVersionUID = 1L;
	

	 private Long id;  //Id dl elemento de la gld_ent
	 
	 private Long codigo;
	 
	 private String descripcion;
	  
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getCodigo() {
		return codigo;
	}

	public void setCodigo(Long codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	
	
}
