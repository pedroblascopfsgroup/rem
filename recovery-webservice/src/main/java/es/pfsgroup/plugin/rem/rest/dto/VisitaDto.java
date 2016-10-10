package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class VisitaDto implements Serializable {

	private static final long serialVersionUID = 3773651686763584927L;
	@NotNull(groups = { Insert.class, Update.class })
	private Long idVisitaWebcom;
	private Long idVisitaRem;
	@NotNull(groups = { Update.class })
	private Long idClienteRem;
	@NotNull(groups = { Update.class })
	private Long idActivoHaya;
	@NotNull(groups = { Insert.class})
	@Size(max=20)
	private String codEstadoVisita;
	@Size(max=20)
	private String codDetalleEstadoVisita;
	@NotNull(groups = { Insert.class})
	private Long idProveedorRemPrescriptor;
	@NotNull(groups = { Insert.class})
	private Long idProveedorRemCustodio;
	private Long idProveedorRemResponsable;
	private Long idProveedorRemFdv;
	private Long idProveedorRemVisita;
	//private Boolean visitaPrescriptor;
	//private Boolean visitaApiResponsable;
	//private Boolean visitaApiCustodio;
	@Size(max=250)
	private String observaciones;
	@NotNull
	private Date fechaAccion;
	@NotNull
	private Long idUsuarioRemAccion;
	
	
	
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
	public Date getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(Date fechaVisita) {
		this.fechaAccion = fechaVisita;
	}
	public Long getIdProveedorRemPrescriptor() {
		return idProveedorRemPrescriptor;
	}
	public void setIdProveedorRemPrescriptor(Long idProveedorRemPrescriptor) {
		this.idProveedorRemPrescriptor = idProveedorRemPrescriptor;
	}
	public Long getIdProveedorRemCustodio() {
		return idProveedorRemCustodio;
	}
	public void setIdProveedorRemCustodio(Long idProveedorRemCustodio) {
		this.idProveedorRemCustodio = idProveedorRemCustodio;
	}
	public Long getIdProveedorRemResponsable() {
		return idProveedorRemResponsable;
	}
	public void setIdProveedorRemResponsable(Long idProveedorRemResponsable) {
		this.idProveedorRemResponsable = idProveedorRemResponsable;
	}
	public Long getIdProveedorRemFdv() {
		return idProveedorRemFdv;
	}
	public void setIdProveedorRemFdv(Long idProveedorRemFdv) {
		this.idProveedorRemFdv = idProveedorRemFdv;
	}
	public Long getIdProveedorRemVisita() {
		return idProveedorRemVisita;
	}
	public void setIdProveedorRemVisita(Long idProveedorRemVisita) {
		this.idProveedorRemVisita = idProveedorRemVisita;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}
	public void setIdUsuarioRemAccion(Long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}	
	/*public Boolean getVisitaPrescriptor() {
		return visitaPrescriptor;
	}
	public void setVisitaPrescriptor(Boolean visitaPrescriptor) {
		this.visitaPrescriptor = visitaPrescriptor;
	}
	public Boolean getVisitaApiResponsable() {
		return visitaApiResponsable;
	}
	public void setVisitaApiResponsable(Boolean visitaApiResponsable) {
		this.visitaApiResponsable = visitaApiResponsable;
	}
	public Boolean getVisitaApiCustodio() {
		return visitaApiCustodio;
	}
	public void setVisitaApiCustodio(Boolean visitaApiCustodio) {
		this.visitaApiCustodio = visitaApiCustodio;
	}
	*/
}
