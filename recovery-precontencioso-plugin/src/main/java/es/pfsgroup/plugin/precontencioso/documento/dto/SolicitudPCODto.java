package es.pfsgroup.plugin.precontencioso.documento.dto;

import java.util.Date;

public class SolicitudPCODto {
	private Long id;
	private Long idDoc;
	private String actor;
	private Date fechaSolicitud;
	private Date fechaResultado;
	private Date fechaEnvio;
	private Date fechaRecepcion;
	private String resultado;
	private Long idTipoGestor;
	private Long idDespachoExterno;
	
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
	public Long getIdTipoGestor() {
		return idTipoGestor;
	}
	public void setIdTipoGestor(Long idTipoGestor) {
		this.idTipoGestor = idTipoGestor;
	}
	public Long getIdDespachoExterno() {
		return idDespachoExterno;
	}
	public void setIdDespachoExterno(Long idDespachoExterno) {
		this.idDespachoExterno = idDespachoExterno;
	}
	
}
