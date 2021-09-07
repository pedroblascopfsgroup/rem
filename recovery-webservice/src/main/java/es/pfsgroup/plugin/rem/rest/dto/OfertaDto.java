package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.IsNumber;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Lista;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSocioComercial;
import es.pfsgroup.plugin.rem.model.dd.DDVinculoCaixa;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class OfertaDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	
	@NotNull(groups = { Insert.class, Update.class })
	private Long idOfertaWebcom;
	private Long idOfertaRem;
	private Long idVisitaRem;
	@NotNull(groups = { Insert.class })
	@Lista(clase = ClienteComercial.class, message = "El idClienteRem no existe", groups = { Insert.class,
			Update.class },foreingField="idClienteRem")
	private Long idClienteRem;
	private Long idActivoHaya;
	@NotNull(groups = { Insert.class })
	private Double importe;
	private Double importeContraoferta;
	private List<OfertaTitularAdicionalDto> titularesAdicionales;
	@NotNull(groups = { Insert.class })
	private Long idProveedorRemPrescriptor;
	private Long idProveedorRemCustodio;
	private Long idProveedorRemResponsable;
	private Long idProveedorRemFdv;
	@Size(max=20,groups = { Insert.class, Update.class })
	private String codEstadoOferta;
	@NotNull(groups = { Insert.class })
	@Size(max=20,groups = { Insert.class, Update.class })
	private String codTipoOferta;
	@NotNull(groups = { Insert.class, Update.class })
	private Date fechaAccion;
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = Usuario.class, message = "El usuario no existe", groups = { Insert.class,
		Update.class },foreingField="id")
	private Long idUsuarioRemAccion;
	private Long idClienteComercial;
	@Size(max=1000)
	private String observaciones;
	@NotNull(groups = {Insert.class})
	private Boolean financiacion;
	@NotNull(groups = {Insert.class})
	private Boolean isExpress;
	private String codTarea;
	private Boolean aceptacionContraoferta;
	private Date fechaPrevistaFirma;
	private String lugarFirma;
	private Date fechaFirma;
	private Boolean firmado;
	private List<ActivosLoteOfertaDto> activosLote;
	private Boolean ofertaLote;
	private Long idAgrupacionComercialWebcom;
	private Long codigoAgrupacionComercialRem;
	private String origenLeadProveedor;
	private Boolean esOfertaSingular;
	@IsNumber(message = "Debe ser un número")
	private String idProveedorPrescriptorRemOrigenLead;
	private Date fechaOrigenLead;
	private String codTipoProveedorOrigenCliente;
	@IsNumber(message = "Debe ser un número")
	private String idProveedorRealizadorRemOrigenLead;
	private String numeroBulkAdvisoryNote;
	private String recomendacionRc;
	private Date fechaRecomendacionRc;
	private String recomendacionDc;
	private Date fechaRecomendacionDc;
	private String documentoIdentificativo;
	private String nombreDocumentoIdentificativo;
	private String documentoGDPR;
	private String nombreDocumentoGDPR;
	private Boolean docResponsabilidadPrescriptor;
	private String porcentajeDescuento;
	private String justificacionOferta;
	private Date fechaAcepGdpr;
	@Diccionary(clase = DDVinculoCaixa.class, message = "El vinculoCaixa no existe")
	private String vinculoCaixa;	
	@Diccionary(clase = DDTipoSocioComercial.class, message = "El sociedadEmpleadoGrupoCaixa no existe")
	private String sociedadEmpleadoGrupoCaixa;
	@IsNumber(message = "Debe ser un número")
	private Integer oficinaEmpleadoCaixa;
	private Boolean esAntiguoDeudor;
	private Date fechaAltaWC;
	
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
	public Long getIdClienteComercial() {
		return idClienteComercial;
	}
	public void setIdClienteComercial(Long idClienteComercial) {
		this.idClienteComercial = idClienteComercial;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Boolean getFinanciacion() {
		return financiacion;
	}
	public void setFinanciacion(Boolean financiacion) {
		this.financiacion = financiacion;
	}
	public Boolean getIsExpress() {
		return isExpress;
	}
	public void setIsExpress(Boolean isExpress) {
		this.isExpress = isExpress;
	}
	public String getCodTarea() {
		return codTarea;
	}
	public void setCodTarea(String codTarea) {
		this.codTarea = codTarea;
	}
	public Boolean getAceptacionContraoferta() {
		return aceptacionContraoferta;
	}
	public void setAceptacionContraoferta(Boolean aceptacionContraoferta) {
		this.aceptacionContraoferta = aceptacionContraoferta;
	}
	public Date getFechaPrevistaFirma() {
		return fechaPrevistaFirma;
	}
	public void setFechaPrevistaFirma(Date fechaPrevistaFirma) {
		this.fechaPrevistaFirma = fechaPrevistaFirma;
	}
	public String getLugarFirma() {
		return lugarFirma;
	}
	public void setLugarFirma(String lugarFirma) {
		this.lugarFirma = lugarFirma;
	}
	public Date getFechaFirma() {
		return fechaFirma;
	}
	public void setFechaFirma(Date fechaFirma) {
		this.fechaFirma = fechaFirma;
	}
	public Boolean getFirmado() {
		return firmado;
	}
	public void setFirmado(Boolean firmado) {
		this.firmado = firmado;
	}
	public List<ActivosLoteOfertaDto> getActivosLote() {
		return activosLote;
	}
	public void setActivosLote(List<ActivosLoteOfertaDto> activosLote) {
		this.activosLote = activosLote;
	}
	public Boolean getOfertaLote() {
		return ofertaLote;
	}
	public void setOfertaLote(Boolean indicadorOfertaLote) {
		this.ofertaLote = indicadorOfertaLote;
	}
	public Long getIdAgrupacionComercialWebcom() {
		return idAgrupacionComercialWebcom;
	}
	public void setIdAgrupacionComercialWebcom(Long idAgrupacionComercialWebcom) {
		this.idAgrupacionComercialWebcom = idAgrupacionComercialWebcom;
	}
	public Long getCodigoAgrupacionComercialRem() {
		return codigoAgrupacionComercialRem;
	}
	public void setCodigoAgrupacionComercialRem(Long codigoAgrupacionComercialRem) {
		this.codigoAgrupacionComercialRem = codigoAgrupacionComercialRem;
	}
	public String getOrigenLeadProveedor() {
		return origenLeadProveedor;
	}
	public void setOrigenLeadProveedor(String origenLeadProveedor) {
		this.origenLeadProveedor = origenLeadProveedor;
	}
	public Boolean getEsOfertaSingular() {
		return esOfertaSingular;
	}
	public void setEsOfertaSingular(Boolean esOfertaSingular) {
		this.esOfertaSingular = esOfertaSingular;
	}
	public String getIdProveedorPrescriptorRemOrigenLead() {
		return idProveedorPrescriptorRemOrigenLead;
	}
	public void setIdProveedorPrescriptorRemOrigenLead(String idProveedorPrescriptorRemOrigenLead) {
		this.idProveedorPrescriptorRemOrigenLead = idProveedorPrescriptorRemOrigenLead;
	}
	public Date getFechaOrigenLead() {
		return fechaOrigenLead;
	}
	public void setFechaOrigenLead(Date fechaOrigenLead) {
		this.fechaOrigenLead = fechaOrigenLead;
	}
	public String getCodTipoProveedorOrigenCliente() {
		return codTipoProveedorOrigenCliente;
	}
	public void setCodTipoProveedorOrigenCliente(String codTipoProveedorOrigenCliente) {
		this.codTipoProveedorOrigenCliente = codTipoProveedorOrigenCliente;
	}
	public String getIdProveedorRealizadorRemOrigenLead() {
		return idProveedorRealizadorRemOrigenLead;
	}
	public void setIdProveedorRealizadorRemOrigenLead(String idProveedorRealizadorRemOrigenLead) {
		this.idProveedorRealizadorRemOrigenLead = idProveedorRealizadorRemOrigenLead;
	}

	public String getNumeroBulkAdvisoryNote() {
		return numeroBulkAdvisoryNote;
	}
	public void setNumeroBulkAdvisoryNote(String numeroBulkAdvisoryNote) {
		this.numeroBulkAdvisoryNote = numeroBulkAdvisoryNote;
	}
	public String getRecomendacionRc() {
		return recomendacionRc;
	}
	public void setRecomendacionRc(String recomendacionRc) {
		this.recomendacionRc = recomendacionRc;
	}
	public Date getFechaRecomendacionRc() {
		return fechaRecomendacionRc;
	}
	public void setFechaRecomendacionRc(Date fechaRecomendacionRc) {
		this.fechaRecomendacionRc = fechaRecomendacionRc;
	}
	public String getRecomendacionDc() {
		return recomendacionDc;
	}
	public void setRecomendacionDc(String recomendacionDc) {
		this.recomendacionDc = recomendacionDc;
	}
	public Date getFechaRecomendacionDc() {
		return fechaRecomendacionDc;
	}
	public void setFechaRecomendacionDc(Date fechaRecomendacionDc) {
		this.fechaRecomendacionDc = fechaRecomendacionDc;
	}

	public String getDocumentoIdentificativo() {
		return documentoIdentificativo;
	}
	public void setDocumentoIdentificativo(String documentoIdentificativo) {
		this.documentoIdentificativo = documentoIdentificativo;
	}
	public String getNombreDocumentoIdentificativo() {
		return nombreDocumentoIdentificativo;
	}
	public void setNombreDocumentoIdentificativo(String nombreDocumentoIdentificativo) {
		this.nombreDocumentoIdentificativo = nombreDocumentoIdentificativo;
	}
	public String getDocumentoGDPR() {
		return documentoGDPR;
	}
	public void setDocumentoGDPR(String documentoGDPR) {
		this.documentoGDPR = documentoGDPR;
	}
	public String getNombreDocumentoGDPR() {
		return nombreDocumentoGDPR;
	}
	public void setNombreDocumentoGDPR(String nombreDocumentoGDPR) {
		this.nombreDocumentoGDPR = nombreDocumentoGDPR;
	}
	public Boolean getDocResponsabilidadPrescriptor() {
		return docResponsabilidadPrescriptor;
	}
	public void setDocResponsabilidadPrescriptor(Boolean docResponsabilidadPrescriptor) {
		this.docResponsabilidadPrescriptor = docResponsabilidadPrescriptor;
	}
	public String getPorcentajeDescuento() {
		return porcentajeDescuento;
	}
	public void setPorcentajeDescuento(String porcentajeDescuento) {
		this.porcentajeDescuento = porcentajeDescuento;
	}
	public String getJustificacionOferta() {
		return justificacionOferta;
	}
	public void setJustificacionOferta(String justificacionOferta) {
		this.justificacionOferta = justificacionOferta;
	}
	public Date getFechaAcepGdpr() {
		return fechaAcepGdpr;
	}
	public void setFechaAcepGdpr(Date fechaAcepGdpr) {
		this.fechaAcepGdpr = fechaAcepGdpr;
	}
	public String getVinculoCaixa() {
		return vinculoCaixa;
	}
	public void setVinculoCaixa(String vinculoCaixa) {
		this.vinculoCaixa = vinculoCaixa;
	}
	public String getSociedadEmpleadoGrupoCaixa() {
		return sociedadEmpleadoGrupoCaixa;
	}
	public void setSociedadEmpleadoGrupoCaixa(String sociedadEmpleadoGrupoCaixa) {
		this.sociedadEmpleadoGrupoCaixa = sociedadEmpleadoGrupoCaixa;
	}
	public Integer getOficinaEmpleadoCaixa() {
		return oficinaEmpleadoCaixa;
	}
	public void setOficinaEmpleadoCaixa(Integer oficinaEmpleadoCaixa) {
		this.oficinaEmpleadoCaixa = oficinaEmpleadoCaixa;
	}
	public Boolean getEsAntiguoDeudor() {
		return esAntiguoDeudor;
	}
	public void setEsAntiguoDeudor(Boolean esAntiguoDeudor) {
		this.esAntiguoDeudor = esAntiguoDeudor;
	}
	public Date getFechaAltaWC() {
		return fechaAltaWC;
	}
	public void setFechaAltaWC(Date fechaAltaWC) {
		this.fechaAltaWC = fechaAltaWC;
	}

}
