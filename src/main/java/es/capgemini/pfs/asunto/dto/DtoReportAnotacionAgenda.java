package es.capgemini.pfs.asunto.dto;

import java.util.Date;

public class DtoReportAnotacionAgenda {

	private String usuario;
	private String descripcionTarea;
	private String tipo;
	private String actuacion;
	private Date fechaInicio;
	private Date fechaVto;
	private String idTarea;
	
	private String tipoProcedimiento;

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getDescripcionTarea() {
		return descripcionTarea;
	}

	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaVto() {
		return fechaVto;
	}

	public void setFechaVto(Date fechaVto) {
		this.fechaVto = fechaVto;
	}

	public String getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(String idTarea) {
		this.idTarea = idTarea;
	}

	public String getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(String tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}

	public String getActuacion() {
		return actuacion;
	}

	public void setActuacion(String actuacion) {
		this.actuacion = actuacion;
	}

}
