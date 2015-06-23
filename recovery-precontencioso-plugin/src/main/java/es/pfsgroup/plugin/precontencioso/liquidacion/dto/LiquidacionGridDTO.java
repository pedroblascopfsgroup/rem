package es.pfsgroup.plugin.precontencioso.liquidacion.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class LiquidacionGridDTO extends WebDto {

	private static final long serialVersionUID = 121566289292097578L;

	private String contrato;
	private Date fechaRecepcion;
	private Date fechaConfirmacion;
	private Date fechaCierre;
	private Double total;

	public String getContrato() {
		return contrato;
	}
	public void setContrato(String contrato) {
		this.contrato = contrato;
	}
	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}
	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}
	public Date getFechaConfirmacion() {
		return fechaConfirmacion;
	}
	public void setFechaConfirmacion(Date fechaConfirmacion) {
		this.fechaConfirmacion = fechaConfirmacion;
	}
	public Date getFechaCierre() {
		return fechaCierre;
	}
	public void setFechaCierre(Date fechaCierre) {
		this.fechaCierre = fechaCierre;
	}
	public Double getTotal() {
		return total;
	}
	public void setTotal(Double total) {
		this.total = total;
	}
}
