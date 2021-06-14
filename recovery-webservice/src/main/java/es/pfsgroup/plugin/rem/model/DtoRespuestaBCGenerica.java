package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoRespuestaBCGenerica extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long id;
	private Long idExpediente;
	private String respuestaBC;
    private Date fechaRespuestaBC;
	private String observacionesBC;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdExpediente() {
		return idExpediente;
	}
	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}
	public String getRespuestaBC() {
		return respuestaBC;
	}
	public void setRespuestaBC(String respuestaBC) {
		this.respuestaBC = respuestaBC;
	}
	public Date getFechaRespuestaBC() {
		return fechaRespuestaBC;
	}
	public void setFechaRespuestaBC(Date fechaRespuestaBC) {
		this.fechaRespuestaBC = fechaRespuestaBC;
	}
	public String getObservacionesBC() {
		return observacionesBC;
	}
	public void setObservacionesBC(String observacionesBC) {
		this.observacionesBC = observacionesBC;
	}
	
	
	
	
}
