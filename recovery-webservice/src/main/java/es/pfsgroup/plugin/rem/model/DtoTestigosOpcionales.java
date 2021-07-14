package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para los testigos opcionales de informe comercial del activo.
 *
 */
public class DtoTestigosOpcionales {
	private Long id;
	private String informesMediadores;
	private String fuenteTestigos;
	private Float precio;
	private Float precioMercado;
	private Float superficie;
	private String tipoActivo;
	private String link;
	private String direccion;
	private String idTestigoSF;
	private String nombre;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getInformesMediadores() {
		return informesMediadores;
	}
	public void setInformesMediadores(String informesMediadores) {
		this.informesMediadores = informesMediadores;
	}
	public String getFuenteTestigos() {
		return fuenteTestigos;
	}
	public void setFuenteTestigos(String fuenteTestigos) {
		this.fuenteTestigos = fuenteTestigos;
	}
	public Float getPrecio() {
		return precio;
	}
	public void setPrecio(Float precio) {
		this.precio = precio;
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
	public String getLink() {
		return link;
	}
	public void setLink(String link) {
		this.link = link;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getIdTestigoSF() {
		return idTestigoSF;
	}
	public void setIdTestigoSF(String idTestigoSF) {
		this.idTestigoSF = idTestigoSF;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	
}