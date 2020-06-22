package es.pfsgroup.plugin.rem.model.dd;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.expediente.model.DDTipoExpediente;
import es.pfsgroup.plugin.rem.model.Activo;

/**
 * Modelo que gestiona el diccionario de calificacion negativa de un activo
 * 
 * @author Jonathan Ovalle
 *
 */
@Entity
@Table(name = "ACT_ART_ADMISION_REV_TITULO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActArtAdmisionRevTitulo implements Auditable,Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	

	@Id
	@Column(name = "ART_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActArtAdmisionRevTituloGenerator")
	@SequenceGenerator(name = "ActArtAdmisionRevTituloGenerator", sequenceName = "S_ACT_ART_ADMISION_REV_TITULO")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ACTIVO")
	private Activo activo;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_REVISADO")
	private DDSinSiNo ArtRevisado;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_INST_LIB_ARRENDATARIA")
	private DDSiNoNoAplica ArtInstLibArrendataria;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_RATIFICACION")
	private DDSiNoNoAplica ArtRatificacion;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_SIT_INI_INSCRIPCION")
	private DDSituacionInicialInscripcion ArtSitIniInscripcion;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_POSESORIA_INI")
	private DDSituacionPosesoriaInicial ArtPosesoriaIni;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_SIT_INI_CARGAS")
	private DDSituacionInicialCargas ArtSitIniCargas;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_TIPO_TITULARIDAD")
	private DDTipoTitularidad ArtTipoTitularidad;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_AUTORIZ_TRANSMISION")
	private DDAutorizacionTransmision ArtAutorizTransmision;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_ANOTACION_CONCURSO")
	private DDAnotacionConcurso ArtAnotacionConcurso;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_EST_GES_CA")
	private DDEstadoGestion ArtEstGesCa;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_CONS_FISICA")
	private DDSinSiNo ArtConsFisica;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_CONS_JURIDICA")
	private DDSinSiNo ArtConsJuridica;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_CERTIFICADO_FIN_OBRA")
	private DDEstadoGestion ArtCertificadoFinObra;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_AFO_ACTA_FIN_OBRA")
	private DDEstadoGestion ArtAfoActaFinObra;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_LIC_PRIMERA_OCIPACION")
	private DDLicenciaPrimeraOcupacion ArtLicPrimeraOCupacion;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_BOLETINES")
	private DDBoletines ArtBoletines;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_SEGURO_DECENAL")
	private DDSeguroDecenal ArtSeguroDecenal;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_CEDULA_HABITABILIDAD")
	private DDCedulaHabitabilidad ArtCedulaHabitabilidad;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_TIPO_ARRENDAMIENTO")
	private DDTipoArrendamiento ArtTipoArrendamiento;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_NOTIF_ARRENDATARIOS")
	private DDSinSiNo ArtNotifArrendatarios;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_TIPO_EXP_ADM")
	private DDTipoExpediente ArtTipoExpAdm;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_EST_GES_EA")
	private DDEstadoGestion ArtEstGesEa;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_TIPO_INCI_REGISTRAL")
	private DDTipoIncidenciaRegistral ArtTipoInciRegistral;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_EST_GES_CR")
	private DDEstadoGestion ArtEstGesCr;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_TIPO_OCUPACION_LEGAL")
	private DDTipoOcupacionLegal ArtTipoOcupacionLegal;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_EST_GES_IL")
	private DDEstadoGestion ArtEstGesIl;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_EST_GES_OT")
	private DDEstadoGestion ArtEstGesOt;
	
	@Column(name = "ART_FECHA_REVISION_TITULO")
	private Date artFechaRevisionTitulo;
	
	@Column(name = "ART_PORC_PROPIEDAD")
	private Double artPorcPropiedad;
	
	@Column(name = "ART_OBSERVACIONES")
	private String artObservaciones;
	
	@Column(name = "ART_PORC_CONS_TASACION_CF")
	private Double artPorcConsTasacionCf;
	
	@Column(name = "ART_PORC_CONS_TASACION_CJ")
	private Double artPorcConsTasacionCj;
	
	@Column(name = "ART_FECHA_CONTRATO_ALQ")
	private Date artFechaContratoAlq;
	
	@Column(name = "ART_LEGISLACION_APLICABLE_ALQ")
	private String artLegislacionAplicableAlq;
	
	@Column(name = "ART_DURACION_CONTRATO_ALQ")
	private String artDuracionContratoAlq;
	
	@Column(name = "ART_TIPO_INCI_ILOC")
	private String artTipoInciIloc;
	
	@Column(name = "ART_DETERIORO_GRAVE")
	private String artDeterioroGrave;
	
	@Column(name = "ART_TIPO_INCI_OTROS")
	private String artTipoInciOtros;
	

	@Version
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public DDSinSiNo getArtRevisado() {
		return ArtRevisado;
	}

	public void setArtRevisado(DDSinSiNo artRevisado) {
		ArtRevisado = artRevisado;
	}

	public DDSiNoNoAplica getArtInstLibArrendataria() {
		return ArtInstLibArrendataria;
	}

	public void setArtInstLibArrendataria(DDSiNoNoAplica artInstLibArrendataria) {
		ArtInstLibArrendataria = artInstLibArrendataria;
	}

	public DDSiNoNoAplica getArtRatificacion() {
		return ArtRatificacion;
	}

	public void setArtRatificacion(DDSiNoNoAplica artRatificacion) {
		ArtRatificacion = artRatificacion;
	}

	public DDSituacionInicialInscripcion getArtSitIniInscripcion() {
		return ArtSitIniInscripcion;
	}

	public void setArtSitIniInscripcion(DDSituacionInicialInscripcion artSitIniInscripcion) {
		ArtSitIniInscripcion = artSitIniInscripcion;
	}

	public DDSituacionPosesoriaInicial getArtPosesoriaIni() {
		return ArtPosesoriaIni;
	}

	public void setArtPosesoriaIni(DDSituacionPosesoriaInicial artPosesoriaIni) {
		ArtPosesoriaIni = artPosesoriaIni;
	}

	public DDSituacionInicialCargas getArtSitIniCargas() {
		return ArtSitIniCargas;
	}

	public void setArtSitIniCargas(DDSituacionInicialCargas artSitIniCargas) {
		ArtSitIniCargas = artSitIniCargas;
	}

	public DDTipoTitularidad getArtTipoTitularidad() {
		return ArtTipoTitularidad;
	}

	public void setArtTipoTitularidad(DDTipoTitularidad artTipoTitularidad) {
		ArtTipoTitularidad = artTipoTitularidad;
	}

	public DDAutorizacionTransmision getArtAutorizTransmision() {
		return ArtAutorizTransmision;
	}

	public void setArtAutorizTransmision(DDAutorizacionTransmision artAutorizTransmision) {
		ArtAutorizTransmision = artAutorizTransmision;
	}

	public DDAnotacionConcurso getArtAnotacionConcurso() {
		return ArtAnotacionConcurso;
	}

	public void setArtAnotacionConcurso(DDAnotacionConcurso artAnotacionConcurso) {
		ArtAnotacionConcurso = artAnotacionConcurso;
	}

	public DDEstadoGestion getArtEstGesCa() {
		return ArtEstGesCa;
	}

	public void setArtEstGesCa(DDEstadoGestion artEstGesCa) {
		ArtEstGesCa = artEstGesCa;
	}

	public DDSinSiNo getArtConsFisica() {
		return ArtConsFisica;
	}

	public void setArtConsFisica(DDSinSiNo artConsFisica) {
		ArtConsFisica = artConsFisica;
	}

	public DDSinSiNo getArtConsJuridica() {
		return ArtConsJuridica;
	}

	public void setArtConsJuridica(DDSinSiNo artConsJuridica) {
		ArtConsJuridica = artConsJuridica;
	}

	public DDEstadoGestion getArtCertificadoFinObra() {
		return ArtCertificadoFinObra;
	}

	public void setArtCertificadoFinObra(DDEstadoGestion artCertificadoFinObra) {
		ArtCertificadoFinObra = artCertificadoFinObra;
	}

	public DDEstadoGestion getArtAfoActaFinObra() {
		return ArtAfoActaFinObra;
	}

	public void setArtAfoActaFinObra(DDEstadoGestion artAfoActaFinObra) {
		ArtAfoActaFinObra = artAfoActaFinObra;
	}

	public DDLicenciaPrimeraOcupacion getArtLicPrimeraOCupacion() {
		return ArtLicPrimeraOCupacion;
	}

	public void setArtLicPrimeraOCupacion(DDLicenciaPrimeraOcupacion artLicPrimeraOCupacion) {
		ArtLicPrimeraOCupacion = artLicPrimeraOCupacion;
	}

	public DDBoletines getArtBoletines() {
		return ArtBoletines;
	}

	public void setArtBoletines(DDBoletines artBoletines) {
		ArtBoletines = artBoletines;
	}

	public DDSeguroDecenal getArtSeguroDecenal() {
		return ArtSeguroDecenal;
	}

	public void setArtSeguroDecenal(DDSeguroDecenal artSeguroDecenal) {
		ArtSeguroDecenal = artSeguroDecenal;
	}

	public DDCedulaHabitabilidad getArtCedulaHabitabilidad() {
		return ArtCedulaHabitabilidad;
	}

	public void setArtCedulaHabitabilidad(DDCedulaHabitabilidad artCedulaHabitabilidad) {
		ArtCedulaHabitabilidad = artCedulaHabitabilidad;
	}

	public DDTipoArrendamiento getArtTipoArrendamiento() {
		return ArtTipoArrendamiento;
	}

	public void setArtTipoArrendamiento(DDTipoArrendamiento artTipoArrendamiento) {
		ArtTipoArrendamiento = artTipoArrendamiento;
	}

	public DDSinSiNo getArtNotifArrendatarios() {
		return ArtNotifArrendatarios;
	}

	public void setArtNotifArrendatarios(DDSinSiNo artNotifArrendatarios) {
		ArtNotifArrendatarios = artNotifArrendatarios;
	}

	public DDTipoExpediente getArtTipoExpAdm() {
		return ArtTipoExpAdm;
	}

	public void setArtTipoExpAdm(DDTipoExpediente artTipoExpAdm) {
		ArtTipoExpAdm = artTipoExpAdm;
	}

	public DDEstadoGestion getArtEstGesEa() {
		return ArtEstGesEa;
	}

	public void setArtEstGesEa(DDEstadoGestion artEstGesEa) {
		ArtEstGesEa = artEstGesEa;
	}

	public DDTipoIncidenciaRegistral getArtTipoInciRegistral() {
		return ArtTipoInciRegistral;
	}

	public void setArtTipoInciRegistral(DDTipoIncidenciaRegistral artTipoInciRegistral) {
		ArtTipoInciRegistral = artTipoInciRegistral;
	}

	public DDEstadoGestion getArtEstGesCr() {
		return ArtEstGesCr;
	}

	public void setArtEstGesCr(DDEstadoGestion artEstGesCr) {
		ArtEstGesCr = artEstGesCr;
	}

	public DDTipoOcupacionLegal getArtTipoOcupacionLegal() {
		return ArtTipoOcupacionLegal;
	}

	public void setArtTipoOcupacionLegal(DDTipoOcupacionLegal artTipoOcupacionLegal) {
		ArtTipoOcupacionLegal = artTipoOcupacionLegal;
	}

	public DDEstadoGestion getArtEstGesIl() {
		return ArtEstGesIl;
	}

	public void setArtEstGesIl(DDEstadoGestion artEstGesIl) {
		ArtEstGesIl = artEstGesIl;
	}

	public DDEstadoGestion getArtEstGesOt() {
		return ArtEstGesOt;
	}

	public void setArtEstGesOt(DDEstadoGestion artEstGesOt) {
		ArtEstGesOt = artEstGesOt;
	}

	public Date getArtFechaRevisionTitulo() {
		return artFechaRevisionTitulo;
	}

	public void setArtFechaRevisionTitulo(Date artFechaRevisionTitulo) {
		this.artFechaRevisionTitulo = artFechaRevisionTitulo;
	}

	public Double getArtPorcPropiedad() {
		return artPorcPropiedad;
	}

	public void setArtPorcPropiedad(Double artPorcPropiedad) {
		this.artPorcPropiedad = artPorcPropiedad;
	}

	public String getArtObservaciones() {
		return artObservaciones;
	}

	public void setArtObservaciones(String artObservaciones) {
		this.artObservaciones = artObservaciones;
	}

	public Double getArtPorcConsTasacionCf() {
		return artPorcConsTasacionCf;
	}

	public void setArtPorcConsTasacionCf(Double artPorcConsTasacionCf) {
		this.artPorcConsTasacionCf = artPorcConsTasacionCf;
	}

	public Double getArtPorcConsTasacionCj() {
		return artPorcConsTasacionCj;
	}

	public void setArtPorcConsTasacionCj(Double artPorcConsTasacionCj) {
		this.artPorcConsTasacionCj = artPorcConsTasacionCj;
	}

	public Date getArtFechaContratoAlq() {
		return artFechaContratoAlq;
	}

	public void setArtFechaContratoAlq(Date artFechaContratoAlq) {
		this.artFechaContratoAlq = artFechaContratoAlq;
	}

	public String getArtLegislacionAplicableAlq() {
		return artLegislacionAplicableAlq;
	}

	public void setArtLegislacionAplicableAlq(String artLegislacionAplicableAlq) {
		this.artLegislacionAplicableAlq = artLegislacionAplicableAlq;
	}

	public String getArtDuracionContratoAlq() {
		return artDuracionContratoAlq;
	}

	public void setArtDuracionContratoAlq(String artDuracionContratoAlq) {
		this.artDuracionContratoAlq = artDuracionContratoAlq;
	}

	public String getArtTipoInciIloc() {
		return artTipoInciIloc;
	}

	public void setArtTipoInciIloc(String artTipoInciIloc) {
		this.artTipoInciIloc = artTipoInciIloc;
	}

	public String getArtDeterioroGrave() {
		return artDeterioroGrave;
	}

	public void setArtDeterioroGrave(String artDeterioroGrave) {
		this.artDeterioroGrave = artDeterioroGrave;
	}

	public String getArtTipoInciOtros() {
		return artTipoInciOtros;
	}

	public void setArtTipoInciOtros(String artTipoInciOtros) {
		this.artTipoInciOtros = artTipoInciOtros;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	

}
