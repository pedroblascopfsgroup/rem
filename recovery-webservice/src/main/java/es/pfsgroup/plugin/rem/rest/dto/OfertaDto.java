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
	private Long idVisitaRem;
	@NotNull
	private Long idClienteRem;
	@NotNull
	private Long idActivoHaya;
	@NotNull
	private Double importe;
	private Double importeContraoferta;
	private List<OfertaTitularAdicionalDto> titularesAdicionales;
	@NotNull
	private Long idProveedorRemPrescriptor;
	@NotNull
	private Long idProveedorRemCustodio;
	private Long idProveedorRemResponsable;
	private Long idProveedorRemFdv;
	@NotNull
	@Size(max=20)
	private String codEstadoOferta;
	@NotNull
	@Size(max=20)
	private String codTipoOferta;
	@NotNull
	private Date fechaAccion;
	@NotNull
	private Long idUsuarioRemAccion;
	
	
	
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
	public Long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}
	public void setIdUsuarioRemAccion(Long idUsuarioRem) {
		this.idUsuarioRemAccion = idUsuarioRem;
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
	public Double getImporte() {
		return importe;
	}
	public void setImporte(Double importe) {
		this.importe = importe;
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
	public List<OfertaTitularAdicionalDto> getTitularesAdicionales() {
		return titularesAdicionales;
	}
	public void setTitularesAdicionales(
			List<OfertaTitularAdicionalDto> titularesAdicionales) {
		this.titularesAdicionales = titularesAdicionales;
	}
	
	
	
	
}
