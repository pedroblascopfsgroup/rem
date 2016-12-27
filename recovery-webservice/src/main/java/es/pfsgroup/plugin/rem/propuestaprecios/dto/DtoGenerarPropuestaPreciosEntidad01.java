package es.pfsgroup.plugin.rem.propuestaprecios.dto;

import java.util.Date;

public class DtoGenerarPropuestaPreciosEntidad01 extends DtoGenerarPropuestaPrecios {
	
	private String numActivoUvem;
	private String codigoPostal;
	private Double valorAdquisicion = (double) 0.0;
	private Double precioAutorizado = (double) 0.0;
	private Date fechaAutorizado;
	private Double valorVentaWeb = (double) 0.0;
	private Date fechaVentaWeb;
	private Double precioEventoAutorizado = (double) 0.0;
	private Date fechaInicioEventoAutorizado;
	private Date fechaFinEventoAutorizado;
	private Double precioEventoWeb = (double) 0.0;
	private Date fechaInicioEventoWeb;
	private Date fechaFinEventoWeb;
	private Double valorRentaWeb = (double) 0.0;
	
	
	public String getNumActivoUvem() {
		return numActivoUvem;
	}
	public void setNumActivoUvem(String numActivoUvem) {
		this.numActivoUvem = numActivoUvem;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public Double getValorAdquisicion() {
		return valorAdquisicion;
	}
	public void setValorAdquisicion(Double valorAdquisicion) {
		this.valorAdquisicion = valorAdquisicion;
	}
	public Double getPrecioAutorizado() {
		return precioAutorizado;
	}
	public void setPrecioAutorizado(Double precioAutorizado) {
		this.precioAutorizado = precioAutorizado;
	}
	public Date getFechaAutorizado() {
		return fechaAutorizado;
	}
	public void setFechaAutorizado(Date fechaAutorizado) {
		this.fechaAutorizado = fechaAutorizado;
	}
	public Double getValorVentaWeb() {
		return valorVentaWeb;
	}
	public void setValorVentaWeb(Double valorVentaWeb) {
		this.valorVentaWeb = valorVentaWeb;
	}
	public Date getFechaVentaWeb() {
		return fechaVentaWeb;
	}
	public void setFechaVentaWeb(Date fechaVentaWeb) {
		this.fechaVentaWeb = fechaVentaWeb;
	}
	public Double getPrecioEventoAutorizado() {
		return precioEventoAutorizado;
	}
	public void setPrecioEventoAutorizado(Double precioEventoAutorizado) {
		this.precioEventoAutorizado = precioEventoAutorizado;
	}
	public Date getFechaInicioEventoAutorizado() {
		return fechaInicioEventoAutorizado;
	}
	public void setFechaInicioEventoAutorizado(Date fechaInicioEventoAutorizado) {
		this.fechaInicioEventoAutorizado = fechaInicioEventoAutorizado;
	}
	public Date getFechaFinEventoAutorizado() {
		return fechaFinEventoAutorizado;
	}
	public void setFechaFinEventoAutorizado(Date fechaFinEventoAutorizado) {
		this.fechaFinEventoAutorizado = fechaFinEventoAutorizado;
	}
	public Double getPrecioEventoWeb() {
		return precioEventoWeb;
	}
	public void setPrecioEventoWeb(Double precioEventoWeb) {
		this.precioEventoWeb = precioEventoWeb;
	}
	public Date getFechaInicioEventoWeb() {
		return fechaInicioEventoWeb;
	}
	public void setFechaInicioEventoWeb(Date fechaInicioEventoWeb) {
		this.fechaInicioEventoWeb = fechaInicioEventoWeb;
	}
	public Date getFechaFinEventoWeb() {
		return fechaFinEventoWeb;
	}
	public void setFechaFinEventoWeb(Date fechaFinEventoWeb) {
		this.fechaFinEventoWeb = fechaFinEventoWeb;
	}
	public Double getValorRentaWeb() {
		return valorRentaWeb;
	}
	public void setValorRentaWeb(Double valorRentaWeb) {
		this.valorRentaWeb = valorRentaWeb;
	}
	
	

}
