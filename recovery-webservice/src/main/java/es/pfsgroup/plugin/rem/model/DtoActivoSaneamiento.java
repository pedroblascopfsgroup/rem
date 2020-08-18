package es.pfsgroup.plugin.rem.model;

import java.util.Date;

public class DtoActivoSaneamiento extends DtoTabActivo {
	/**
	 * 
	 */
	private static final long serialVersionUID = -2537329516083931156L;

	private Long idActivo;
	private String numeroActivo;
	private Date fechaRevisionCarga;
	private Integer vpo;
	private Long tipoVpoId;
	private String tipoVpoDescripcion;
	private String estadoTitulo;
	private Date fechaEntregaGestoria;
	private Date fechaPresHacienda;
	private Date fechaEnvioAuto;
	private Date fechaPres1Registro;
	private Date fechaPres2Registro;
	private Date fechaInscripcionReg;
	private Date fechaRetiradaReg;
	private Date fechaNotaSimple;
	private Boolean unidadAlquilable;
	private Boolean noEstaInscrito;
	private Integer conCargas;
	private String estadoCargas;
	private String gestoriaAsignada;
	private Date fechaAsignacion;
	private Date fechaRevsionCarga;
	private Boolean puedeEditarCalificacionNegativa;
	private String tipoVpoCodigo;
	private Date vigencia;
	private Integer comunicarAdquisicion;
	private Integer necesarioInscribirVpo;
	private Integer libertadCesion;
	private Integer renunciaTanteoRetrac;
	private Integer venderPersonaJuridica;
	private Integer minusvalia;
	private Integer inscripcionRegistroDemVpo;
	private Integer ingresosInfNivel;
	private Integer residenciaComAutonoma;
	private Integer noTitularOtraVivienda;
	private String sueloVpo;
	private String promocionVpo;
	private String numExpediente;
	private Date fechaCalificacion;
	private Integer obligatorioSolDevAyuda;
	private Integer obligatorioAutAdmVenta;
	private Integer visaContratoPriv;
	private Integer descalificado;
	private Integer sujetoAExpediente;
	private String organismoExpropiante;
	private Date fechaInicioExpediente;
	private String refExpedienteAdmin;
	private String refExpedienteInterno;
	private String observacionesExpropiacion;
	private String maxPrecioVenta;
	private String observaciones;
	
