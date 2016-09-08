package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

public class OfertaDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	
	@NotNull
	private Long idOfertaWebcom;
	private Long idOfertaRem;
	private Double importeContraoferta;
	private Long idVisitaRem;
	@NotNull
	private Long idClienteRem;
	@NotNull
	private Long idActivoHaya;
	@NotNull
	private Date fechaAccion;
	@NotNull
	private Long idUsuarioRem;
	@NotNull
	@Size(max=20)
	private String codEstadoOferta;
	@NotNull
	@Size(max=20)
	private String codTipoOferta;
	@NotNull
	private Long idPrescriptor;
	private Long idApiResponsable;
	@NotNull
	private Double amount;
	private List<OfertaTitularAdicionalDto> titularesAdicionales;
	
	
	
	public Long getIdOfertaWebcom() {
		return idOfertaWebcom;
	}
	public void setIdOfertaWebcom(Long idOfertaWebcom) {
		this.idOfertaWebcom = idOfertaWebcom;
	}
	public Long getIdOfertaRem() {
		return idOfertaRem;
	}
	public void setIdOfertaRem(Long idOfertaRem) {
		this.idOfertaRem = idOfertaRem;
	}
	public Double getImporteContraoferta() {
		return importeContraoferta;
	}
	public void setImporteContraoferta(Double importeContraoferta) {
		this.importeContraoferta = importeContraoferta;
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
	public Date getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public Long getIdUsuarioRem() {
		return idUsuarioRem;
	}
	public void setIdUsuarioRem(Long idUsuarioRem) {
		this.idUsuarioRem = idUsuarioRem;
	}
	public String getCodEstadoOferta() {
		return codEstadoOferta;
	}
	public void setCodEstadoOferta(String codEstadoOferta) {
		this.codEstadoOferta = codEstadoOferta;
	}
	public String getCodTipoOferta() {
		return codTipoOferta;
	}
	public void setCodTipoOferta(String codTipoOferta) {
		this.codTipoOferta = codTipoOferta;
	}
	public Long getIdPrescriptor() {
		return idPrescriptor;
	}
	public void setIdPrescriptor(Long idPrescriptor) {
		this.idPrescriptor = idPrescriptor;
	}
	public Long getIdApiResponsable() {
		return idApiResponsable;
	}
	public void setIdApiResponsable(Long idApiResponsable) {
		this.idApiResponsable = idApiResponsable;
	}
	public Double getAmount() {
		return amount;
	}
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	public List<OfertaTitularAdicionalDto> getTitularesAdicionales() {
		return titularesAdicionales;
	}
	public void setTitularesAdicionales(
			List<OfertaTitularAdicionalDto> titularesAdicionales) {
		this.titularesAdicionales = titularesAdicionales;
	}
	
	
	
	
}
