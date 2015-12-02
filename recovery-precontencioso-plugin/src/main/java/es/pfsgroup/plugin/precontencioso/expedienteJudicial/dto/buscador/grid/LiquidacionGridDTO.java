package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class LiquidacionGridDTO extends WebDto {

	private static final long serialVersionUID = 121566289292097578L;

	private String estado;
	private String contrato;
	private Date fechaRecepcion;
	private Date fechaConfirmacion;
	private Date fechaCierre;
	private Float total;

	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
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
	public Float getTotal() {
		return total;
	}
	public void setTotal(Float total) {
		this.total = total;
	}
}
