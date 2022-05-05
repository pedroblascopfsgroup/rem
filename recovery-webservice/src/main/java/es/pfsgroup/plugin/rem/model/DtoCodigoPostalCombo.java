package es.pfsgroup.plugin.rem.model;


import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de Datos de Contacto > Direcciones y delegaciones de la ficha proveedor.
 */
public class DtoCodigoPostalCombo extends WebDto {
	private static final long serialVersionUID = 0L;

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