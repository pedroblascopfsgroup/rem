package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.filtro;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class LiquidacionFiltroDTO extends WebDto {

	private static final long serialVersionUID = 4446877764031512501L;

	private String estado;
	private Date fechaSolicitudDesde;
	private Date fechaSolicitudHasta;
	private Date fechaRecepcionDesde;
	private Date fechaRecepcionHasta;
	private Date fechaConfirmacionDesde;
	private Date fechaConfirmacionHasta;
	private Date fechaCierreDesde;
	private Date fechaCierreHasta;
	private Double totalDesde;
	private Double totalHasta;

	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public Date getFechaSolicitudDesde() {
		return fechaSolicitudDesde;
	}
	public void setFechaSolicitudDesde(Date fechaSolicitudDesde) {
		this.fechaSolicitudDesde = fechaSolicitudDesde;
	}
	public Date getFechaSolicitudHasta() {
		return fechaSolicitudHasta;
	}
	public void setFechaSolicitudHasta(Date fechaSolicitudHasta) {
		this.fechaSolicitudHasta = fechaSolicitudHasta;
	}
	public Date getFechaRecepcionDesde() {
		return fechaRecepcionDesde;
	}
	public void setFechaRecepcionDesde(Date fechaRecepcionDesde) {
		this.fechaRecepcionDesde = fechaRecepcionDesde;
	}
	public Date getFechaRecepcionHasta() {
		return fechaRecepcionHasta;
	}
	public void setFechaRecepcionHasta(Date fechaRecepcionHasta) {
		this.fechaRecepcionHasta = fechaRecepcionHasta;
	}
	public Date getFechaConfirmacionDesde() {
		return fechaConfirmacionDesde;
	}
	public void setFechaConfirmacionDesde(Date fechaConfirmacionDesde) {
		this.fechaConfirmacionDesde = fechaConfirmacionDesde;
	}
	public Date getFechaConfirmacionHasta() {
		return fechaConfirmacionHasta;
	}
	public void setFechaConfirmacionHasta(Date fechaConfirmacionHasta) {
		this.fechaConfirmacionHasta = fechaConfirmacionHasta;
	}
	public Date getFechaCierreDesde() {
		return fechaCierreDesde;
	}
	public void setFechaCierreDesde(Date fechaCierreDesde) {
		this.fechaCierreDesde = fechaCierreDesde;
	}
	public Date getFechaCierreHasta() {
		return fechaCierreHasta;
	}
	public void setFechaCierreHasta(Date fechaCierreHasta) {
		this.fechaCierreHasta = fechaCierreHasta;
	}
	public Double getTotalDesde() {
		return totalDesde;
	}
	public void setTotalDesde(Double totalDesde) {
		this.totalDesde = totalDesde;
	}
	public Double getTotalHasta() {
		return totalHasta;
	}
	public void setTotalHasta(Double totalHasta) {
		this.totalHasta = totalHasta;
	}
}
