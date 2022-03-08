package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para los testigos opcionales de informe comercial del activo.
 *
 */
public class DtoTestigosOpcionales {
	private Long id;
	private String fuenteTestigos;
	private Float eurosPorMetro;
	private Float precioMercado;
	private Float superficie;
	private String tipoActivo;
	private String enlace;
	private String direccion;
	private Float lat;
	private Float lng;
	private Date fechaTransaccionPublicacion;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getFuenteTestigos() {
		return fuenteTestigos;
	}
	public void setFuenteTestigos(String fuenteTestigos) {
		this.fuenteTestigos = fuenteTestigos;
	}
	public Float getEurosPorMetro() {
		return eurosPorMetro;
	}
	public void setEurosPorMetro(Float eurosPorMetro) {
		this.eurosPorMetro = eurosPorMetro;
	}
	public Float getPrecioMercado() {
		return precioMercado;
	}
	public void setPrecioMercado(Float precioMercado) {
		this.precioMercado = precioMercado;
	}
	public Float getSuperficie() {
		return superficie;
	}
	public void setSuperficie(Float superficie) {
		this.superficie = superficie;
	}
	public String getTipoActivo() {
		return tipoActivo;
	}
	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
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
	public Float getLat() {
		return lat;
	}
	public void setLat(Float lat) {
		this.lat = lat;
	}
	public Float getLng() {
		return lng;
	}
	public void setLng(Float lng) {
		this.lng = lng;
	}
	public Date getFechaTransaccionPublicacion() {
		return fechaTransaccionPublicacion;
	}
	public void setFechaTransaccionPublicacion(Date fechaTransaccionPublicacion) {
		this.fechaTransaccionPublicacion = fechaTransaccionPublicacion;
	}	
}