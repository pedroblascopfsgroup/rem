package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de precios vigentes
 * @author Carlos Feliu
 *
 */
public class DtoPrecioVigente extends WebDto {

	private static final long serialVersionUID = 0L;


	private Long idActivo;
	private Long idPrecioVigente;
	private String codigoTipoPrecio;
	private Double importe;
	private Date fechaAprobacion;
	private Date fechaInicio;
	private Date fechaFin;
	private String observaciones;
	private Date fechaVentaHaya;
	private String liquidez;
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}	
	public Long getIdPrecioVigente() {
		return idPrecioVigente;
	}
	public void setIdPrecioVigente(Long idPrecioVigente) {
		this.idPrecioVigente = idPrecioVigente;
	}
	public String getCodigoTipoPrecio() {
		return codigoTipoPrecio;
	}
	public void setCodigoTipoPrecio(String codigoTipoPrecio) {
		this.codigoTipoPrecio = codigoTipoPrecio;
	}
	public Double getImporte() {
		return importe;
	}
	public void setImporte(Double importe) {
		this.importe = importe;
	}
	public Date getFechaAprobacion() {
		return fechaAprobacion;
	}
	public void setFechaAprobacion(Date fechaAprobacion) {
		this.fechaAprobacion = fechaAprobacion;
	}
	public Date getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public Date getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Date getFechaVentaHaya() {
		return fechaVentaHaya;
	}
	public void setFechaVentaHaya(Date fechaVentaHaya) {
		this.fechaVentaHaya = fechaVentaHaya;
	}
	public String getLiquidez() {
		return liquidez;
	}
	public void setLiquidez(String liquidez) {
		this.liquidez = liquidez;
	}
	
}