package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los datos básicos de una oferta.
 *
 * @author Jose Villel
 *
 */
public class DtoDatosBasicosOferta extends WebDto {



	/**
	 *
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	
    private Long idOferta;
    
    private Long idEco;
    
    private Long numOferta;
    
    private String tipoOfertaDescripcion;
    
    private String tipoOfertaCodigo;
    
    private Long numOferPrincipal;
    
    private String claseOfertaDescripcion;
    
    private String claseOfertaCodigo;
    
    private Long nuevoNumOferPrincipal;
    
    private Date fechaNotificacion;
    
    private Date fechaAlta;
    
    private String estadoDescripcion;
    
    private String estadoCodigo;
    
    private String prescriptor;
        
    private Double importeOferta;
    
    private Double importeContraOferta;
    
    private String comite;
    
    private String numVisita;   
    
    private String estadoVisitaOfertaCodigo;
    
    private String estadoVisitaOfertaDescripcion;
    
    private String canalPrescripcionCodigo;
    
    private String canalPrescripcionDescripcion;
    
    private String comiteSancionadorCodigo;
    
    private String comiteSancionadorCodigoAlquiler;
    
    private String comitePropuestoDescripcion;
    
    private String comitePropuestoCodigo;
   
	private String ofertaExpress;

	private String necesitaFinanciacion;

	private String observaciones;

	private String ventaCartera;

	private String tipoAlquilerCodigo;

	private String tipoInquilinoCodigo;

	private String numContratoPrinex;

	private String refCircuitoCliente;

	private Boolean permiteProponer;

	private Long idGestorComercialPrescriptor;

	private Double importeContraofertaCES;

  private Date fechaRespuestaCES;

	private Boolean isCarteraCerberusApple;
	private Boolean isCarteraLbkVenta;
	private Boolean isLbkOfertaComercialPrincipal;
	private Boolean muestraOfertaComercial;
	private Boolean isAdvisoryNoteEnTareas;

	private Double importeTotal;
	
	private Date fechaResolucionCES;

	private Date fechaRespuesta;
	
	private Double importeContraofertaOfertanteCES;
	
	private String ofertaSingular;
	
	private String exclusionBulk;
	
	private Boolean isCarteraCerberusDivarian;

	private String idAdvisoryNote;
	private Long tipoBulkAdvisoryNote;
	private Boolean tareaAdvisoryNoteFinalizada;
	
	
	private Boolean estadoAprobadoLbk;
	
	private String correoGestorBackoffice;

	private Boolean tareaAutorizacionPropiedadFinalizada;
	
	private String tipoResponsableCodigo;
	
	private Boolean isEmpleadoCaixa;

	private Boolean ofertaEspecial;
	
	private Boolean ventaSobrePlano;
	
	private String riesgoOperacionCodigo;
	
	private String riesgoOperacionDescripcion;
	
	private Boolean ventaCarteraCfv;
	
	private Boolean opcionACompra;
	
	private Double valorCompra;
	
	private Date fechaVencimientoOpcionCompra;
	
	private String clasificacionCodigo;

	private Boolean checkListDocumentalCompleto;

	private Boolean tieneInterlocutoresNoEnviados;
	
	private Boolean checkSubasta;
	
	private Long numeroContacto;
	
	public Boolean getEstadoAprobadoLbk() {
		return estadoAprobadoLbk;
	}

	public void setEstadoAprobadoLbk(Boolean estadoAprobadoLbk) {
		this.estadoAprobadoLbk = estadoAprobadoLbk;
	}
	
	public Long getTipoBulkAdvisoryNote() {
		return tipoBulkAdvisoryNote;
	}

	public void setTipoBulkAdvisoryNote(Long tipoBulkAdvisoryNote) {
		this.tipoBulkAdvisoryNote = tipoBulkAdvisoryNote;
	}

	public Long getIdOferta() {
		return idOferta;
	}

	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}

	public Long getNumOferta() {
		return numOferta;
	}

	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}

	public String getTipoOfertaDescripcion() {
		return tipoOfertaDescripcion;
	}

	public void setTipoOfertaDescripcion(String tipoOfertaDescripcion) {
		this.tipoOfertaDescripcion = tipoOfertaDescripcion;
	}
	public String getClaseOfertaDescripcion() {
		return claseOfertaDescripcion;
	}

	public void setClaseOfertaDescripcion(String claseOfertaDescripcion) {
		this.claseOfertaDescripcion = claseOfertaDescripcion;
	}

	public String getClaseOfertaCodigo() {
		return claseOfertaCodigo;
	}

	public void setClaseOfertaCodigo(String claseOfertaCodigo) {
		this.claseOfertaCodigo = claseOfertaCodigo;
	}


	public Long getNumOferPrincipal() {
		return numOferPrincipal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setNumOferPrincipal(Long numOferPrincipal) {
		this.numOferPrincipal = numOferPrincipal;
	}

	public Long getNuevoNumOferPrincipal() {
		return nuevoNumOferPrincipal;
	}
	
	public void setNuevoNumOferPrincipal(Long nuevoNumOferPrincipal) {
		this.nuevoNumOferPrincipal = nuevoNumOferPrincipal;
	}
	

	public Date getFechaNotificacion() {
		return fechaNotificacion;
	}

	public void setFechaNotificacion(Date fechaNotificacion) {
		this.fechaNotificacion = fechaNotificacion;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public String getEstadoDescripcion() {
		return estadoDescripcion;
	}

	public void setEstadoDescripcion(String estadoDescripcion) {
		this.estadoDescripcion = estadoDescripcion;
	}

	public String getPrescriptor() {
		return prescriptor;
	}

	public void setPrescriptor(String prescriptor) {
		this.prescriptor = prescriptor;
	}

	public Double getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(Double importeOferta) {
		this.importeOferta = importeOferta;
	}

	public Double getImporteContraOferta() {
		return importeContraOferta;
	}

	public void setImporteContraOferta(Double importeContraOferta) {
		this.importeContraOferta = importeContraOferta;
	}

	public String getComite() {
		return comite;
	}

	public void setComite(String comite) {
		this.comite = comite;
	}

	public String getNumVisita() {
		return numVisita;
	}

	public void setNumVisita(String numVisita) {
		this.numVisita = numVisita;
	}

	public String getEstadoVisitaOfertaCodigo() {
		return estadoVisitaOfertaCodigo;
	}

	public void setEstadoVisitaOfertaCodigo(String estadoVisitaOfertaCodigo) {
		this.estadoVisitaOfertaCodigo = estadoVisitaOfertaCodigo;
	}

	public String getEstadoVisitaOfertaDescripcion() {
		return estadoVisitaOfertaDescripcion;
	}

	public void setEstadoVisitaOfertaDescripcion(
			String estadoVisitaOfertaDescripcion) {
		this.estadoVisitaOfertaDescripcion = estadoVisitaOfertaDescripcion;
	}

	public String getTipoOfertaCodigo() {
		return tipoOfertaCodigo;
	}

	public void setTipoOfertaCodigo(String tipoOfertaCodigo) {
		this.tipoOfertaCodigo = tipoOfertaCodigo;
	}

	public String getEstadoCodigo() {
		return estadoCodigo;
	}

	public void setEstadoCodigo(String estadoCodigo) {
		this.estadoCodigo = estadoCodigo;
	}

	public String getCanalPrescripcionCodigo() {
		return canalPrescripcionCodigo;
	}

	public void setCanalPrescripcionCodigo(String canalPrescripcionCodigo) {
		this.canalPrescripcionCodigo = canalPrescripcionCodigo;
	}

	public String getCanalPrescripcionDescripcion() {
		return canalPrescripcionDescripcion;
	}

	public void setCanalPrescripcionDescripcion(String canalPrescripcionDescripcion) {
		this.canalPrescripcionDescripcion = canalPrescripcionDescripcion;
	}

	public String getComiteSancionadorCodigo() {
		return comiteSancionadorCodigo;
	}

	public void setComiteSancionadorCodigo(String comiteSancionadorCodigo) {
		this.comiteSancionadorCodigo = comiteSancionadorCodigo;
	}

	public String getComitePropuestoDescripcion() {
		return comitePropuestoDescripcion;
	}

	public void setComitePropuestoDescripcion(String comitePropuestoDescripcion) {
		this.comitePropuestoDescripcion = comitePropuestoDescripcion;
	}

	public String getComitePropuestoCodigo() {
		return comitePropuestoCodigo;
	}

	public void setComitePropuestoCodigo(String comitePropuestoCodigo) {
		this.comitePropuestoCodigo = comitePropuestoCodigo;
	}

	public String getOfertaExpress() {
		return ofertaExpress;
	}

	public void setOfertaExpress(String ofertaExpress) {
		this.ofertaExpress = ofertaExpress;
	}

	public String getNecesitaFinanciacion() {
		return necesitaFinanciacion;
	}

	public void setNecesitaFinanciacion(String necesitaFinanciacion) {
		this.necesitaFinanciacion = necesitaFinanciacion;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getVentaCartera() {
		return ventaCartera;
	}

	public void setVentaCartera(String ventaCartera) {
		this.ventaCartera = ventaCartera;
	}

	public Boolean getPermiteProponer() {
		return permiteProponer;
	}

	public void setPermiteProponer(Boolean permiteProponer) {
		this.permiteProponer = permiteProponer;
	}

	public String getTipoAlquilerCodigo() {
		return tipoAlquilerCodigo;
	}

	public void setTipoAlquilerCodigo(String tipoAlquilerDescripcion) {
		this.tipoAlquilerCodigo = tipoAlquilerDescripcion;
	}

	public String getTipoInquilinoCodigo() {
		return tipoInquilinoCodigo;
	}

	public void setTipoInquilinoCodigo(String tipoInquilinoDescripcion) {
		this.tipoInquilinoCodigo = tipoInquilinoDescripcion;
	}

	public String getNumContratoPrinex() {
		return numContratoPrinex;
	}

	public void setNumContratoPrinex(String numContratoPrinex) {
		this.numContratoPrinex = numContratoPrinex;
	}

	public String getRefCircuitoCliente() {
		return refCircuitoCliente;
	}

	public void setRefCircuitoCliente(String refCircuitoCliente) {
		this.refCircuitoCliente = refCircuitoCliente;
	}

	public String getComiteSancionadorCodigoAlquiler() {
		return comiteSancionadorCodigoAlquiler;
	}

	public void setComiteSancionadorCodigoAlquiler(String comiteSancionadorCodigoAlquiler) {
		this.comiteSancionadorCodigoAlquiler = comiteSancionadorCodigoAlquiler;
	}

	public Long getIdEco() {
		return idEco;
	}

	public void setIdEco(Long idEco) {
		this.idEco = idEco;
	}
	public Long getIdGestorComercialPrescriptor() {
		return idGestorComercialPrescriptor;
	}

	public void setIdGestorComercialPrescriptor(Long idGestorComercialPrescriptor) {
		this.idGestorComercialPrescriptor = idGestorComercialPrescriptor;
	}

	public Double getImporteContraofertaCES() {
		return importeContraofertaCES;
	}

	public void setImporteContraofertaCES(Double importeContraofertaCES) {
		this.importeContraofertaCES = importeContraofertaCES;
	}

	public Date getFechaResolucionCES() {
		return fechaResolucionCES;
	}

	public void setFechaResolucionCES(Date fechaResolucionCES) {
		this.fechaResolucionCES = fechaResolucionCES;
	}

	public Date getFechaRespuestaCES() {
		return fechaRespuestaCES;
	}

	public void setFechaRespuestaCES(Date fechaRespuestaCES) {
		this.fechaRespuestaCES = fechaRespuestaCES;
	}

	public Boolean getIsCarteraCerberusApple() {
		return isCarteraCerberusApple;
	}

	public void setIsCarteraCerberusApple(Boolean isCarteraCerberusApple) {
		this.isCarteraCerberusApple = isCarteraCerberusApple;
	}
	
	public Boolean getIsCarteraLbkVenta() {
		return isCarteraLbkVenta;
	}

	public void setIsCarteraLbkVenta(Boolean isCarteraLbkVenta) {
		this.isCarteraLbkVenta = isCarteraLbkVenta;
	}

	public Boolean getIsLbkOfertaComercialPrincipal() {
		return isLbkOfertaComercialPrincipal;
	}

	public void setIsLbkOfertaComercialPrincipal(Boolean isLbkOfertaComercialPrincipal) {
		this.isLbkOfertaComercialPrincipal = isLbkOfertaComercialPrincipal;
	}

	public Boolean getMuestraOfertaComercial() {
		return muestraOfertaComercial;
	}

	public void setMuestraOfertaComercial(Boolean muestraOfertaComercial) {
		this.muestraOfertaComercial = muestraOfertaComercial;
	}

	public Date getFechaRespuesta() {
		return fechaRespuesta;
	}

	public void setFechaRespuesta(Date fechaRespuesta) {
		this.fechaRespuesta = fechaRespuesta;
	}

	public Double getImporteContraofertaOfertanteCES() {
		return importeContraofertaOfertanteCES;
	}

	public void setImporteContraofertaOfertanteCES(Double importeContraofertaOfertanteCES) {
		this.importeContraofertaOfertanteCES = importeContraofertaOfertanteCES;
	}
	
	public String getOfertaSingular() {
		return ofertaSingular;
	}

	public void setOfertaSingular(String ofertaSingular) {
		this.ofertaSingular = ofertaSingular;
	}

	public Boolean getIsCarteraCerberusDivarian() {
		return isCarteraCerberusDivarian;
	}

	public void setIsCarteraCerberusDivarian(Boolean isCarteraCerberusDivarian) {
		this.isCarteraCerberusDivarian = isCarteraCerberusDivarian;
	}

	public String getExclusionBulk() {
		return exclusionBulk;
	}

	public void setExclusionBulk(String exclusionBulk) {
		this.exclusionBulk = exclusionBulk;
	}

	public Boolean getIsAdvisoryNoteEnTareas() {
		return isAdvisoryNoteEnTareas;
	}

	public void setIsAdvisoryNoteEnTareas(Boolean isAdvisoryNoteEnTareas) {
		this.isAdvisoryNoteEnTareas = isAdvisoryNoteEnTareas;
	}

	public String getIdAdvisoryNote() {
		return idAdvisoryNote;
	}

	public void setIdAdvisoryNote(String idAdvisoryNote) {
		this.idAdvisoryNote = idAdvisoryNote;
	}

	public Boolean getTareaAdvisoryNoteFinalizada() {
		return tareaAdvisoryNoteFinalizada;
	}

	public void setTareaAdvisoryNoteFinalizada(Boolean tareaAdvisoryNoteFinalizada) {
		this.tareaAdvisoryNoteFinalizada = tareaAdvisoryNoteFinalizada;
	}

	public String getCorreoGestorBackoffice() {
		return correoGestorBackoffice;
	}

	public void setCorreoGestorBackoffice(String correoGestorBackoffice) {
		this.correoGestorBackoffice = correoGestorBackoffice;
	}
	
	public void setTareaAutorizacionPropiedadFinalizada(Boolean tieneTareaFinalizada) {
		this.tareaAutorizacionPropiedadFinalizada = tieneTareaFinalizada;
		
	}
	
	public Boolean getTareaAutorizacionPropiedadFinalizada() {
		return this.tareaAutorizacionPropiedadFinalizada;
	}
	
	public String getTipoResponsableCodigo() {
		return tipoResponsableCodigo;
	}

	public void setTipoResponsableCodigo(String tipoResponsableCodigo) {
		this.tipoResponsableCodigo = tipoResponsableCodigo;
	}

	public Boolean getIsEmpleadoCaixa() {
		return isEmpleadoCaixa;
	}

	public void setIsEmpleadoCaixa(Boolean isEmpleadoCaixa) {
		this.isEmpleadoCaixa = isEmpleadoCaixa;
	}
	
	public Boolean getOfertaEspecial() {
		return ofertaEspecial;
	}

	public void setOfertaEspecial(Boolean ofertaEspecial) {
		this.ofertaEspecial = ofertaEspecial;
	}
	
	public Boolean getVentaSobrePlano() {
		return ventaSobrePlano;
	}

	public void setVentaSobrePlano(Boolean ventaSobrePlano) {
		this.ventaSobrePlano = ventaSobrePlano;
	}
	
	public String getRiesgoOperacionCodigo() {
		return riesgoOperacionCodigo;
	}

	public void setRiesgoOperacionCodigo(String riesgoOperacionCodigo) {
		this.riesgoOperacionCodigo = riesgoOperacionCodigo;
	}
	
	public String getRiesgoOperacionDescripcion() {
		return riesgoOperacionDescripcion;
	}

	public void setRiesgoOperacionDescripcion(String riesgoOperacionDescripcion) {
		this.riesgoOperacionDescripcion = riesgoOperacionDescripcion;
	}
	
	public Boolean getVentaCarteraCfv() {
		return ventaCarteraCfv;
	}

	public void setVentaCarteraCfv(Boolean ventaCarteraCfv) {
		this.ventaCarteraCfv = ventaCarteraCfv;
	}

	public Boolean getOpcionACompra() {
		return opcionACompra;
	}

	public void setOpcionACompra(Boolean opcionACompra) {
		this.opcionACompra = opcionACompra;
	}

	public Double getValorCompra() {
		return valorCompra;
	}

	public void setValorCompra(Double valorCompra) {
		this.valorCompra = valorCompra;
	}

	public Date getFechaVencimientoOpcionCompra() {
		return fechaVencimientoOpcionCompra;
	}

	public void setFechaVencimientoOpcionCompra(Date fechaVencimientoOpcionCompra) {
		this.fechaVencimientoOpcionCompra = fechaVencimientoOpcionCompra;
	}

	public String getClasificacionCodigo() {
		return clasificacionCodigo;
	}

	public void setClasificacionCodigo(String clasificacionCodigo) {
		this.clasificacionCodigo = clasificacionCodigo;
	}

	public Boolean getCheckListDocumentalCompleto() {
		return checkListDocumentalCompleto;
	}

	public void setCheckListDocumentalCompleto(Boolean checkListDocumentalCompleto) {
		this.checkListDocumentalCompleto = checkListDocumentalCompleto;
	}

	public Boolean getTieneInterlocutoresNoEnviados() {
		return tieneInterlocutoresNoEnviados;
	}

	public void setTieneInterlocutoresNoEnviados(Boolean tieneInterlocutoresNoEnviados) {
		this.tieneInterlocutoresNoEnviados = tieneInterlocutoresNoEnviados;
	}

	public Boolean getCheckSubasta() {
		return checkSubasta;
	}

	public void setCheckSubasta(Boolean checkSubasta) {
		this.checkSubasta = checkSubasta;
	}

	public Long getNumeroContacto() {
		return numeroContacto;
	}

	public void setNumeroContacto(Long numeroContacto) {
		this.numeroContacto = numeroContacto;
	}
	
}
