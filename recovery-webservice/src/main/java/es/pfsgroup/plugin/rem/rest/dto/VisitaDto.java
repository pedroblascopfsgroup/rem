package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

public class VisitaDto implements Serializable {

	private static final long serialVersionUID = 3773651686763584927L;
	@NotNull
	private Long idVisitaWebcom;
	private Long idVisitaRem;
	@NotNull
	private Long idClienteRem;
	@NotNull
	private Long idActivoHaya;
	@NotNull
	@Size(max=20)
	private String codEstadoVisita;
	@Size(max=20)
	private String codDetalleEstadoVisita;
	@NotNull
	private Date fechaVisita;
	@NotNull
	private Date fecha;
	@NotNull
	private Long idUsuarioRem;
	@NotNull
	private Long idPrescriptor;
	private Boolean visitaPrescriptor;
	private Long idApiResponsable;
	private Boolean visitaApiResponsable;
	private Long idApiCustodio;
	private Boolean visitaApiCustodio;
	@Size(max=250)
	private String observaciones;
	
	
	
	
	public Long getIdVisitaWebcom() {
		return idVisitaWebcom;
	}
	public void setIdVisitaWebcom(Long idVisitaWebcom) {
		this.idVisitaWebcom = idVisitaWebcom;
	}
	public Long getIdVisitaRem() {
		return idVisitaRem;
	}
	public void setIdVisitaRem(Long idVisitaRem) {
		this.idVisitaRem = idVisitaRem;
	}
	public Long getIdClienteRem() {
		return idClienteRem;
	}
	public void setIdClienteRem(Long idClienteRem) {
		this.idClienteRem = idClienteRem;
	}
	public Long getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(Long idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	public String getCodEstadoVisita() {
		return codEstadoVisita;
	}
	public void setCodEstadoVisita(String codEstadoVisita) {
		this.codEstadoVisita = codEstadoVisita;
	}
	public String getCodDetalleEstadoVisita() {
		return codDetalleEstadoVisita;
	}
	public void setCodDetalleEstadoVisita(String codDetalleEstadoVisita) {
		this.codDetalleEstadoVisita = codDetalleEstadoVisita;
	}
	public Date getFechaVisita() {
		return fechaVisita;
	}
	public void setFechaVisita(Date fechaVisita) {
		this.fechaVisita = fechaVisita;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public Long getIdUsuarioRem() {
		return idUsuarioRem;
	}
	public void setIdUsuarioRem(Long idUsuarioRem) {
		this.idUsuarioRem = idUsuarioRem;
	}	
	public Long getIdPrescriptor() {
		return idPrescriptor;
	}
	public void setIdPrescriptor(Long idPrescriptor) {
		this.idPrescriptor = idPrescriptor;
	}
	public Boolean getVisitaPrescriptor() {
		return visitaPrescriptor;
	}
	public void setVisitaPrescriptor(Boolean visitaPrescriptor) {
		this.visitaPrescriptor = visitaPrescriptor;
	}
	public Long getIdApiResponsable() {
		return idApiResponsable;
	}
	public void setIdApiResponsable(Long idApiResponsable) {
		this.idApiResponsable = idApiResponsable;
	}
	public Boolean getVisitaApiResponsable() {
		return visitaApiResponsable;
	}
	public void setVisitaApiResponsable(Boolean visitaApiResponsable) {
		this.visitaApiResponsable = visitaApiResponsable;
	}
	public Long getIdApiCustodio() {
		return idApiCustodio;
	}
	public void setIdApiCustodio(Long idApiCustodio) {
		this.idApiCustodio = idApiCustodio;
	}
	public Boolean getVisitaApiCustodio() {
		return visitaApiCustodio;
	}
	public void setVisitaApiCustodio(Boolean visitaApiCustodio) {
		this.visitaApiCustodio = visitaApiCustodio;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
}
