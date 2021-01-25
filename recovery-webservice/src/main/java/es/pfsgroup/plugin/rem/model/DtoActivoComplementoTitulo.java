package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoActivoComplementoTitulo extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long id;
	private Long activoId;
	private Date fechaAlta;
	private String gestorAlta;
	private String tipoTitulo;
	private Date fechaSolicitud;
	private Date fechaTitulo;
	private Date fechaRecepcion;
	private Date fechaInscripcion;
	private String observaciones;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getActivoId() {
		return activoId;
	}
	public void setActivoId(Long activoId) {
		this.activoId = activoId;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getGestorAlta() {
		return gestorAlta;
	}
	public void setGestorAlta(String gestorAlta) {
		this.gestorAlta = gestorAlta;
	}
	public String getTipoTitulo() {
		return tipoTitulo;
	}
	public void setTipoTitulo(String tipoTitulo) {
		this.tipoTitulo = tipoTitulo;
	}
	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public Date getFechaTitulo() {
		return fechaTitulo;
	}
	public void setFechaTitulo(Date fechaTitulo) {
		this.fechaTitulo = fechaTitulo;
	}
	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}
	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}
	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}
	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
	
	
}
