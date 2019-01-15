package es.pfsgroup.plugin.rem.model;

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
	
}
