package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoGridFechaArras extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
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
	private String fechaPropuestaString;
	private String motivoAnulacion;
	private String validacionBCcodigo;
	
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
	public String getFechaPropuestaString() {
		return fechaPropuestaString;
	}
	public void setFechaPropuestaString(String fechaPropuestaString) {
		this.fechaPropuestaString = fechaPropuestaString;
	}
	public String getMotivoAnulacion() {
		return motivoAnulacion;
	}
	public void setMotivoAnulacion(String motivoAnulacion) {
		this.motivoAnulacion = motivoAnulacion;
	}
	public String getValidacionBCcodigo() {
		return validacionBCcodigo;
	}
	public void setValidacionBCcodigo(String validacionBCcodigo) {
		this.validacionBCcodigo = validacionBCcodigo;
	}
	
	
}
