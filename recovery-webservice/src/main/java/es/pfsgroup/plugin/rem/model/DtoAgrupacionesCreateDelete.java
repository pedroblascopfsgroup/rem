package es.pfsgroup.plugin.rem.model;

/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoAgrupacionesCreateDelete {

	private String id;
	private String nombre;
	private String descripcion;
	private String tipoAgrupacion;
	
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
	public String getTipoAgrupacion() {
		return tipoAgrupacion;
	}
	public void setTipoAgrupacion(String tipoAgrupacion) {
		this.tipoAgrupacion = tipoAgrupacion;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
	
	
}