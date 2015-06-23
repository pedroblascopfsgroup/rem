package es.pfsgroup.plugin.precontencioso.burofax.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class BurofaxFiltroDTO extends WebDto {

	private static final long serialVersionUID = 5427765727912164361L;

	private String estado;
	private String estadoEnvio;
	private Date fechaSolicitudDesde;
	private Date fechaSolicitudHasta;
	private Date fechaAcuseDesde;
	private Date fechaAcuseHasta;
	private Date fechaEnvioDesde;
	private Date fechaEnvioHasta;

	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getEstadoEnvio() {
		return estadoEnvio;
	}
	public void setEstadoEnvio(String estadoEnvio) {
		this.estadoEnvio = estadoEnvio;
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
	public Date getFechaAcuseDesde() {
		return fechaAcuseDesde;
	}
	public void setFechaAcuseDesde(Date fechaAcuseDesde) {
		this.fechaAcuseDesde = fechaAcuseDesde;
	}
	public Date getFechaAcuseHasta() {
		return fechaAcuseHasta;
	}
	public void setFechaAcuseHasta(Date fechaAcuseHasta) {
		this.fechaAcuseHasta = fechaAcuseHasta;
	}
	public Date getFechaEnvioDesde() {
		return fechaEnvioDesde;
	}
	public void setFechaEnvioDesde(Date fechaEnvioDesde) {
		this.fechaEnvioDesde = fechaEnvioDesde;
	}
	public Date getFechaEnvioHasta() {
		return fechaEnvioHasta;
	}
	public void setFechaEnvioHasta(Date fechaEnvioHasta) {
		this.fechaEnvioHasta = fechaEnvioHasta;
	}

}
