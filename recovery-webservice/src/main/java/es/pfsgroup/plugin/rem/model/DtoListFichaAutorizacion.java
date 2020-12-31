package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoListFichaAutorizacion extends WebDto{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5049451515981642378L;
	
	Long idActivo;
	String finca;
	String regPropiedad;
	String localidadRegProp;
	Double precioVenta;
	String direccion;
	String localidad;
	String provincia;
	String condicionesVenta;
	
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getFinca() {
		return finca;
	}
	public void setFinca(String finca) {
		this.finca = finca;
	}
	public String getRegPropiedad() {
		return regPropiedad;
	}
	public void setRegPropiedad(String regPropiedad) {
		this.regPropiedad = regPropiedad;
	}
	public String getLocalidadRegProp() {
		return localidadRegProp;
	}
	public void setLocalidadRegProp(String localidadRegProp) {
		this.localidadRegProp = localidadRegProp;
	}
	public Double getPrecioVenta() {
		return precioVenta;
	}
	public void setPrecioVenta(Double precioVenta) {
		this.precioVenta = precioVenta;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getLocalidad() {
		return localidad;
	}
	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}
	public String getProvincia() {
		return provincia;
	}
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	public String getCondicionesVenta() {
		return condicionesVenta;
	}
	public void setCondicionesVenta(String condicionesVenta) {
		this.condicionesVenta = condicionesVenta;
	}

}
