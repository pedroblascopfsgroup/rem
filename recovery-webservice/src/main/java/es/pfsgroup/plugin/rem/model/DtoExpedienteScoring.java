package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de las resoluciones del expediente.
 *  
 * @author Ivan Rubio
 *
 */
public class DtoExpedienteScoring extends WebDto {
  
	/**
	 * 
	 */
	private static final long serialVersionUID = -8712539111526783294L;
	
	private Long id;
	private String estadoEscoring;
    private String motivoRechazo;
    private String idSolicitud;
	private Boolean revision;
	private String comentarios;
	private Date fechaResolucion;
	private String codigoRating;
	private String numExpedienteExterno;
	
	public String getComboEstadoScoring() {
		return estadoEscoring;
	}
	public void setComboEstadoScoring(String estadoEscoring) {
		this.estadoEscoring = estadoEscoring;
	}
	
	public String getnSolicitud() {
		return idSolicitud;
	}
	public void setnSolicitud(String idSolicitud) {
		this.idSolicitud = idSolicitud;
	}
	public Boolean getRevision() {
		return revision;
	}
	public void setRevision(Boolean revision) {
		this.revision = revision;
	}
	public String getComentarios() {
		return comentarios;
	}
	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}
	public String getMotivoRechazo() {
		return motivoRechazo;
	}
	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getEstadoEscoring() {
		return estadoEscoring;
	}
	public void setEstadoEscoring(String estadoEscoring) {
		this.estadoEscoring = estadoEscoring;
	}
	public String getIdSolicitud() {
		return idSolicitud;
	}
	public void setIdSolicitud(String idSolicitud) {
		this.idSolicitud = idSolicitud;
	}
	public Date getFechaResolucion() {
		return fechaResolucion;
	}
	public void setFechaResolucion(Date fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}
	public String getCodigoRating() {
		return codigoRating;
	}
	public void setCodigoRating(String codigoRating) {
		this.codigoRating = codigoRating;
	}
	public String getNumExpedienteExterno() {
		return numExpedienteExterno;
	}
	public void setNumExpedienteExterno(String numExpedienteExterno) {
		this.numExpedienteExterno = numExpedienteExterno;
	}
	
}
