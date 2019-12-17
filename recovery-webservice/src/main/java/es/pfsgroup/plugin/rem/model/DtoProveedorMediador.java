package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;
import java.util.Date;


public class DtoProveedorMediador extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long idProveedor;
	private String nombre;
	
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
	
}