package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoSendNotificator extends WebDto {

	private static final long serialVersionUID = 1L;
	private Long numTrabajo;
	private String tipoContrato;
	private String fechaFinalizacion;
	private Long numActivo;
	private String direccion;
	private Long numAgrupacion;
	private String titulo = "Notificación encargo de trabajo en REM";

	public Long getNumTrabajo() {
		return numTrabajo;
	}
	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}
	public String getTipoContrato() {
		return tipoContrato;
	}
	public void setTipoContrato(String tipoContrato) {
		this.tipoContrato = tipoContrato;
	}
	public String getFechaFinalizacion() {
		return fechaFinalizacion;
	}
	public void setFechaFinalizacion(String fechaFinalizacion) {
		this.fechaFinalizacion = fechaFinalizacion;
	}
	public Long getNumActivo() {
		if(numActivo == null){
			numActivo = 0L;
		}
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public String getDireccion() {
		if(direccion == null){
			direccion = "";
		}
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public Long getNumAgrupacion() {
		return numAgrupacion;
	}
	public void setNumAgrupacion(Long numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
	}
	public String getTitulo() {
		if(titulo == null){
			titulo = "";
		}
		return titulo;
	}
	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}
	
}