	// ADMISION/SANEAMIENTO/TRAMITACION TITULO ADICIONAL
	private Boolean tieneTituloAdicional; 
	private String estadoTituloAdicional;
	private String situacionTituloAdicional;
	private Date fechaInscriptionRegistroAdicional;
	private Date fechaEntregaTituloGestAdicional;
	private Date fechaRetiradaDefinitivaRegAdicional;
	private Date fechaPresentacionHaciendaAdicional;
	private Date fechaNotaSimpleAdicional;
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}
	public Date getFechaRevisionCarga() {
		return fechaRevisionCarga;
	}
	public void setFechaRevisionCarga(Date fechaRevisionCarga) {
		this.fechaRevisionCarga = fechaRevisionCarga;
	}
	public Integer getVpo() {
		return vpo;
	}
	public void setVpo(Integer vpo) {
		this.vpo = vpo;
	}
	public Long getTipoVpoId() {
		return tipoVpoId;
	}
	public void setTipoVpoId(Long tipoVpoId) {
		this.tipoVpoId = tipoVpoId;
	}
	public String getTipoVpoDescripcion() {
		return tipoVpoDescripcion;
	}
	public void setTipoVpoDescripcion(String tipoVpoDescripcion) {
		this.tipoVpoDescripcion = tipoVpoDescripcion;
	}
	public String getEstadoTitulo() {
		return estadoTitulo;
	}
	public void setEstadoTitulo(String estadoTitulo) {
		this.estadoTitulo = estadoTitulo;
	}
	public Date getFechaEntregaGestoria() {
		return fechaEntregaGestoria;
	}
	public void setFechaEntregaGestoria(Date fechaEntregaGestoria) {
		this.fechaEntregaGestoria = fechaEntregaGestoria;
	}
	public Date getFechaPresHacienda() {
		return fechaPresHacienda;
	}
	public void setFechaPresHacienda(Date fechaPresHacienda) {
		this.fechaPresHacienda = fechaPresHacienda;
	}
	public Date getFechaEnvioAuto() {
		return fechaEnvioAuto;
	}
	public void setFechaEnvioAuto(Date fechaEnvioAuto) {
		this.fechaEnvioAuto = fechaEnvioAuto;
	}
	public Date getFechaPres1Registro() {
		return fechaPres1Registro;
	}
	public void setFechaPres1Registro(Date fechaPres1Registro) {
		this.fechaPres1Registro = fechaPres1Registro;
	}
	public Date getFechaPres2Registro() {
		return fechaPres2Registro;
	}
	public void setFechaPres2Registro(Date fechaPres2Registro) {
		this.fechaPres2Registro = fechaPres2Registro;
	}
	public Date getFechaInscripcionReg() {
		return fechaInscripcionReg;
	}
	public void setFechaInscripcionReg(Date fechaInscripcionReg) {
		this.fechaInscripcionReg = fechaInscripcionReg;
	}
	public Date getFechaRetiradaReg() {
		return fechaRetiradaReg;
	}
	public void setFechaRetiradaReg(Date fechaRetiradaReg) {
		this.fechaRetiradaReg = fechaRetiradaReg;
	}
	public Date getFechaNotaSimple() {
		return fechaNotaSimple;
	}
	public void setFechaNotaSimple(Date fechaNotaSimple) {
		this.fechaNotaSimple = fechaNotaSimple;
	}
	public Boolean getUnidadAlquilable() {
		return unidadAlquilable;
	}
	public void setUnidadAlquilable(Boolean unidadAlquilable) {
		this.unidadAlquilable = unidadAlquilable;
	}
	public Boolean getNoEstaInscrito() {
		return noEstaInscrito;
	}
	public void setNoEstaInscrito(Boolean noEstaInscrito) {
		this.noEstaInscrito = noEstaInscrito;
	}
	public Integer getConCargas() {
		return conCargas;
	}
	public void setConCargas(Integer conCargas) {
		this.conCargas = conCargas;
	}
	public String getEstadoCargas() {
		return estadoCargas;
	}
	public void setEstadoCargas(String estadoCargas) {
		this.estadoCargas = estadoCargas;
	}
	public String getGestoriaAsignada() {
		return gestoriaAsignada;
	}
	public void setGestoriaAsignada(String gestoriaAsignada) {
		this.gestoriaAsignada = gestoriaAsignada;
	}
	public Date getFechaAsignacion() {
		return fechaAsignacion;
	}
	public void setFechaAsignacion(Date fechaAsignacion) {
		this.fechaAsignacion = fechaAsignacion;
	}
	public Date getFechaRevsionCarga() {
		return fechaRevsionCarga;
	}
	public void setFechaRevsionCarga(Date fechaRevsionCarga) {
		this.fechaRevsionCarga = fechaRevsionCarga;
	}
	public Boolean getPuedeEditarCalificacionNegativa() {
		return puedeEditarCalificacionNegativa;
	}
	public void setPuedeEditarCalificacionNegativa(Boolean puedeEditarCalificacionNegativa) {
		this.puedeEditarCalificacionNegativa = puedeEditarCalificacionNegativa;
	}
	public String getTipoVpoCodigo() {
		return tipoVpoCodigo;
	}
	public void setTipoVpoCodigo(String tipoVpoCodigo) {
		this.tipoVpoCodigo = tipoVpoCodigo;
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
	public Integer getVisaContratoPriv() {
		return visaContratoPriv;
	}
	public void setVisaContratoPriv(Integer visaContratoPriv) {
		this.visaContratoPriv = visaContratoPriv;
	}
	public Integer getDescalificado() {
		return descalificado;
	}
	public void setDescalificado(Integer descalificado) {
		this.descalificado = descalificado;
	}
	public Integer getSujetoAExpediente() {
		return sujetoAExpediente;
	}
	public void setSujetoAExpediente(Integer sujetoAExpediente) {
		this.sujetoAExpediente = sujetoAExpediente;
	}
	public String getOrganismoExpropiante() {
		return organismoExpropiante;
	}
	public void setOrganismoExpropiante(String organismoExpropiante) {
		this.organismoExpropiante = organismoExpropiante;
	}
	public Date getFechaInicioExpediente() {
		return fechaInicioExpediente;
	}
	public void setFechaInicioExpediente(Date fechaInicioExpediente) {
		this.fechaInicioExpediente = fechaInicioExpediente;
	}
	public String getRefExpedienteAdmin() {
		return refExpedienteAdmin;
	}
	public void setRefExpedienteAdmin(String refExpedienteAdmin) {
		this.refExpedienteAdmin = refExpedienteAdmin;
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
	public Boolean getTieneTituloAdicional() {
		return tieneTituloAdicional;
	}
	public void setTieneTituloAdicional(Boolean tieneTituloAdicional) {
		this.tieneTituloAdicional = tieneTituloAdicional;
	}
	public String getEstadoTituloAdicional() {
		return estadoTituloAdicional;
	}
	public void setEstadoTituloAdicional(String estadoTituloAdicional) {
		this.estadoTituloAdicional = estadoTituloAdicional;
	}
	public String getSituacionTituloAdicional() {
		return situacionTituloAdicional;
	}
	public void setSituacionTituloAdicional(String situacionTituloAdicional) {
		this.situacionTituloAdicional = situacionTituloAdicional;
	}
	public Date getFechaInscriptionRegistroAdicional() {
		return fechaInscriptionRegistroAdicional;
	}
	public void setFechaInscriptionRegistroAdicional(Date fechaInscriptionRegistroAdicional) {
		this.fechaInscriptionRegistroAdicional = fechaInscriptionRegistroAdicional;
	}
	public Date getFechaEntregaTituloGestAdicional() {
		return fechaEntregaTituloGestAdicional;
	}
	public void setFechaEntregaTituloGestAdicional(Date fechaEntregaTituloGestAdicional) {
		this.fechaEntregaTituloGestAdicional = fechaEntregaTituloGestAdicional;
	}
	public Date getFechaRetiradaDefinitivaRegAdicional() {
		return fechaRetiradaDefinitivaRegAdicional;
	}
	public void setFechaRetiradaDefinitivaRegAdicional(Date fechaRetiradaDefinitivaRegAdicional) {
		this.fechaRetiradaDefinitivaRegAdicional = fechaRetiradaDefinitivaRegAdicional;
	}
	public Date getFechaPresentacionHaciendaAdicional() {
		return fechaPresentacionHaciendaAdicional;
	}
	public void setFechaPresentacionHaciendaAdicional(Date fechaPresentacionHaciendaAdicional) {
		this.fechaPresentacionHaciendaAdicional = fechaPresentacionHaciendaAdicional;
	}
	public Date getFechaNotaSimpleAdicional() {
		return fechaNotaSimpleAdicional;
	}
	public void setFechaNotaSimpleAdicional(Date fechaNotaSimpleAdicional) {
		this.fechaNotaSimpleAdicional = fechaNotaSimpleAdicional;
	}

}
