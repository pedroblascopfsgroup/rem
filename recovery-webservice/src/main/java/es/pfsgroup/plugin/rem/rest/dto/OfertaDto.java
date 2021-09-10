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
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class OfertaDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long idOfertaWebcom;
	private Long idOfertaHayaHome;
	private Long idOfertaRem;
	@NotNull(groups = { Insert.class, Update.class })
	private String entidadOrigen;
	private Long idVisitaRem;
	@NotNull(groups = { Insert.class })
	@Lista(clase = ClienteComercial.class, message = "El idClienteRem no existe", groups = { Insert.class,
			Update.class },foreingField="idClienteRem")
	private Long idClienteRem;
	private Long idClienteRemRepresentante;
	private Long idClienteContacto;
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
	private Boolean docResponsabilidadPrescriptor;
	private String porcentajeDescuento;
	private String justificacionOferta;
	private String origenOferta;
	private Double mesesCarencia;
	private Boolean contratoReserva;
	private String motivoCongelacion;
	private Boolean ibi;
	private Double importeIbi;
	private Boolean otrasTasas;
	private Double importeOtrasTasas;
	private Boolean ccpp;
	private Double importeCcpp;
	private Double porcentaje1anyo;
	private Double porcentaje2anyo;
	private Double porcentaje3anyo;
	private Double porcentaje4anyo;
	private Double mesesCarenciaContraoferta;
	private Double porcentaje1anyoContraoferta;
	private Double porcentaje2anyoContraoferta;
	private Double porcentaje3anyoContraoferta;
	private Double porcentaje4anyoContraoferta;
	private String estadoOferta;
	private String subestadoOferta;
	
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
	public Long getIdOfertaHayaHome() {
		return idOfertaHayaHome;
	}
	public void setIdOfertaHayaHome(Long idOfertaHayaHome) {
		this.idOfertaHayaHome = idOfertaHayaHome;
	}
	public String getEntidadOrigen() {
		return entidadOrigen;
	}
	public void setEntidadOrigen(String entidadOrigen) {
		this.entidadOrigen = entidadOrigen;
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
	public Long getIdClienteRemRepresentante() {
		return idClienteRemRepresentante;
	}
	public void setIdClienteRemRepresentante(Long idClienteRemRepresentante) {
		this.idClienteRemRepresentante = idClienteRemRepresentante;
	}
	public Long getIdClienteContacto() {
		return idClienteContacto;
	}
	public void setIdClienteContacto(Long idClienteContacto) {
		this.idClienteContacto = idClienteContacto;
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
	public String getOrigenOferta() {
		return origenOferta;
	}
	public void setOrigenOferta(String origenOferta) {
		this.origenOferta = origenOferta;
	}
	public Double getMesesCarencia() {
		return mesesCarencia;
	}
	public void setMesesCarencia(Double mesesCarencia) {
		this.mesesCarencia = mesesCarencia;
	}
	public Boolean getContratoReserva() {
		return contratoReserva;
	}
	public void setContratoReserva(Boolean contratoReserva) {
		this.contratoReserva = contratoReserva;
	}
	public String getMotivoCongelacion() {
		return motivoCongelacion;
	}
	public void setMotivoCongelacion(String motivoCongelacion) {
		this.motivoCongelacion = motivoCongelacion;
	}
	public Boolean getIbi() {
		return ibi;
	}
	public void setIbi(Boolean ibi) {
		this.ibi = ibi;
	}
	public Double getImporteIbi() {
		return importeIbi;
	}
	public void setImporteIbi(Double importeIbi) {
		this.importeIbi = importeIbi;
	}
	public Boolean getOtrasTasas() {
		return otrasTasas;
	}
	public void setOtrasTasas(Boolean otrasTasas) {
		this.otrasTasas = otrasTasas;
	}
	public Double getImporteOtrasTasas() {
		return importeOtrasTasas;
	}
	public void setImporteOtrasTasas(Double importeOtrasTasas) {
		this.importeOtrasTasas = importeOtrasTasas;
	}
	public Boolean getCcpp() {
		return ccpp;
	}
	public void setCcpp(Boolean ccpp) {
		this.ccpp = ccpp;
	}
	public Double getImporteCcpp() {
		return importeCcpp;
	}
	public void setImporteCcpp(Double importeCcpp) {
		this.importeCcpp = importeCcpp;
	}
	public Double getPorcentaje1anyo() {
		return porcentaje1anyo;
	}
	public void setPorcentaje1anyo(Double porcentaje1anyo) {
		this.porcentaje1anyo = porcentaje1anyo;
	}
	public Double getPorcentaje2anyo() {
		return porcentaje2anyo;
	}
	public void setPorcentaje2anyo(Double porcentaje2anyo) {
		this.porcentaje2anyo = porcentaje2anyo;
	}
	public Double getPorcentaje3anyo() {
		return porcentaje3anyo;
	}
	public void setPorcentaje3anyo(Double porcentaje3anyo) {
		this.porcentaje3anyo = porcentaje3anyo;
	}
	public Double getPorcentaje4anyo() {
		return porcentaje4anyo;
	}
	public void setPorcentaje4anyo(Double porcentaje4anyo) {
		this.porcentaje4anyo = porcentaje4anyo;
	}
	public Double getMesesCarenciaContraoferta() {
		return mesesCarenciaContraoferta;
	}
	public void setMesesCarenciaContraoferta(Double mesesCarenciaContraoferta) {
		this.mesesCarenciaContraoferta = mesesCarenciaContraoferta;
	}
	public Double getPorcentaje1anyoContraoferta() {
		return porcentaje1anyoContraoferta;
	}
	public void setPorcentaje1anyoContraoferta(Double porcentaje1anyoContraoferta) {
		this.porcentaje1anyoContraoferta = porcentaje1anyoContraoferta;
	}
	public Double getPorcentaje2anyoContraoferta() {
		return porcentaje2anyoContraoferta;
	}
	public void setPorcentaje2anyoContraoferta(Double porcentaje2anyoContraoferta) {
		this.porcentaje2anyoContraoferta = porcentaje2anyoContraoferta;
	}
	public Double getPorcentaje3anyoContraoferta() {
		return porcentaje3anyoContraoferta;
	}
	public void setPorcentaje3anyoContraoferta(Double porcentaje3anyoContraoferta) {
		this.porcentaje3anyoContraoferta = porcentaje3anyoContraoferta;
	}
	public Double getPorcentaje4anyoContraoferta() {
		return porcentaje4anyoContraoferta;
	}
	public void setPorcentaje4anyoContraoferta(Double porcentaje4anyoContraoferta) {
		this.porcentaje4anyoContraoferta = porcentaje4anyoContraoferta;
	}
	public String getEstadoOferta() {
		return estadoOferta;
	}
	public void setEstadoOferta(String estadoOferta) {
		this.estadoOferta = estadoOferta;
	}
	public String getSubestadoOferta() {
		return subestadoOferta;
	}
	public void setSubestadoOferta(String subestadoOferta) {
		this.subestadoOferta = subestadoOferta;
	}
}
