package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para Proveedores.
 * 
 * @author Jose Villel
 */
public class DtoProveedor extends WebDto {
	private static final long serialVersionUID = 0L;

	private Long idProveedor;
	private String proveedor;
	
	
	public Long getIdProveedor() {
		return idProveedor;
	}
	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}
	public String getProveedor() {
		return proveedor;
	}
	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}
	
	
	

}