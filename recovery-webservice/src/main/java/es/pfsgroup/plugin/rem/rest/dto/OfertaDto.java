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
import es.pfsgroup.plugin.rem.model.dd.DDRespuestaOfertante;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSocioComercial;
import es.pfsgroup.plugin.rem.model.dd.DDVinculoCaixa;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadFinanciera;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoJustificacionOferta;
import es.pfsgroup.plugin.rem.model.dd.DDRecomendacionRCDC;
import es.pfsgroup.plugin.rem.model.dd.DDRespuestaOfertante;
import es.pfsgroup.plugin.rem.model.dd.DDSnsSiNoNosabe;
import es.pfsgroup.plugin.rem.model.dd.DDTfnTipoFinanciacion;
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
	@Diccionary(clase = DDSnsSiNoNosabe.class, message = "El codigo DDSnsSiNoNosabe no existe", groups = { Insert.class,
			Update.class },foreingField="codigo")
	@Size(max=20,groups = { Insert.class, Update.class })
	private String financiacion;
	@NotNull(groups = {Insert.class})
	private Boolean isExpress;
	private String codTarea;
	@Diccionary(clase = DDRespuestaOfertante.class, message = "El codigo DDRespuestaOfertante no existe", groups = { Insert.class,
			Update.class },foreingField="codigo")
	@Size(max=20,groups = { Insert.class, Update.class })
	private String aceptacionContraoferta;
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
	@Diccionary(clase = DDRespuestaOfertante.class, message = "El codigo recomendacionRC no existe", groups = { Insert.class,
			Update.class },foreingField="codigo")
	@Size(max=20,groups = { Insert.class, Update.class })
	private String recomendacionRC;
	private Date fechaRecomendacionRC;
	@Diccionary(clase = DDRespuestaOfertante.class, message = "El codigo recomendacionDC no existe", groups = { Insert.class,
			Update.class },foreingField="codigo")
	@Size(max=20,groups = { Insert.class, Update.class })
	private String recomendacionDC;
	private Date fechaRecomendacionDC;
	private String documentoIdentificativo;
	private String nombreDocumentoIdentificativo;
	private String documentoGDPR;
	private String nombreDocumentoGDPR;
	private Boolean docResponsabilidadPrescriptor;
	private String porcentajeDescuento;
	private String justificacionOferta;
	private String codOrigenOferta;
	private Double mesesCarencia;
	private Boolean tieneContratoReserva;
	private String motivoCongelacion;
	private Boolean tieneIBI;
	private Double importeIBI; 
	private Boolean tieneOtrasTasas;
	private Double importeOtrasTasas;
	private Boolean tieneCCPP;
	private Double importeCCPP;
	private Double bonificacionAnyo1;
	private Double bonificacionAnyo2;
	private Double bonificacionAnyo3;
	private Double bonificacionAnyo4;
	private Double mesesCarenciaContraoferta;
	private Double bonificacionAnyo1Contraoferta;
	private Double bonificacionAnyo2Contraoferta;
	private Double bonificacionAnyo3Contraoferta;
	private Double bonificacionAnyo4Contraoferta;
	private String codEstadoExpediente;
	private String codSubestadoExpediente;
	private String codOfertaSalesforce;
	private String idOfertaSalesforce;
	private Date fechaAcepGdpr;
	@Diccionary(clase = DDVinculoCaixa.class, message = "El vinculoCaixa no existe")
	private String vinculoCaixa;	
	@Diccionary(clase = DDTipoSocioComercial.class, message = "El sociedadEmpleadoGrupoCaixa no existe")
	private String sociedadEmpleadoGrupoCaixa;
	@IsNumber(message = "Debe ser un número")
	private Integer oficinaEmpleadoCaixa;
	private Boolean esAntiguoDeudor;
	private Date fechaCreacion;
	private String recomendacionObservaciones;
	private String importeInicial;
	private String importeContraofertaRCDC;
	private String importeContraofertaPrescriptor;
	@Diccionary(clase = DDRecomendacionRCDC.class, message = "El codigo recomendacionRequerida no existe", groups = { Insert.class,
			Update.class },foreingField="codigo")
	@Size(max=20,groups = { Insert.class, Update.class })
	private String recomendacionRequerida;
	private Boolean recomendacionCumplimentada;
	private Boolean titularesConfirmados;
	private Boolean aceptacionOfertaTPrincipal;
	@Diccionary(clase = DDTfnTipoFinanciacion.class, message = "El codigo DDTfnTipoFinanciacion no existe", groups = { Insert.class,
			Update.class },foreingField="codigo")
	@Size(max=20,groups = { Insert.class, Update.class })
	private String tipoFinanciacion;
	@Diccionary(clase = DDEntidadFinanciera.class, message = "El codigo DDEntidadFinanciera no existe", groups = { Insert.class,
			Update.class },foreingField="codigoSF")
	@Size(max=20,groups = { Insert.class, Update.class })
	private String entidadFinanciacion;
	@Diccionary(clase = DDMotivoJustificacionOferta.class, message = "El codigo DDMotivoJustificacionOferta no existe", groups = { Insert.class,
			Update.class },foreingField="codigo")
	@Size(max=20,groups = { Insert.class, Update.class })
	private String codMotivoJustificacionOferta;
	private List<TestigosOfertaDto> testigos;
	
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
	public String getFinanciacion() {
		return financiacion;
	}
	public void setFinanciacion(String financiacion) {
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
	public String getAceptacionContraoferta() {
		return aceptacionContraoferta;
	}
	public void setAceptacionContraoferta(String aceptacionContraoferta) {
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
	public String getRecomendacionRC() {
		return recomendacionRC;
	}
	public void setRecomendacionRC(String recomendacionRC) {
		this.recomendacionRC = recomendacionRC;
	}
	public Date getFechaRecomendacionRC() {
		return fechaRecomendacionRC;
	}
	public void setFechaRecomendacionRC(Date fechaRecomendacionRC) {
		this.fechaRecomendacionRC = fechaRecomendacionRC;
	}
	public String getRecomendacionDC() {
		return recomendacionDC;
	}
	public void setRecomendacionDC(String recomendacionDC) {
		this.recomendacionDC = recomendacionDC;
	}
	public Date getFechaRecomendacionDC() {
		return fechaRecomendacionDC;
	}
	public void setFechaRecomendacionDC(Date fechaRecomendacionDC) {
		this.fechaRecomendacionDC = fechaRecomendacionDC;
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
	public String getCodOrigenOferta() {
		return codOrigenOferta;
	}
	public void setCodOrigenOferta(String codOrigenOferta) {
		this.codOrigenOferta = codOrigenOferta;
	}
	public Double getMesesCarencia() {
		return mesesCarencia;
	}
	public void setMesesCarencia(Double mesesCarencia) {
		this.mesesCarencia = mesesCarencia;
	}
	public Boolean getTieneContratoReserva() {
		return tieneContratoReserva;
	}
	public void setTieneContratoReserva(Boolean tieneContratoReserva) {
		this.tieneContratoReserva = tieneContratoReserva;
	}
	public String getMotivoCongelacion() {
		return motivoCongelacion;
	}
	public void setMotivoCongelacion(String motivoCongelacion) {
		this.motivoCongelacion = motivoCongelacion;
	}
	public Boolean getTieneIBI() {
		return tieneIBI;
	}
	public void setTieneIBI(Boolean tieneIBI) {
		this.tieneIBI = tieneIBI;
	}
	public Double getImporteIBI() {
		return importeIBI;
	}
	public void setImporteIBI(Double importeIBI) {
		this.importeIBI = importeIBI;
	}
	public Boolean getTieneOtrasTasas() {
		return tieneOtrasTasas;
	}
	public void setTieneOtrasTasas(Boolean tieneOtrasTasas) {
		this.tieneOtrasTasas = tieneOtrasTasas;
	}
	public Double getImporteOtrasTasas() {
		return importeOtrasTasas;
	}
	public void setImporteOtrasTasas(Double importeOtrasTasas) {
		this.importeOtrasTasas = importeOtrasTasas;
	}
	public Boolean getTieneCCPP() {
		return tieneCCPP;
	}
	public void setTieneCCPP(Boolean tieneCCPP) {
		this.tieneCCPP = tieneCCPP;
	}
	public Double getImporteCCPP() {
		return importeCCPP;
	}
	public void setImporteCCPP(Double importeCCPP) {
		this.importeCCPP = importeCCPP;
	}
	public Double getBonificacionAnyo1() {
		return bonificacionAnyo1;
	}
	public void setBonificacionAnyo1(Double bonificacionAnyo1) {
		this.bonificacionAnyo1 = bonificacionAnyo1;
	}
	public Double getBonificacionAnyo2() {
		return bonificacionAnyo2;
	}
	public void setBonificacionAnyo2(Double bonificacionAnyo2) {
		this.bonificacionAnyo2 = bonificacionAnyo2;
	}
	public Double getBonificacionAnyo3() {
		return bonificacionAnyo3;
	}
	public void setBonificacionAnyo3(Double bonificacionAnyo3) {
		this.bonificacionAnyo3 = bonificacionAnyo3;
	}
	public Double getBonificacionAnyo4() {
		return bonificacionAnyo4;
	}
	public void setBonificacionAnyo4(Double bonificacionAnyo4) {
		this.bonificacionAnyo4 = bonificacionAnyo4;
	}
	public Double getMesesCarenciaContraoferta() {
		return mesesCarenciaContraoferta;
	}
	public void setMesesCarenciaContraoferta(Double mesesCarenciaContraoferta) {
		this.mesesCarenciaContraoferta = mesesCarenciaContraoferta;
	}
	public Double getBonificacionAnyo1Contraoferta() {
		return bonificacionAnyo1Contraoferta;
	}
	public void setBonificacionAnyo1Contraoferta(Double bonificacionAnyo1Contraoferta) {
		this.bonificacionAnyo1Contraoferta = bonificacionAnyo1Contraoferta;
	}
	public Double getBonificacionAnyo2Contraoferta() {
		return bonificacionAnyo2Contraoferta;
	}
	public void setBonificacionAnyo2Contraoferta(Double bonificacionAnyo2Contraoferta) {
		this.bonificacionAnyo2Contraoferta = bonificacionAnyo2Contraoferta;
	}
	public Double getBonificacionAnyo3Contraoferta() {
		return bonificacionAnyo3Contraoferta;
	}
	public void setBonificacionAnyo3Contraoferta(Double bonificacionAnyo3Contraoferta) {
		this.bonificacionAnyo3Contraoferta = bonificacionAnyo3Contraoferta;
	}
	public Double getBonificacionAnyo4Contraoferta() {
		return bonificacionAnyo4Contraoferta;
	}
	public void setBonificacionAnyo4Contraoferta(Double bonificacionAnyo4Contraoferta) {
		this.bonificacionAnyo4Contraoferta = bonificacionAnyo4Contraoferta;
	}
	public String getCodEstadoExpediente() {
		return codEstadoExpediente;
	}
	public void setCodEstadoExpediente(String estadoOferta) {
		this.codEstadoExpediente = estadoOferta;
	}
	public String getcodSubestadoExpediente() {
		return codSubestadoExpediente;
	}
	public void setcodSubestadoExpediente(String codSubestadoExpediente) {
		this.codSubestadoExpediente = codSubestadoExpediente;
	}
	public String getCodOfertaSalesforce() {
		return codOfertaSalesforce;
	}
	public void setCodOfertaSalesforce(String codOfertaSalesforce) {
		this.codOfertaSalesforce = codOfertaSalesforce;
	}
	public String getIdOfertaSalesforce() {
		return idOfertaSalesforce;
	}
	public void setIdOfertaSalesforce(String idOfertaSalesforce) {
		this.idOfertaSalesforce = idOfertaSalesforce;
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

	public Date getFechaCreacion() {
		return fechaCreacion;
	}

	public void setFechaCreacion(Date fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}
	
	public String getRecomendacionObservaciones() {
		return recomendacionObservaciones;
	}
	public void setRecomendacionObservaciones(String recomendacionObservaciones) {
		this.recomendacionObservaciones = recomendacionObservaciones;
	}
	public String getTipoFinanciacion() {
		return tipoFinanciacion;
	}
	public void setTipoFinanciacion(String tipoFinanciacion) {
		this.tipoFinanciacion = tipoFinanciacion;
	}
	public String getEntidadFinanciacion() {
		return entidadFinanciacion;
	}
	public void setEntidadFinanciacion(String entidadFinanciacion) {
		this.entidadFinanciacion = entidadFinanciacion;
	}
	public String getCodMotivoJustificacionOferta() {
		return codMotivoJustificacionOferta;
	}
	public void setCodMotivoJustificacionOferta(String codMotivoJustificacionOferta) {
		this.codMotivoJustificacionOferta = codMotivoJustificacionOferta;
	}
	public List<TestigosOfertaDto> getTestigos() {
		return testigos;
	}
	public void setTestigos(List<TestigosOfertaDto> testigos) {
		this.testigos = testigos;
	}
	public String getImporteInicial() {
		return importeInicial;
	}
	public void setImporteInicial(String importeInicial) {
		this.importeInicial = importeInicial;
	}
	public String getImporteContraofertaRCDC() {
		return importeContraofertaRCDC;
	}
	public void setImporteContraofertaRCDC(String importeContraofertaRCDC) {
		this.importeContraofertaRCDC = importeContraofertaRCDC;
	}
	public String getImporteContraofertaPrescriptor() {
		return importeContraofertaPrescriptor;
	}
	public void setImporteContraofertaPrescriptor(String importeContraofertaPrescriptor) {
		this.importeContraofertaPrescriptor = importeContraofertaPrescriptor;
	}
	public String getRecomendacionRequerida() {
		return recomendacionRequerida;
	}
	public void setRecomendacionRequerida(String recomendacionRequerida) {
		this.recomendacionRequerida = recomendacionRequerida;
	}
	public Boolean getRecomendacionCumplimentada() {
		return recomendacionCumplimentada;
	}
	public void setRecomendacionCumplimentada(Boolean recomendacionCumplimentada) {
		this.recomendacionCumplimentada = recomendacionCumplimentada;
	}
	public Boolean getTitularesConfirmados() {
		return titularesConfirmados;
	}
	public void setTitularesConfirmados(Boolean titularesConfirmados) {
		this.titularesConfirmados = titularesConfirmados;
	}
	public Boolean getAceptacionOfertaTPrincipal() {
		return aceptacionOfertaTPrincipal;
	}
	public void setAceptacionOfertaTPrincipal(Boolean aceptacionOfertaTPrincipal) {
		this.aceptacionOfertaTPrincipal = aceptacionOfertaTPrincipal;
	}
}
