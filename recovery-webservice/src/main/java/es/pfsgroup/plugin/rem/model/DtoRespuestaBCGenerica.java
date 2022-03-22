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
	private String necesidadArrasActivo;
	
	private String comite;
	
	private String comiteBc;
	private String resultado;
	
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
	public String getNecesidadArrasActivo() {
		return necesidadArrasActivo;
	}
	public void setNecesidadArrasActivo(String necesidadArrasActivo) {
		this.necesidadArrasActivo = necesidadArrasActivo;
	}
	public String getComite() {
		return comite;
	}
	public void setComite(String comite) {
		this.comite = comite;
	}
	public String getComiteBc() {
		return comiteBc;
	}
	public void setComiteBc(String comiteBc) {
		this.comiteBc = comiteBc;
	}
	public String getResultado() {
		return resultado;
	}
	public void setResultado(String resultado) {
		this.resultado = resultado;
	}
	
	
	
	
}
