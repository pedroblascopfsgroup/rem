package es.pfsgroup.plugin.precontencioso.documento.dto;

import java.util.Date;

public class SolicitudDocumentoPCODto {
	private String idIdentificativo;
	private Long id;
	private Long idDoc;
	private String contrato;
	private String descripcionUG;
	private String tipoDocumento;
	private String estado;
	private String adjunto;
	private String ejecutivo;
	private String tipoActor;
	private String actor;
	private String fechaSolicitud;
	private String fechaResultado;
	private String fechaEnvio;
	private String fechaRecepcion;
	private String resultado;
	private String comentario;
	private boolean esDocumento;
	private boolean tieneSolicitud;
	private String codigoEstadoDocumento;
	//Solicitante
	private String solicitante;
	
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
	public String getTipoActor() {
		return tipoActor;
	}
	public void setTipoActor(String tipoActor) {
		this.tipoActor = tipoActor;
	}
	public String getActor() {
		return actor;
	}
	public void setActor(String actor) {
		this.actor = actor;
	}
	public String getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(String fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public String getFechaResultado() {
		return fechaResultado;
	}
	public void setFechaResultado(String fechaResultado) {
		this.fechaResultado = fechaResultado;
	}
	public String getFechaEnvio() {
		return fechaEnvio;
	}
	public void setFechaEnvio(String fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}
	public String getFechaRecepcion() {
		return fechaRecepcion;
	}
	public void setFechaRecepcion(String fechaRecepcion) {
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
	public boolean isEsDocumento() {
		return esDocumento;
	}
	public void setEsDocumento(boolean esDocumento) {
		this.esDocumento = esDocumento;
	}
	public String getEjecutivo() {
		return ejecutivo;
	}
	public void setEjecutivo(String ejecutivo) {
		this.ejecutivo = ejecutivo;
	}
	public boolean isTieneSolicitud() {
		return tieneSolicitud;
	}
	public void setTieneSolicitud(boolean tieneSolicitud) {
		this.tieneSolicitud = tieneSolicitud;
	}
	public String getCodigoEstadoDocumento() {
		return codigoEstadoDocumento;
	}
	public void setCodigoEstadoDocumento(String codigoEstadoDocumento) {
		this.codigoEstadoDocumento = codigoEstadoDocumento;
	}
	
	public String getIdIdentificativo() {
		return idIdentificativo;
	}
	public void setIdIdentificativo(String idIdentificativo) {
		this.idIdentificativo = idIdentificativo;
	}
	public String getSolicitante() {
		return solicitante;
	}
	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}
}
