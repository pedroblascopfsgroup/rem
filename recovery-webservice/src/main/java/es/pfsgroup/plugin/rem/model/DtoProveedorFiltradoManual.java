package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para Proveedores utilizado en Trabajo para filtrar manualmente desde
 * combobox - filtradoEspecial.
 * 
 * El filtrado manual requiere del envío del nombre del proveedor siempre como 'nombre'
 * para evitar conflictos entre los campos 'nombre' y 'nombreComercial'
 * 
 * @author Alberto Flores
 */
public class DtoProveedorFiltradoManual extends WebDto {
	private static final long serialVersionUID = 0L;

	private Long idProveedor;
	private String nombre;
	
	
	public Long getIdProveedor() {
		return idProveedor;
	}
	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
}