package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoGridFechaArras extends WebDto {
	
	private Long id;
	private Long idExpediente;
	private Date fechaAlta;
    private Date fechaEnvio;
    private Date fechaPropuesta;
    private Date fechaBC;
	private String validacionBC;
	private Date fechaAviso;
	private String comentariosBC;
	private String observaciones;
	
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
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public Date getFechaEnvio() {
		return fechaEnvio;
	}
	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}
	public Date getFechaPropuesta() {
		return fechaPropuesta;
	}
	public void setFechaPropuesta(Date fechaPropuesta) {
		this.fechaPropuesta = fechaPropuesta;
	}
	public Date getFechaBC() {
		return fechaBC;
	}
	public void setFechaBC(Date fechaBC) {
		this.fechaBC = fechaBC;
	}
	public String getValidacionBC() {
		return validacionBC;
	}
	public void setValidacionBC(String validacionBC) {
		this.validacionBC = validacionBC;
	}
	public Date getFechaAviso() {
		return fechaAviso;
	}
	public void setFechaAviso(Date fechaAviso) {
		this.fechaAviso = fechaAviso;
	}
	public String getComentariosBC() {
		return comentariosBC;
	}
	public void setComentariosBC(String comentariosBC) {
		this.comentariosBC = comentariosBC;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	
}
