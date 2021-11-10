package es.pfsgroup.plugin.rem.model;

import java.util.Date;
import java.util.List;



/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoActivoDatosRegistrales extends DtoTabActivo {

	private static final long serialVersionUID = 0L;
	private Long idActivo;
	private String numeroActivo;
	private String numRegistro;
	private String numFinca;
	private String tomo;
	private String libro;
	private String folio;
	private String superficie;
	private String superficieConstruida;
	private String idufir;
	private String hanCambiado;
	private String numAnterior;
	private String numFincaAnterior;
	private String superficieUtil;
	private String superficieElementosComunes;
	private String superficieParcela;
	private Integer divHorInscrito;
	private Integer divHorizontal;
	private Integer numDepartamento;
	private Integer tieneAnejosRegistralesInt;
	// FIXME STRING PARA BORRAR FECHAS
	private Date fechaCfo;
	private Integer gestionHre;
	private String porcPropiedad;
	private Date fechaTitulo;
	private Date fechaFirmaTitulo;
	private String valorAdquisicion;
	private String tramitadorTitulo;
	private Long acreedorId;
	private String acreedorNombre;
	private String acreedorNif;
	private String acreedorDir;
	private String importeDeuda;
	private Integer rentaLibre;
	private Long acreedorNumExp;
	private String numReferencia;
	private Integer vpo;
	
	private Date fechaEntregaGestoria;
	private Date fechaPresHacienda;
	private Date fechaEnvioAuto;
	private Date fechaPres1Registro;
	private Date fechaPres2Registro;
	private Date fechaInscripcionReg;
	private Date fechaRetiradaReg;
	private Date fechaNotaSimple;
	private Double superficieBajoRasante;
	private Double superficieSobreRasante;
	
	// Mapeados a mano
	private String estadoDivHorizontalCodigo;
	private String estadoDivHorizontalDescripcion;
	private String estadoObraNuevaCodigo;
	private String estadoObraNuevaDescripcion;
	private String poblacionRegistro;
	private String poblacionRegistroDescripcion;
	private String provinciaRegistro;
	private String provinciaRegistroDescripcion;
	private String localidadAnteriorCodigo;
	private String localidadAnteriorDescripcion;
	private String tipoTituloCodigo;
	private String tipoTituloDescripcion;
	private String subtipoTituloCodigo;
	private String subtipoTituloDescripcion;
	private String propiedadActivoDescripcion;
	private String propiedadActivoCodigo;
	private String propiedadActivoNif;
	private String propiedadActivoDireccion;
	private String tipoGradoPropiedadCodigo;
	private String origenAnteriorActivoCodigo;
	private String origenAnteriorActivoDescripcion;
	private Date fechaTituloAnterior;
	
	private String estadoTitulo;   
	
	// Adjudicación judicial
	private Date fechaAdjudicacion;
	private String numAuto;
	private String procurador;
	private String letrado;
	private Long idAsunto;
	private String numExpRiesgoAdj;
	private Date fechaDecretoFirme;
	private Date fechaSenalamientoPosesion;
	private String importeAdjudicacion;
	private Date fechaRealizacionPosesion;
	private Integer lanzamientoNecesario;
	private Date fechaSenalamientoLanzamiento;
	private Date fechaRealizacionLanzamiento;
	private Date fechaSolicitudMoratoria;
	private String resolucionMoratoriaCodigo;
	private String resolucionMoratoriaDescripcion;
	private Date fechaResolucionMoratoria;
	private String defectosTestimonio;
	private String idProcesoOrigen;
	private String sociedadPagoAnterior;
	private String sociedadPagoAnteriorDescripcion;
	
	// Mapeados a mano
	private String tipoJuzgadoCodigo;
	private String tipoJuzgadoDescripcion;
	public String getDefectosTestimonio() {
		return defectosTestimonio;
	}
	public void setDefectosTestimonio(String defectosTestimonio) {
		this.defectosTestimonio = defectosTestimonio;
	}
	private String estadoAdjudicacionCodigo;
	private String estadoAdjudicacionDescripcion;
	private String tipoPlazaCodigo;
	private String tipoPlazaDescripcion;
	private String entidadAdjudicatariaCodigo;
	private String entidadEjecutanteCodigo;
	private String entidadEjecutanteDescripcion;
	
	//Calificacion negativa
	private String calificacionNegativa;
	private String motivoCalificacionNegativa;
	private String codigoMotivoCalificacionNegativa;
	private String descripcionCalificacionNegativa;
	private Boolean puedeEditarCalificacionNegativa;
	private Boolean isCalificacionNegativaEnabled;
	private Boolean noEstaInscrito;
	private Date fechaCalificacionNegativa;
	private Date fechaPresentacionRegistroCN;
	
	//Motivo Estado Calificación negativa
	private String estadoMotivoCalificacionNegativa;
	private String codigoEstadoMotivoCalificacionNegativa;
	
	//Responsable Subsanar
	
	private String responsableSubsanar;
	private String codigoResponsableSubsanar;
	
	private Date fechaSubsanacion;
	private String idMotivo;
	private List<String> idsMotivo;
	
	private Boolean unidadAlquilable;
	private String tipoTituloActivoMatriz;
	
	private String origenAnteriorActivoBbvaCodigo;
	private String origenAnteriorActivoBbvaDescripcion;
	private Long idAsuntoRecAlaska;
	private Date fechaPosesion;
	
	private String superficieParcelaUtil;
	
	private String sociedadOrigenCodigo;
	private String sociedadOrigenDescripcion;
	private String bancoOrigenCodigo;
	private String bancoOrigenDescripcion;
	private String nombreRegistro;
	/*

    private NMBAdjudicacionBien adjudicacionBien;
    
    
    
    private TipoJuzgado juzgado;
    private TipoPlaza plazaJuzgado;
    private DDEstadoAdjudicacion estadoAdjudicacion;

	
	
	
	;
	
	 */

	
	/*
	 *
	 * @Column(name="BIE_DREG_REFERENCIA_CATASTRAL")
  private String referenciaCatastralBien;
  private Date fechaInscripcion;
  private String municipoLibro;
  private String codigoRegistro;
  private DDProvincia provincia;
  private Localidad localidad;
	 */
	
	/*
	 * Activo
    private NMBInformacionRegistralBien infoRegistralBien;
	private Localidad  localidadAnterior;
	private DDEstadoDivHorizontal estadoDivHorizontal;
	private DDEstadoObraNueva estadoObraNueva;
	
	 */

	
	/*private NMBInformacionRegistralBienInfo datosRegistralesActivo;*/
	
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public Integer getGestionHre() {
		return gestionHre;
	}
	public void setGestionHre(Integer gestionHre) {
		this.gestionHre = gestionHre;
	}
	public String getPorcPropiedad() {
		return porcPropiedad;
	}
	public void setPorcPropiedad(String porcPropiedad) {
		this.porcPropiedad = porcPropiedad;
	}
	public Date getFechaTitulo() {
		return fechaTitulo;
	}
	public void setFechaTitulo(Date fechaTitulo) {
		this.fechaTitulo = fechaTitulo;
	}
	public Date getFechaFirmaTitulo() {
		return fechaFirmaTitulo;
	}
	public void setFechaFirmaTitulo(Date fechaFirmaTitulo) {
		this.fechaFirmaTitulo = fechaFirmaTitulo;
	}
	public String getValorAdquisicion() {
		return valorAdquisicion;
	}
	public void setValorAdquisicion(String valorAdquisicion) {
		this.valorAdquisicion = valorAdquisicion;
	}
	public String getTramitadorTitulo() {
		return tramitadorTitulo;
	}
	public void setTramitadorTitulo(String tramitadorTitulo) {
		this.tramitadorTitulo = tramitadorTitulo;
	}
	public String getPropiedadActivoDescripcion() {
		return propiedadActivoDescripcion;
	}
	public void setPropiedadActivoDescripcion(String propiedadActivoDescripcion) {
		this.propiedadActivoDescripcion = propiedadActivoDescripcion;
	}
	public String getTipoGradoPropiedadCodigo() {
		return tipoGradoPropiedadCodigo;
	}
	public void setTipoGradoPropiedadCodigo(String tipoGradoPropiedadCodigo) {
		this.tipoGradoPropiedadCodigo = tipoGradoPropiedadCodigo;
	}
	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}

	public String getPoblacionRegistro() {
		return poblacionRegistro;
	}
	public void setPoblacionRegistro(String poblacionRegistro) {
		this.poblacionRegistro = poblacionRegistro;
	}

	public String getTomo() {
		return tomo;
	}
	public void setTomo(String tomo) {
		this.tomo = tomo;
	}
	public String getLibro() {
		return libro;
	}
	public void setLibro(String libro) {
		this.libro = libro;
	}
	public String getFolio() {
		return folio;
	}
	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getSuperficie() {
		return superficie;
	}
	public void setSuperficie(String superficie) {
		this.superficie = superficie;
	}
	public String getSuperficieConstruida() {
		return superficieConstruida;
	}
	public void setSuperficieConstruida(String superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
	}
	public String getNumRegistro() {
		return numRegistro;
	}
	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}
	public String getNumFinca() {
		return numFinca;
	}
	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}
	public String getIdufir() {
		return idufir;
	}
	public void setIdufir(String idufir) {
		this.idufir = idufir;
	}
	public String getHanCambiado() {
		return hanCambiado;
	}
	public void setHanCambiado(String hanCambiado) {
		this.hanCambiado = hanCambiado;
	}
	public String getNumAnterior() {
		return numAnterior;
	}
	public void setNumAnterior(String numAnterior) {
		this.numAnterior = numAnterior;
	}
	public String getNumFincaAnterior() {
		return numFincaAnterior;
	}
	public void setNumFincaAnterior(String numFincaAnterior) {
		this.numFincaAnterior = numFincaAnterior;
	}
	public String getSuperficieUtil() {
		return superficieUtil;
	}
	public void setSuperficieUtil(String superficieUtil) {
		this.superficieUtil = superficieUtil;
	}
	public String getSuperficieElementosComunes() {
		return superficieElementosComunes;
	}
	public void setSuperficieElementosComunes(String superficieElementosComunes) {
		this.superficieElementosComunes = superficieElementosComunes;
	}
	public String getSuperficieParcela() {
		return superficieParcela;
	}
	public void setSuperficieParcela(String superficieParcela) {
		this.superficieParcela = superficieParcela;
	}
	public Integer getDivHorInscrito() {
		return divHorInscrito;
	}
	public void setDivHorInscrito(Integer divHorInscrito) {
		this.divHorInscrito = divHorInscrito;
	}
	public Integer getDivHorizontal() {
		return divHorizontal;
	}
	public void setDivHorizontal(Integer divHorizontal) {
		this.divHorizontal = divHorizontal;
	}
	public Integer getNumDepartamento() {
		return numDepartamento;
	}
	public void setNumDepartamento(Integer numDepartamento) {
		this.numDepartamento = numDepartamento;
	}
	public Date getFechaCfo() {
	/*	if (fechaCfo != null && fechaCfo.toString().equals("Mon Jan 01 00:00:00 UTC 1900")) {
			return null;
		}*/
		return fechaCfo;
	}
	public void setFechaCfo(Date fechaCfo) {
		this.fechaCfo = fechaCfo;
	}
	public String getEstadoDivHorizontalCodigo() {
		return estadoDivHorizontalCodigo;
	}
	public void setEstadoDivHorizontalCodigo(String estadoDivHorizontalCodigo) {
		this.estadoDivHorizontalCodigo = estadoDivHorizontalCodigo;
	}
	public String getEstadoDivHorizontalDescripcion() {
		return estadoDivHorizontalDescripcion;
	}
	public void setEstadoDivHorizontalDescripcion(String estadoDivHorizontalDescripcion) {
		this.estadoDivHorizontalDescripcion = estadoDivHorizontalDescripcion;
	}
	public String getEstadoObraNuevaCodigo() {
		return estadoObraNuevaCodigo;
	}
	public void setEstadoObraNuevaCodigo(String estadoObraNuevaCodigo) {
		this.estadoObraNuevaCodigo = estadoObraNuevaCodigo;
	}
	public String getProvinciaRegistro() {
		return provinciaRegistro;
	}
	public void setProvinciaRegistro(String provinciaRegistro) {
		this.provinciaRegistro = provinciaRegistro;
	}

	public String getTipoTituloCodigo() {
		return tipoTituloCodigo;
	}
	public void setTipoTituloCodigo(String tipoTituloCodigo) {
		this.tipoTituloCodigo = tipoTituloCodigo;
	}	
	public String getSubtipoTituloCodigo() {
		return subtipoTituloCodigo;
	}
	public void setSubtipoTituloCodigo(String subtipoTituloCodigo) {
		this.subtipoTituloCodigo = subtipoTituloCodigo;
	}
	public String getPropiedadActivoCodigo() {
		return propiedadActivoCodigo;
	}
	public void setPropiedadActivoCodigo(String propiedadActivoCodigo) {
		this.propiedadActivoCodigo = propiedadActivoCodigo;
	}
	public String getPropiedadActivoNif() {
		return propiedadActivoNif;
	}
	public void setPropiedadActivoNif(String propiedadActivoNif) {
		this.propiedadActivoNif = propiedadActivoNif;
	}
	public String getPropiedadActivoDireccion() {
		return propiedadActivoDireccion;
	}
	public void setPropiedadActivoDireccion(String propiedadActivoDireccion) {
		this.propiedadActivoDireccion = propiedadActivoDireccion;
	}
	public Long getAcreedorId() {
		return acreedorId;
	}
	public void setAcreedorId(Long acreedorId) {
		this.acreedorId = acreedorId;
	}
	public String getAcreedorNif() {
		return acreedorNif;
	}
	public void setAcreedorNif(String acreedorNif) {
		this.acreedorNif = acreedorNif;
	}
	public String getAcreedorDir() {
		return acreedorDir;
	}
	public void setAcreedorDir(String acreedorDir) {
		this.acreedorDir = acreedorDir;
	}
	public String getImporteDeuda() {
		return importeDeuda;
	}
	public void setImporteDeuda(String importeDeuda) {
		this.importeDeuda = importeDeuda;
	}
	public Integer getRentaLibre() {
		return rentaLibre;
	}
	public void setRentaLibre(Integer rentaLibre) {
		this.rentaLibre = rentaLibre;
	}
	public Long getAcreedorNumExp() {
		return acreedorNumExp;
	}
	public void setAcreedorNumExp(Long acreedorNumExp) {
		this.acreedorNumExp = acreedorNumExp;
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
	public String getEstadoTitulo() {
		return estadoTitulo;
	}
	public void setEstadoTitulo(String estadoTitulo) {
		this.estadoTitulo = estadoTitulo;
	}
	public String getAcreedorNombre() {
		return acreedorNombre;
	}
	public void setAcreedorNombre(String acreedorNombre) {
		this.acreedorNombre = acreedorNombre;
	}
	public String getNumReferencia() {
		return numReferencia;
	}
	public void setNumReferencia(String numReferencia) {
		this.numReferencia = numReferencia;
	}
	public String getLocalidadAnteriorCodigo() {
		return localidadAnteriorCodigo;
	}
	public void setLocalidadAnteriorCodigo(String localidadAnteriorCodigo) {
		this.localidadAnteriorCodigo = localidadAnteriorCodigo;
	}
	public Integer getVpo() {
		return vpo;
	}
	public void setVpo(Integer vpo) {
		this.vpo = vpo;
	}
	public Date getFechaAdjudicacion() {
		return fechaAdjudicacion;
	}
	public void setFechaAdjudicacion(Date fechaAdjudicacion) {
		this.fechaAdjudicacion = fechaAdjudicacion;
	}
	public String getNumAuto() {
		return numAuto;
	}
	public void setNumAuto(String numAuto) {
		this.numAuto = numAuto;
	}
	public String getProcurador() {
		return procurador;
	}
	public void setProcurador(String procurador) {
		this.procurador = procurador;
	}
	public String getLetrado() {
		return letrado;
	}
	public void setLetrado(String letrado) {
		this.letrado = letrado;
	}
	public Long getIdAsunto() {
		return idAsunto;
	}
	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}
	public String getNumExpRiesgoAdj() {
		return numExpRiesgoAdj;
	}
	public void setNumExpRiesgoAdj(String numExpRiesgoAdj) {
		this.numExpRiesgoAdj = numExpRiesgoAdj;
	}
	public Date getFechaDecretoFirme() {
		return fechaDecretoFirme;
	}
	public void setFechaDecretoFirme(Date fechaDecretoFirme) {
		this.fechaDecretoFirme = fechaDecretoFirme;
	}
	public Date getFechaSenalamientoPosesion() {
		return fechaSenalamientoPosesion;
	}
	public void setFechaSenalamientoPosesion(Date fechaSenalamientoPosesion) {
		this.fechaSenalamientoPosesion = fechaSenalamientoPosesion;
	}
	public String getImporteAdjudicacion() {
		return importeAdjudicacion;
	}
	public void setImporteAdjudicacion(String importeAdjudicacion) {
		this.importeAdjudicacion = importeAdjudicacion;
	}
	public String getTipoJuzgadoCodigo() {
		return tipoJuzgadoCodigo;
	}
	public void setTipoJuzgadoCodigo(String tipoJuzgadoCodigo) {
		this.tipoJuzgadoCodigo = tipoJuzgadoCodigo;
	}
	public String getEstadoAdjudicacionCodigo() {
		return estadoAdjudicacionCodigo;
	}
	public void setEstadoAdjudicacionCodigo(String estadoAdjudicacionCodigo) {
		this.estadoAdjudicacionCodigo = estadoAdjudicacionCodigo;
	}
	public String getTipoPlazaCodigo() {
		return tipoPlazaCodigo;
	}
	public void setTipoPlazaCodigo(String tipoPlazaCodigo) {
		this.tipoPlazaCodigo = tipoPlazaCodigo;
	}
	public String getEntidadAdjudicatariaCodigo() {
		return entidadAdjudicatariaCodigo;
	}
	public void setEntidadAdjudicatariaCodigo(String entidadAdjudicatariaCodigo) {
		this.entidadAdjudicatariaCodigo = entidadAdjudicatariaCodigo;
	}
	public String getEntidadEjecutanteCodigo() {
		return entidadEjecutanteCodigo;
	}
	public void setEntidadEjecutanteCodigo(String entidadEjecutanteCodigo) {
		this.entidadEjecutanteCodigo = entidadEjecutanteCodigo;
	}
	public Date getFechaRealizacionPosesion() {
		return fechaRealizacionPosesion;
	}
	public void setFechaRealizacionPosesion(Date fechaRealizacionPosesion) {
		this.fechaRealizacionPosesion = fechaRealizacionPosesion;
	}
	public Integer getLanzamientoNecesario() {
		return lanzamientoNecesario;
	}
	public void setLanzamientoNecesario(Integer lanzamientoNecesario) {
		this.lanzamientoNecesario = lanzamientoNecesario;
	}
	public Date getFechaSenalamientoLanzamiento() {
		return fechaSenalamientoLanzamiento;
	}
	public void setFechaSenalamientoLanzamiento(Date fechaSenalamientoLanzamiento) {
		this.fechaSenalamientoLanzamiento = fechaSenalamientoLanzamiento;
	}
	public Date getFechaRealizacionLanzamiento() {
		return fechaRealizacionLanzamiento;
	}
	public void setFechaRealizacionLanzamiento(Date fechaRealizacionLanzamiento) {
		this.fechaRealizacionLanzamiento = fechaRealizacionLanzamiento;
	}
	public Date getFechaSolicitudMoratoria() {
		return fechaSolicitudMoratoria;
	}
	public void setFechaSolicitudMoratoria(Date fechaSolicitudMoratoria) {
		this.fechaSolicitudMoratoria = fechaSolicitudMoratoria;
	}
	public String getResolucionMoratoriaCodigo() {
		return resolucionMoratoriaCodigo;
	}
	public void setResolucionMoratoriaCodigo(String resolucionMoratoriaCodigo) {
		this.resolucionMoratoriaCodigo = resolucionMoratoriaCodigo;
	}
	public Date getFechaResolucionMoratoria() {
		return fechaResolucionMoratoria;
	}
	public void setFechaResolucionMoratoria(Date fechaResolucionMoratoria) {
		this.fechaResolucionMoratoria = fechaResolucionMoratoria;
	}
	public String getCalificacionNegativa() {
		return calificacionNegativa;
	}
	public void setCalificacionNegativa(String calificacionNegativa) {
		this.calificacionNegativa = calificacionNegativa;
	}
	public String getMotivoCalificacionNegativa() {
		return motivoCalificacionNegativa;
	}
	public void setMotivoCalificacionNegativa(String motivoCalificacionNegativa) {
		this.motivoCalificacionNegativa = motivoCalificacionNegativa;
	}
	public String getDescripcionCalificacionNegativa() {
		return descripcionCalificacionNegativa;
	}
	public void setDescripcionCalificacionNegativa(String descripcionCalificacionNegativa) {
		this.descripcionCalificacionNegativa = descripcionCalificacionNegativa;
	}
	public String getEstadoMotivoCalificacionNegativa() {
		return estadoMotivoCalificacionNegativa;
	}
	public void setEstadoMotivoCalificacionNegativa(String estadoMotivoCalificacionNegativa) {
		this.estadoMotivoCalificacionNegativa = estadoMotivoCalificacionNegativa;
	}
	public String getResponsableSubsanar() {
		return responsableSubsanar;
	}
	public void setResponsableSubsanar(String responsableSubsanar) {
		this.responsableSubsanar = responsableSubsanar;
	}
	public Date getFechaSubsanacion() {
		return fechaSubsanacion;
	}
	public void setFechaSubsanacion(Date fechaSubsanacion) {
		this.fechaSubsanacion = fechaSubsanacion;
	}
	public String getCodigoEstadoMotivoCalificacionNegativa() {
		return codigoEstadoMotivoCalificacionNegativa;
	}
	public void setCodigoEstadoMotivoCalificacionNegativa(String codigoEstadoMotivoCalificacionNegativa) {
		this.codigoEstadoMotivoCalificacionNegativa = codigoEstadoMotivoCalificacionNegativa;
	}
	public String getCodigoResponsableSubsanar() {
		return codigoResponsableSubsanar;
	}
	public void setCodigoResponsableSubsanar(String codigoResponsableSubsanar) {
		this.codigoResponsableSubsanar = codigoResponsableSubsanar;
	}
	public String getIdMotivo() {
		return idMotivo;
	}
	public void setIdMotivo(String idMotivo) {
		this.idMotivo = idMotivo;
	}
	public String getCodigoMotivoCalificacionNegativa() {
		return codigoMotivoCalificacionNegativa;
	}
	public void setCodigoMotivoCalificacionNegativa(String codigoMotivoCalificacionNegativa) {
		this.codigoMotivoCalificacionNegativa = codigoMotivoCalificacionNegativa;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Boolean getPuedeEditarCalificacionNegativa() {
		return puedeEditarCalificacionNegativa;
	}
	public void setPuedeEditarCalificacionNegativa(Boolean puedeEditarCalificacionNegativa) {
		this.puedeEditarCalificacionNegativa = puedeEditarCalificacionNegativa;
	}
	public Boolean getIsCalificacionNegativaEnabled() {
		return isCalificacionNegativaEnabled;
	}
	public void setIsCalificacionNegativaEnabled(Boolean isCalificacionNegativaEnabled) {
		this.isCalificacionNegativaEnabled = isCalificacionNegativaEnabled;
	}
	public Boolean getNoEstaInscrito() {
		return noEstaInscrito;
	}
	public void setNoEstaInscrito(Boolean noEstaInscrito) {
		this.noEstaInscrito = noEstaInscrito;
	}
	public Boolean getUnidadAlquilable() {
		return unidadAlquilable;
	}
	public void setUnidadAlquilable(Boolean unidadAlquilable) {
		this.unidadAlquilable = unidadAlquilable;
	}
	public List<String> getIdsMotivo() {
		return idsMotivo;
	}
	public void setIdsMotivo(List<String> idsMotivo) {
		this.idsMotivo = idsMotivo;

	}
	public String getTipoTituloActivoMatriz() {
		return tipoTituloActivoMatriz;
	}
	public void setTipoTituloActivoMatriz(String tipoTituloActivoMatriz) {
		this.tipoTituloActivoMatriz = tipoTituloActivoMatriz;
	}
	public Date getFechaCalificacionNegativa() {
		return fechaCalificacionNegativa;
	}
	public void setFechaCalificacionNegativa(Date fechaCalificacionNegativa) {
		this.fechaCalificacionNegativa = fechaCalificacionNegativa;
	}
	public Date getFechaPresentacionRegistroCN() {
		return fechaPresentacionRegistroCN;
	}
	public void setFechaPresentacionRegistroCN(Date fechaPresentacionRegistroCN) {
		this.fechaPresentacionRegistroCN = fechaPresentacionRegistroCN;
	}
	public String getOrigenAnteriorActivoCodigo() {
		return origenAnteriorActivoCodigo;
	}
	public void setOrigenAnteriorActivoCodigo(String origenAnteriorActivoCodigo) {
		this.origenAnteriorActivoCodigo = origenAnteriorActivoCodigo;
	}
	public Date getFechaTituloAnterior() {
		return fechaTituloAnterior;
	}
	public void setFechaTituloAnterior(Date fechaTituloAnterior) {
		this.fechaTituloAnterior = fechaTituloAnterior;
	}
	public Integer getTieneAnejosRegistralesInt() {
		return tieneAnejosRegistralesInt;
	}
	public void setTieneAnejosRegistralesInt(Integer tieneAnejosRegistralesInt) {
		this.tieneAnejosRegistralesInt = tieneAnejosRegistralesInt;
	}
	
	public String getSociedadPagoAnterior() {
		return sociedadPagoAnterior;
	}
	public void setSociedadPagoAnterior(String sociedadPagoAnterior) {
		this.sociedadPagoAnterior = sociedadPagoAnterior;
	}

	public String getOrigenAnteriorActivoBbvaCodigo() {
		return origenAnteriorActivoBbvaCodigo;
	}
	public void setOrigenAnteriorActivoBbvaCodigo(String origenAnteriorActivoBbvaCodigo) {
		this.origenAnteriorActivoBbvaCodigo = origenAnteriorActivoBbvaCodigo;
	}
	public Long getIdAsuntoRecAlaska() {
		return idAsuntoRecAlaska;
	}
	public void setIdAsuntoRecAlaska(Long idAsuntoRecAlaska) {
		this.idAsuntoRecAlaska = idAsuntoRecAlaska;
	}

	public String getIdProcesoOrigen() {
		return idProcesoOrigen;
	}
	public void setIdProcesoOrigen(String idProcesoOrigen) {
		this.idProcesoOrigen = idProcesoOrigen;
	}
	public Date getFechaPosesion() {
		return fechaPosesion;
	}
	public void setFechaPosesion(Date fechaPosesion) {
		this.fechaPosesion = fechaPosesion;
	}
	public String getPoblacionRegistroDescripcion() {
		return poblacionRegistroDescripcion;
	}
	public void setPoblacionRegistroDescripcion(String poblacionRegistroDescripcion) {
		this.poblacionRegistroDescripcion = poblacionRegistroDescripcion;
	}
	public String getProvinciaRegistroDescripcion() {
		return provinciaRegistroDescripcion;
	}
	public void setProvinciaRegistroDescripcion(String provinciaRegistroDescripcion) {
		this.provinciaRegistroDescripcion = provinciaRegistroDescripcion;
	}
	public String getLocalidadAnteriorDescripcion() {
		return localidadAnteriorDescripcion;
	}
	public void setLocalidadAnteriorDescripcion(String localidadAnteriorDescripcion) {
		this.localidadAnteriorDescripcion = localidadAnteriorDescripcion;
	}
	public String getEstadoObraNuevaDescripcion() {
		return estadoObraNuevaDescripcion;
	}
	public void setEstadoObraNuevaDescripcion(String estadoObraNuevaDescripcion) {
		this.estadoObraNuevaDescripcion = estadoObraNuevaDescripcion;
	}
	public String getTipoTituloDescripcion() {
		return tipoTituloDescripcion;
	}
	public void setTipoTituloDescripcion(String tipoTituloDescripcion) {
		this.tipoTituloDescripcion = tipoTituloDescripcion;
	}
	public String getSubtipoTituloDescripcion() {
		return subtipoTituloDescripcion;
	}
	public void setSubtipoTituloDescripcion(String subtipoTituloDescripcion) {
		this.subtipoTituloDescripcion = subtipoTituloDescripcion;
	}
	public String getOrigenAnteriorActivoDescripcion() {
		return origenAnteriorActivoDescripcion;
	}
	public void setOrigenAnteriorActivoDescripcion(String origenAnteriorActivoDescripcion) {
		this.origenAnteriorActivoDescripcion = origenAnteriorActivoDescripcion;
	}
	public String getOrigenAnteriorActivoBbvaDescripcion() {
		return origenAnteriorActivoBbvaDescripcion;
	}
	public void setOrigenAnteriorActivoBbvaDescripcion(String origenAnteriorActivoBbvaDescripcion) {
		this.origenAnteriorActivoBbvaDescripcion = origenAnteriorActivoBbvaDescripcion;
	}
	public String getSociedadPagoAnteriorDescripcion() {
		return sociedadPagoAnteriorDescripcion;
	}
	public void setSociedadPagoAnteriorDescripcion(String sociedadPagoAnteriorDescripcion) {
		this.sociedadPagoAnteriorDescripcion = sociedadPagoAnteriorDescripcion;
	}
	public String getEntidadEjecutanteDescripcion() {
		return entidadEjecutanteDescripcion;
	}
	public void setEntidadEjecutanteDescripcion(String entidadEjecutanteDescripcion) {
		this.entidadEjecutanteDescripcion = entidadEjecutanteDescripcion;
	}
	public String getEstadoAdjudicacionDescripcion() {
		return estadoAdjudicacionDescripcion;
	}
	public void setEstadoAdjudicacionDescripcion(String estadoAdjudicacionDescripcion) {
		this.estadoAdjudicacionDescripcion = estadoAdjudicacionDescripcion;
	}
	public String getResolucionMoratoriaDescripcion() {
		return resolucionMoratoriaDescripcion;
	}
	public void setResolucionMoratoriaDescripcion(String resolucionMoratoriaDescripcion) {
		this.resolucionMoratoriaDescripcion = resolucionMoratoriaDescripcion;
	}
	public String getTipoJuzgadoDescripcion() {
		return tipoJuzgadoDescripcion;
	}
	public void setTipoJuzgadoDescripcion(String tipoJuzgadoDescripcion) {
		this.tipoJuzgadoDescripcion = tipoJuzgadoDescripcion;
	}
	public String getTipoPlazaDescripcion() {
		return tipoPlazaDescripcion;
	}
	public void setTipoPlazaDescripcion(String tipoPlazaDescripcion) {
		this.tipoPlazaDescripcion = tipoPlazaDescripcion;
	}
	public Double getSuperficieBajoRasante() {
		return superficieBajoRasante;
	}
	public void setSuperficieBajoRasante(Double superficieBajoRasante) {
		this.superficieBajoRasante = superficieBajoRasante;
	}
	public Double getSuperficieSobreRasante() {
		return superficieSobreRasante;
	}
	public void setSuperficieSobreRasante(Double superficieSobreRasante) {
		this.superficieSobreRasante = superficieSobreRasante;
	}
	public String getSuperficieParcelaUtil() {
		return superficieParcelaUtil;
	}
	public void setSuperficieParcelaUtil(String superficieParcelaUtil) {
		this.superficieParcelaUtil = superficieParcelaUtil;
	}
	public String getSociedadOrigenCodigo() {
		return sociedadOrigenCodigo;
	}
	public void setSociedadOrigenCodigo(String sociedadOrigenCodigo) {
		this.sociedadOrigenCodigo = sociedadOrigenCodigo;
	}
	public String getSociedadOrigenDescripcion() {
		return sociedadOrigenDescripcion;
	}
	public void setSociedadOrigenDescripcion(String sociedadOrigenDescripcion) {
		this.sociedadOrigenDescripcion = sociedadOrigenDescripcion;
	}
	public String getBancoOrigenCodigo() {
		return bancoOrigenCodigo;
	}
	public void setBancoOrigenCodigo(String bancoOrigenCodigo) {
		this.bancoOrigenCodigo = bancoOrigenCodigo;
	}
	public String getBancoOrigenDescripcion() {
		return bancoOrigenDescripcion;
	}
	public void setBancoOrigenDescripcion(String bancoOrigenDescripcion) {
		this.bancoOrigenDescripcion = bancoOrigenDescripcion;
	}

	public String getNombreRegistro() {
		return nombreRegistro;
	}

	public void setNombreRegistro(String nombreRegistro) {
		this.nombreRegistro = nombreRegistro;
	}
}