package es.pfsgroup.plugin.rem.model;

/**
 * Dto para los testigos de oferta.
 *
 */
public class DtoTestigos {
	
	private String id;
	private String fuenteTestigosDesc;
	private String eurosMetro;
	private Double precioMercado;
	private Double superficie;
	private String tipoActivoDesc;
	private String enlace;
	private String direccion;
		
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getFuenteTestigosDesc() {
		return fuenteTestigosDesc;
	}
	public void setFuenteTestigosDesc(String fuenteTestigosDesc) {
		this.fuenteTestigosDesc = fuenteTestigosDesc;
	}
	public String getEurosMetro() {
		return eurosMetro;
	}
	public void setEurosMetro(String eurosMetro) {
		this.eurosMetro = eurosMetro;
	}
	public Double getPrecioMercado() {
		return precioMercado;
	}
	public void setPrecioMercado(Double precioMercado) {
		this.precioMercado = precioMercado;
	}
	public Double getSuperficie() {
		return superficie;
	}
	public void setSuperficie(Double superficie) {
		this.superficie = superficie;
	}
	public String getTipoActivoDesc() {
		return tipoActivoDesc;
	}
	public void setTipoActivoDesc(String tipoActivoDesc) {
		this.tipoActivoDesc = tipoActivoDesc;
	}
	public String getEnlace() {
		return enlace;
	}
	public void setEnlace(String enlace) {
		this.enlace = enlace;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	
}