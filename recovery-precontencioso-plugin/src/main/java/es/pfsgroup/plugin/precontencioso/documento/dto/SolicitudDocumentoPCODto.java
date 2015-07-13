package es.pfsgroup.plugin.precontencioso.documento.dto;

import java.util.Date;

public class SolicitudDocumentoPCODto {
	private Long id;
	private Long idDoc;
	private String contrato;
	private String descripcionUG;
	private String tipoDocumento;
	private String estado;
	private String adjunto;
	private String actor;
	private Date fechaSolicitud;
	private Date fechaResultado;
	private Date fechaEnvio;
	private Date fechaRecepcion;
	private String resultado;
	private String comentario;

	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdDoc() {
		return idDoc;
	}
	public void setIdDoc(Long idDoc) {
		this.idDoc = idDoc;
	}
	public String getContrato() {
		return contrato;
	}
	public void setContrato(String contrato) {
		this.contrato = contrato;
	}
	public String getDescripcionUG() {
		return descripcionUG;
	}
	public void setDescripcionUG(String descripcionUG) {
		this.descripcionUG = descripcionUG;
	}
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getAdjunto() {
		return adjunto;
	}
	public void setAdjunto(String adjunto) {
		this.adjunto = adjunto;
	}
	public String getActor() {
		return actor;
	}
	public void setActor(String actor) {
		this.actor = actor;
	}
	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public Date getFechaResultado() {
		return fechaResultado;
	}
	public void setFechaResultado(Date fechaResultado) {
		this.fechaResultado = fechaResultado;
	}
	public Date getFechaEnvio() {
		return fechaEnvio;
	}
	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}
	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}
	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}
	public String getResultado() {
		return resultado;
	}
	public void setResultado(String resultado) {
		this.resultado = resultado;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	
}
