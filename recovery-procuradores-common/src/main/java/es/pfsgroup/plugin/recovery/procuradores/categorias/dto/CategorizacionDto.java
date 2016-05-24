package es.pfsgroup.plugin.recovery.procuradores.categorias.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;

public class CategorizacionDto extends PaginationParamsImpl{

	private static final long serialVersionUID = 5024403828495375230L;

	private String nombre;
	private Long id;
	private Long idDespExt;
	private Boolean	permitirBorrar;
	private String codigo;
	
	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdDespExt() {
		return idDespExt;
	}

	public void setIdDespExt(Long idDespExt) {
		this.idDespExt = idDespExt;
	}
	
	public Boolean getPermitirBorrar() {
		return permitirBorrar;
	}

	public void setPermitirBorrar(Boolean permitirBorrar) {
		this.permitirBorrar = permitirBorrar;
	}
	
	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}


}
