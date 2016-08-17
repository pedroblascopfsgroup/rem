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
	private Long idEstadoVisita;
	@NotNull
	private Long idDetalleEstadoVisita;
	@NotNull
	private Date fecha;
	@NotNull
	private Long idUsuarioRem;
	@NotNull
	private Long idTipoPrescriptor;
	@NotNull
	@Size(max=5)
	private String prescriptor;
	private boolean visitaPrescriptor;
	@Size(max=5)
	private String apiResponsable;
	private boolean visitaApiResponsable;
	@Size(max=5)
	private String apiCustodio;
	private boolean visitaApiCustodio;
	@Size(max=250)
	private String observaciones;

	public Long getIdVisitaWebcom() {
		return idVisitaWebcom;
	}

	public void setIdVisitaWebcom(Long idVisitaWebcom) {
		this.idVisitaWebcom = idVisitaWebcom;
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

	public Long getIdEstadoVisita() {
		return idEstadoVisita;
	}

	public void setIdEstadoVisita(Long idEstadoVisita) {
		this.idEstadoVisita = idEstadoVisita;
	}

	public Long getIdDetalleEstadoVisita() {
		return idDetalleEstadoVisita;
	}

	public void setIdDetalleEstadoVisita(Long idDetalleEstadoVisita) {
		this.idDetalleEstadoVisita = idDetalleEstadoVisita;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public Long getIdVisitaRem() {
		return idVisitaRem;
	}

	public void setIdVisitaRem(Long idVisitaRem) {
		this.idVisitaRem = idVisitaRem;
	}

	public Long getIdUsuarioRem() {
		return idUsuarioRem;
	}

	public void setIdUsuarioRem(Long idUsuarioRem) {
		this.idUsuarioRem = idUsuarioRem;
	}

	public Long getIdTipoPrescriptor() {
		return idTipoPrescriptor;
	}

	public void setIdTipoPrescriptor(Long idTipoPrescriptor) {
		this.idTipoPrescriptor = idTipoPrescriptor;
	}

	public String getPrescriptor() {
		return prescriptor;
	}

	public void setPrescriptor(String prescriptor) {
		this.prescriptor = prescriptor;
	}

	public boolean isVisitaPrescriptor() {
		return visitaPrescriptor;
	}

	public void setVisitaPrescriptor(boolean visitaPrescriptor) {
		this.visitaPrescriptor = visitaPrescriptor;
	}

	public String getApiResponsable() {
		return apiResponsable;
	}

	public void setApiResponsable(String apiResponsable) {
		this.apiResponsable = apiResponsable;
	}

	public boolean isVisitaApiResponsable() {
		return visitaApiResponsable;
	}

	public void setVisitaApiResponsable(boolean visitaApiResponsable) {
		this.visitaApiResponsable = visitaApiResponsable;
	}

	public String getApiCustodio() {
		return apiCustodio;
	}

	public void setApiCustodio(String apiCustodio) {
		this.apiCustodio = apiCustodio;
	}

	public boolean isVisitaApiCustodio() {
		return visitaApiCustodio;
	}

	public void setVisitaApiCustodio(boolean visitaApiCustodio) {
		this.visitaApiCustodio = visitaApiCustodio;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	

}
