package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoOcupacionIlegal extends WebDto {
	
	private static final long serialVersionUID = 1L;
	
	private String id; //id ocupación
	private Long idActivo;
	private String numAsunto;
	private Date fechaInicioAsunto;
	private Date fechaFinAsunto;
	private Date fechaLanzamiento;
	private String tipoAsunto;
	private String tipoActuacion;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getNumAsunto() {
		return numAsunto;
	}
	public void setNumAsunto(String numAsunto) {
		this.numAsunto = numAsunto;
	}
	public Date getFechaInicioAsunto() {
		return fechaInicioAsunto;
	}
	public void setFechaInicioAsunto(Date fechaInicioAsunto) {
		this.fechaInicioAsunto = fechaInicioAsunto;
	}
	public Date getFechaFinAsunto() {
		return fechaFinAsunto;
	}
	public void setFechaFinAsunto(Date fechaFinAsunto) {
		this.fechaFinAsunto = fechaFinAsunto;
	}
	public Date getFechaLanzamiento() {
		return fechaLanzamiento;
	}
	public void setFechaLanzamiento(Date fechaLanzamiento) {
		this.fechaLanzamiento = fechaLanzamiento;
	}
	public String getTipoAsunto() {
		return tipoAsunto;
	}
	public void setTipoAsunto(String tipoAsunto) {
		this.tipoAsunto = tipoAsunto;
	}
	public String getTipoActuacion() {
		return tipoActuacion;
	}
	public void setTipoActuacion(String tipoActuacion) {
		this.tipoActuacion = tipoActuacion;
	}
	
}
