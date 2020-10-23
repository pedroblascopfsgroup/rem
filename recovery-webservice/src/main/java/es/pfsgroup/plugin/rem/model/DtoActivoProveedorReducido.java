package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto de Proveedores que rescata unos pocos datos para utilizarlo en un combo de la pestaña Suministros
 * o donde uno quiera pero de forma más óptima.
 */
public class DtoActivoProveedorReducido extends WebDto {
	private static final long serialVersionUID = 0L;

	private Long id;
	private String codigo;
	private String nombreProveedor;
	private String nombreComercialProveedor;
	
	
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
	public String getNombreProveedor() {
		return nombreProveedor;
	}
	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}
	public String getNombreComercialProveedor() {
		return nombreComercialProveedor;
	}
	public void setNombreComercialProveedor(String nombreComercialProveedor) {
		this.nombreComercialProveedor = nombreComercialProveedor;
	}

}