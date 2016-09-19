package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

public class ComisionDto implements Serializable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@NotNull
	private Long idHonorarioWebcom;
	@NotNull
	private Long idHonorarioRem;
	@NotNull
	private Long idOfertaRem;
	@NotNull
	private Long idProveedorRem;
	@NotNull
	private Boolean esPrescripcion;
	@NotNull
	private Boolean esColaboracion;
	@NotNull
	private Boolean esResponsable;
	@NotNull
	private Boolean esDoblePrescripcion;
	@NotNull
	private Boolean esFdv;
	@Size(max=250)
	private String observaciones;
	@NotNull
	private Boolean aceptacion;
	@NotNull
	private Date fechaAccion;
	@NotNull
	private Long idUsuarioRemAccion;
	
	
	
	public Long getIdHonorarioWebcom() {
		return idHonorarioWebcom;
	}
	public void setIdHonorarioWebcom(Long idHonorarioWebcom) {
		this.idHonorarioWebcom = idHonorarioWebcom;
	}
	public Long getIdHonorarioRem() {
		return idHonorarioRem;
	}
	public void setIdHonorarioRem(Long idHonorarioRem) {
		this.idHonorarioRem = idHonorarioRem;
	}
	public Long getIdOfertaRem() {
		return idOfertaRem;
	}
	public void setIdOfertaRem(Long idOfertaRem) {
		this.idOfertaRem = idOfertaRem;
	}
	public Long getIdProveedorRem() {
		return idProveedorRem;
	}
	public void setIdProveedorRem(Long idProveedorRem) {
		this.idProveedorRem = idProveedorRem;
	}
	public Boolean getEsPrescripcion() {
		return esPrescripcion;
	}
	public void setEsPrescripcion(Boolean esPrescripcion) {
		this.esPrescripcion = esPrescripcion;
	}
	public Boolean getEsColaboracion() {
		return esColaboracion;
	}
	public void setEsColaboracion(Boolean esColaboracion) {
		this.esColaboracion = esColaboracion;
	}
	public Boolean getEsResponsable() {
		return esResponsable;
	}
	public void setEsResponsable(Boolean esResponsable) {
		this.esResponsable = esResponsable;
	}
	public Boolean getEsDoblePrescripcion() {
		return esDoblePrescripcion;
	}
	public void setEsDoblePrescripcion(Boolean esDoblePrescripcion) {
		this.esDoblePrescripcion = esDoblePrescripcion;
	}
	public Boolean getEsFdv() {
		return esFdv;
	}
	public void setEsFdv(Boolean esFdv) {
		this.esFdv = esFdv;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Boolean getAceptacion() {
		return aceptacion;
	}
	public void setAceptacion(Boolean aceptacion) {
		this.aceptacion = aceptacion;
	}
	public Date getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public Long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}
	public void setIdUsuarioRemAccion(Long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}

	
}
