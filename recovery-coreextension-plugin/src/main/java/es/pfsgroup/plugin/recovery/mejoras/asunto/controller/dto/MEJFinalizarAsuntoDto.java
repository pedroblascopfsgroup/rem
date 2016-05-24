package es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class MEJFinalizarAsuntoDto extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 474088364168601773L;

	private Long idAsunto;
	private Date fechaFinalizacion;
	private String motivoFinalizacion;
	private String observaciones;
	private String cumplidoSelect;
	
	public Long getIdAsunto() {
		return idAsunto;
	}
	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}
	public Date getFechaFinalizacion() {
		return fechaFinalizacion;
	}
	public void setFechaFinalizacion(Date fechaFinalizacion) {
		this.fechaFinalizacion = fechaFinalizacion;
	}
	public String getMotivoFinalizacion() {
		return motivoFinalizacion;
	}
	public void setMotivoFinalizacion(String motivoFinalizacion) {
		this.motivoFinalizacion = motivoFinalizacion;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getCumplidoSelect() {
		return cumplidoSelect;
	}
	public void setCumplidoSelect(String cumplidoSelect) {
		this.cumplidoSelect = cumplidoSelect;
	}
}
