package es.pfsgroup.plugin.rem.model;

import java.util.Date;



/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoActivoInformacionAdministrativa extends DtoTabActivo {

	private static final long serialVersionUID = 0L;

	private String numeroActivo;
	/*private String refCatastral;
	private String poligono;
	private String parcela;
	private String titularCatastral;
	private String superficieConstruida;
	private String superficieUtil;
	private String superficieReperComun;
	private String superficieParcela;
	private String superficieSuelo;
	private String valorCatastralConst;	
	private String valorCatastralSuelo;
	private Date fechaRevValorCat;*/
	private String sueloVpo;
	private String promocionVpo;
	private String numExpediente;
	private Date fechaCalificacion;
	private Integer obligatorioSolDevAyuda;
	private Integer obligatorioAutAdmVenta;
	private Integer descalificado;
	private Integer sujetoAExpediente;
	private String organismoExpropiante;
	private Date fechaInicioExpediente;
	private String refExpedienteAdmin;
	private String refExpedienteInterno;
	private String observacionesExpropiacion;
	private String maxPrecioVenta;
	private String maxPrecioModuloAlquiler;
	private String observaciones;
	
	private Date vigencia;
	private Integer comunicarAdquisicion;
	private Integer necesarioInscribirVpo;
	private Integer libertadCesion;
	private Integer renunciaTanteoRetrac;
	private Integer visaContratoPriv;
	private Integer venderPersonaJuridica;
	private Integer minusvalia;
	private Integer inscripcionRegistroDemVpo;
	private Integer ingresosInfNivel;
	private Integer residenciaComAutonoma;
	private Integer noTitularOtraVivienda;
	
	private String tipoVpoId;
	private String tipoVpoCodigo;    
	private String tipoVpoDescripcion;
	private String tipoVpoDescripcionLarga;	
	private Integer vpo;
	
	private String tributacionAdq;
	private String tributacionAdqDescripcion;
	private Date fechaVencTpoBonificacion;
	private Date fechaLiqComplementaria;

	private Date fechaSoliCertificado;
	private Date fechaComAdquisicion;
	private Date fechaComRegDemandantes;
	private Long actualizaPrecioMaxId;
	private Date fechaVencimiento;
	
	private Date fechaEnvioComunicacionOrganismo;
	private Date fechaRecepcionRespuestaOrganismo;
	private String estadoVentaCodigo;
	private String estadoVentaDescripcion;
	
	private Boolean compradorAcojeAyuda;
	private Double importeAyudaFinanciacion;
	private Date fechaVencimientoAvalSeguro;
	private Date fechaDevolucionAyuda;
	
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}
	
	public String getSueloVpo() {
		return sueloVpo;
	}
	public void setSueloVpo(String sueloVpo) {
		this.sueloVpo = sueloVpo;
	}
	public String getPromocionVpo() {
		return promocionVpo;
	}
	public void setPromocionVpo(String promocionVpo) {
		this.promocionVpo = promocionVpo;
	}
	public String getNumExpediente() {
		return numExpediente;
	}
	public void setNumExpediente(String numExpediente) {
		this.numExpediente = numExpediente;
	}
	public Date getFechaCalificacion() {
		return fechaCalificacion;
	}
	public void setFechaCalificacion(Date fechaCalificacion) {
		this.fechaCalificacion = fechaCalificacion;
	}
	public Integer getObligatorioSolDevAyuda() {
		return obligatorioSolDevAyuda;
	}
	public void setObligatorioSolDevAyuda(Integer obligatorioSolDevAyuda) {
		this.obligatorioSolDevAyuda = obligatorioSolDevAyuda;
	}
	public Integer getObligatorioAutAdmVenta() {
		return obligatorioAutAdmVenta;
	}
	public void setObligatorioAutAdmVenta(Integer obligatorioAutAdmVenta) {
		this.obligatorioAutAdmVenta = obligatorioAutAdmVenta;
	}
	public Integer getDescalificado() {
		return descalificado;
	}
	public void setDescalificado(Integer descalificado) {
		this.descalificado = descalificado;
	}
	public String getMaxPrecioVenta() {
		return maxPrecioVenta;
	}
	public void setMaxPrecioVenta(String maxPrecioVenta) {
		this.maxPrecioVenta = maxPrecioVenta;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getTipoVpoCodigo() {
		return tipoVpoCodigo;
	}
	public void setTipoVpoCodigo(String tipoVpoCodigo) {
		this.tipoVpoCodigo = tipoVpoCodigo;
	}
	public String getTipoVpoDescripcion() {
		return tipoVpoDescripcion;
	}
	public void setTipoVpoDescripcion(String tipoVpoDescripcion) {
		this.tipoVpoDescripcion = tipoVpoDescripcion;
	}
	public String getTipoVpoDescripcionLarga() {
		return tipoVpoDescripcionLarga;
	}
	public void setTipoVpoDescripcionLarga(String tipoVpoDescripcionLarga) {
		this.tipoVpoDescripcionLarga = tipoVpoDescripcionLarga;
	}
	public String getTipoVpoId() {
		return tipoVpoId;
	}
	public void setTipoVpoId(String tipoVpoId) {
		this.tipoVpoId = tipoVpoId;
	}
	public Integer getVpo() {
		return vpo;
	}
	public void setVpo(Integer vpo) {
		this.vpo = vpo;
	}
	public Integer getSujetoAExpediente() {
		return sujetoAExpediente;
	}
	public void setSujetoAExpediente(Integer sujetoAExpediente) {
		this.sujetoAExpediente = sujetoAExpediente;
	}
	public Date getFechaInicioExpediente() {
		return fechaInicioExpediente;
	}
	public void setFechaInicioExpediente(Date fechaInicioExpediente) {
		this.fechaInicioExpediente = fechaInicioExpediente;
	}
	public String getOrganismoExpropiante() {
		return organismoExpropiante;
	}
	public void setOrganismoExpropiante(String organismoExpropiante) {
		this.organismoExpropiante = organismoExpropiante;
	}
	public String getRefExpedienteAdmin() {
		return refExpedienteAdmin;
	}
	public void setRefExpedienteAdmin(String refExperienciaAdmin) {
		this.refExpedienteAdmin = refExperienciaAdmin;
	}
	public String getRefExpedienteInterno() {
		return refExpedienteInterno;
	}
	public void setRefExpedienteInterno(String refExpedienteInterno) {
		this.refExpedienteInterno = refExpedienteInterno;
	}
	public String getObservacionesExpropiacion() {
		return observacionesExpropiacion;
	}
	public void setObservacionesExpropiacion(String observacionesExpropiacion) {
		this.observacionesExpropiacion = observacionesExpropiacion;
	}
	public Date getVigencia() {
		return vigencia;
	}
	public void setVigencia(Date vigencia) {
		this.vigencia = vigencia;
	}
	public Integer getComunicarAdquisicion() {
		return comunicarAdquisicion;
	}
	public void setComunicarAdquisicion(Integer comunicarAdquisicion) {
		this.comunicarAdquisicion = comunicarAdquisicion;
	}
	public Integer getNecesarioInscribirVpo() {
		return necesarioInscribirVpo;
	}
	public void setNecesarioInscribirVpo(Integer necesarioInscribirVpo) {
		this.necesarioInscribirVpo = necesarioInscribirVpo;
	}
	public Integer getLibertadCesion() {
		return libertadCesion;
	}
	public void setLibertadCesion(Integer libertadCesion) {
		this.libertadCesion = libertadCesion;
	}
	public Integer getRenunciaTanteoRetrac() {
		return renunciaTanteoRetrac;
	}
	public void setRenunciaTanteoRetrac(Integer renunciaTanteoRetrac) {
		this.renunciaTanteoRetrac = renunciaTanteoRetrac;
	}
	public Integer getVisaContratoPriv() {
		return visaContratoPriv;
	}
	public void setVisaContratoPriv(Integer visaContratoPriv) {
		this.visaContratoPriv = visaContratoPriv;
	}
	public Integer getVenderPersonaJuridica() {
		return venderPersonaJuridica;
	}
	public void setVenderPersonaJuridica(Integer venderPersonaJuridica) {
		this.venderPersonaJuridica = venderPersonaJuridica;
	}
	public Integer getMinusvalia() {
		return minusvalia;
	}
	public void setMinusvalia(Integer minusvalia) {
		this.minusvalia = minusvalia;
	}
	public Integer getInscripcionRegistroDemVpo() {
		return inscripcionRegistroDemVpo;
	}
	public void setInscripcionRegistroDemVpo(Integer inscripcionRegistroDemVpo) {
		this.inscripcionRegistroDemVpo = inscripcionRegistroDemVpo;
	}
	public Integer getIngresosInfNivel() {
		return ingresosInfNivel;
	}
	public void setIngresosInfNivel(Integer ingresosInfNivel) {
		this.ingresosInfNivel = ingresosInfNivel;
	}
	public Integer getResidenciaComAutonoma() {
		return residenciaComAutonoma;
	}
	public void setResidenciaComAutonoma(Integer residenciaComAutonoma) {
		this.residenciaComAutonoma = residenciaComAutonoma;
	}
	public Integer getNoTitularOtraVivienda() {
		return noTitularOtraVivienda;
	}
	public void setNoTitularOtraVivienda(Integer noTitularOtraVivienda) {
		this.noTitularOtraVivienda = noTitularOtraVivienda;
	}
	public Date getFechaSoliCertificado() {
		return fechaSoliCertificado;
	}
	public void setFechaSoliCertificado(Date fechaSoliCertificado) {
		this.fechaSoliCertificado = fechaSoliCertificado;
	}
	public Date getFechaComAdquisicion() {
		return fechaComAdquisicion;
	}
	public void setFechaComAdquisicion(Date fechaComAdquisicion) {
		this.fechaComAdquisicion = fechaComAdquisicion;
	}
	public Date getFechaComRegDemandantes() {
		return fechaComRegDemandantes;
	}
	public void setFechaComRegDemandantes(Date fechaComRegDemandantes) {
		this.fechaComRegDemandantes = fechaComRegDemandantes;
	}
	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public Long getActualizaPrecioMaxId() {
		return actualizaPrecioMaxId;
	}
	public void setActualizaPrecioMaxId(Long actualizaPrecioMaxId) {
		this.actualizaPrecioMaxId = actualizaPrecioMaxId;
	}
	
	public Date getFechaVencTpoBonificacion() {
		return fechaVencTpoBonificacion;
	}
	public void setFechaVencTpoBonificacion(Date fechaVencTpoBonificacion) {
		this.fechaVencTpoBonificacion = fechaVencTpoBonificacion;
	}
	public Date getFechaLiqComplementaria() {
		return fechaLiqComplementaria;
	}
	public void setFechaLiqComplementaria(Date fechaLiqComplementaria) {
		this.fechaLiqComplementaria = fechaLiqComplementaria;
	}
	public String getTributacionAdq() {
		return tributacionAdq;
	}
	public void setTributacionAdq(String tributacionAdq) {
		this.tributacionAdq = tributacionAdq;
	}
	public Date getFechaEnvioComunicacionOrganismo() {
		return fechaEnvioComunicacionOrganismo;
	}
	public void setFechaEnvioComunicacionOrganismo(Date fechaEnvioComunicacionOrganismo) {
		this.fechaEnvioComunicacionOrganismo = fechaEnvioComunicacionOrganismo;
	}
	public Date getFechaRecepcionRespuestaOrganismo() {
		return fechaRecepcionRespuestaOrganismo;
	}
	public void setFechaRecepcionRespuestaOrganismo(Date fechaRecepcionRespuestaOrganismo) {
		this.fechaRecepcionRespuestaOrganismo = fechaRecepcionRespuestaOrganismo;
	}
	public String getEstadoVentaCodigo() {
		return estadoVentaCodigo;
	}
	public void setEstadoVentaCodigo(String estadoVentaCodigo) {
		this.estadoVentaCodigo = estadoVentaCodigo;
	}
	public String getEstadoVentaDescripcion() {
		return estadoVentaDescripcion;
	}
	public void setEstadoVentaDescripcion(String estadoVentaDescripcion) {
		this.estadoVentaDescripcion = estadoVentaDescripcion;
	}
	public String getTributacionAdqDescripcion() {
		return tributacionAdqDescripcion;
	}
	public void setTributacionAdqDescripcion(String tributacionAdqDescripcion) {
		this.tributacionAdqDescripcion = tributacionAdqDescripcion;
	}
	public String getMaxPrecioModuloAlquiler() {
		return maxPrecioModuloAlquiler;
	}
	public void setMaxPrecioModuloAlquiler(String maxPrecioModuloAlquiler) {
		this.maxPrecioModuloAlquiler = maxPrecioModuloAlquiler;
	}
	public Boolean getCompradorAcojeAyuda() {
		return compradorAcojeAyuda;
	}
	public void setCompradorAcojeAyuda(Boolean compradorAcojeAyuda) {
		this.compradorAcojeAyuda = compradorAcojeAyuda;
	}
	public Double getImporteAyudaFinanciacion() {
		return importeAyudaFinanciacion;
	}
	public void setImporteAyudaFinanciacion(Double importeAyudaFinanciacion) {
		this.importeAyudaFinanciacion = importeAyudaFinanciacion;
	}
	public Date getFechaVencimientoAvalSeguro() {
		return fechaVencimientoAvalSeguro;
	}
	public void setFechaVencimientoAvalSeguro(Date fechaVencimientoAvalSeguro) {
		this.fechaVencimientoAvalSeguro = fechaVencimientoAvalSeguro;
	}
	public Date getFechaDevolucionAyuda() {
		return fechaDevolucionAyuda;
	}
	public void setFechaDevolucionAyuda(Date fechaDevolucionAyuda) {
		this.fechaDevolucionAyuda = fechaDevolucionAyuda;
	}
	
}