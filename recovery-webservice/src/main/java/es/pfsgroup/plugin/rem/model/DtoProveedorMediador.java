package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;
import java.util.Date;


public class DtoProveedorMediador extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long idProveedor;
	private String nombre;
	private String nombreComercial;
	private Long codigo;
	private String estadoProveedorDescripcion;
	private String descripcionTipoProveedor;
	
	public Long getId() {
		return idProveedor;
	}
	public void setId(Long idProveedor) {
		this.idProveedor = idProveedor;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getEstadoProveedorDescripcion() {
		return estadoProveedorDescripcion;
	}
	public void setEstadoProveedorDescripcion(String estadoProveedorDescripcion) {
		this.estadoProveedorDescripcion = estadoProveedorDescripcion;
	}
	public String getDescripcionTipoProveedor() {
		return descripcionTipoProveedor;
	}
	public void setDescripcionTipoProveedor(String descripcionTipoProveedor) {
		this.descripcionTipoProveedor = descripcionTipoProveedor;
	}
	public Long getCodigo() {
		return codigo;
	}
	public void setCodigo(Long codigo) {
		this.codigo = codigo;
	}
	public String getNombreComercial() {
		return nombreComercial;
	}
	public void setNombreComercial(String nombreComercial) {
		this.nombreComercial = nombreComercial;
	}
	
}