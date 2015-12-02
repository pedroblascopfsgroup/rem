package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class HistoricoEstadoProcedimientoDTO extends WebDto {

	private static final long serialVersionUID = 4822746418823702921L;

	private Long id;
	private String estado;
	private Date fechaInicio;
	private Date fechaFin;

	/*
	 * GETTERS & SETTERS
	 */

	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
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
}
