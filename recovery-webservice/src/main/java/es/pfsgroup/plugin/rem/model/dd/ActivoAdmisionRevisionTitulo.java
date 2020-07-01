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
public class ActivoAdmisionRevisionTitulo implements Auditable,Serializable {

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
	private DDSinSiNo revisado;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_INST_LIB_ARRENDATARIA")
	private DDSiNoNoAplica instLibArrendataria;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_RATIFICACION")
	private DDSiNoNoAplica ratificacion;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_SIT_INI_INSCRIPCION")
	private DDSituacionInicialInscripcion situacionInicialInscripcion;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_POSESORIA_INI")
	private DDSituacionPosesoriaInicial posesoriaInicial;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_SIT_INI_CARGAS")
	private DDSituacionInicialCargas situacionInicialCargas;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_TIPO_TITULARIDAD")
	private DDTipoTitularidad tipoTitularidad;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_AUTORIZ_TRANSMISION")
	private DDAutorizacionTransmision estadoAutorizaTransmision;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_ANOTACION_CONCURSO")
	private DDAnotacionConcurso anotacionConcurso;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_EST_GES_CA")
	private DDEstadoGestion estadoGestionCa;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_CONS_FISICA")
	private DDSinSiNo consFisica;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_CONS_JURIDICA")
	private DDSinSiNo consJuridica;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_CERTIFICADO_FIN_OBRA")
	private DDEstadoGestion estadoCertificadoFinObra;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_AFO_ACTA_FIN_OBRA")
	private DDEstadoGestion estadoAfoActaFinObra;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_LIC_PRIMERA_OCIPACION")
	private DDLicenciaPrimeraOcupacion licenciaPrimeraOcupacion;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_BOLETINES")
	private DDBoletines boletines;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_SEGURO_DECENAL")
	private DDSeguroDecenal seguroDecenal;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_CEDULA_HABITABILIDAD")
	private DDCedulaHabitabilidad cedulaHabitibilidad;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_TIPO_ARRENDAMIENTO")
	private DDTipoArrendamiento tipoArrendamiento;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_NOTIF_ARRENDATARIOS")
	private DDSinSiNo notificarArrendatarios;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_TIPO_EXP_ADM")
	private DDTipoExpediente tipoExpediente;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_EST_GES_EA")
	private DDEstadoGestion estadoGestionEa;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_TIPO_INCI_REGISTRAL")
	private DDTipoIncidenciaRegistral tipoIncidenciaRegistral;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_EST_GES_CR")
	private DDEstadoGestion estadoGestionCr;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_TIPO_OCUPACION_LEGAL")
	private DDTipoOcupacionLegal tipoOcupacionLegal;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_EST_GES_IL")
	private DDEstadoGestion estadoGestionIl;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ART_EST_GES_OT")
	private DDEstadoGestion estadoGestionOt;
	
	@Column(name = "ART_FECHA_REVISION_TITULO")
	private Date fechaRevisionTitulo;
	
	@Column(name = "ART_PORC_PROPIEDAD")
	private Double porcentajePropiedad;
	
	@Column(name = "ART_OBSERVACIONES")
	private String observaciones;
	
	@Column(name = "ART_PORC_CONS_TASACION_CF")
	private Double porcentajeConsTasacionCf;
	
	@Column(name = "ART_PORC_CONS_TASACION_CJ")
	private Double porcentajeConsTasacionCj;
	
	@Column(name = "ART_FECHA_CONTRATO_ALQ")
	private Date fechaContratoAlquiler;
	
	@Column(name = "ART_LEGISLACION_APLICABLE_ALQ")
	private String legislacionAplicableAlquiler;
	
	@Column(name = "ART_DURACION_CONTRATO_ALQ")
	private String duracionContratoAlquiler;
	
	@Column(name = "ART_TIPO_INCI_ILOC")
	private String tipoIncidenciaIloc;
	
	@Column(name = "ART_DETERIORO_GRAVE")
	private String deterioroGrave;
	
	@Column(name = "ART_TIPO_INCI_OTROS")
	private String tipoIncidenciaOtros;
	

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

	public DDSinSiNo getRevisado() {
		return revisado;
	}

	public void setRevisado(DDSinSiNo revisado) {
		this.revisado = revisado;
	}

	public DDSiNoNoAplica getInstLibArrendataria() {
		return instLibArrendataria;
	}

	public void setInstLibArrendataria(DDSiNoNoAplica instLibArrendataria) {
		this.instLibArrendataria = instLibArrendataria;
	}

	public DDSiNoNoAplica getRatificacion() {
		return ratificacion;
	}

	public void setRatificacion(DDSiNoNoAplica ratificacion) {
		this.ratificacion = ratificacion;
	}

	public DDSituacionInicialInscripcion getSituacionInicialInscripcion() {
		return situacionInicialInscripcion;
	}

	public void setSituacionInicialInscripcion(DDSituacionInicialInscripcion situacionInicialInscripcion) {
		this.situacionInicialInscripcion = situacionInicialInscripcion;
	}

	public DDSituacionPosesoriaInicial getPosesoriaInicial() {
		return posesoriaInicial;
	}

	public void setPosesoriaInicial(DDSituacionPosesoriaInicial posesoriaInicial) {
		this.posesoriaInicial = posesoriaInicial;
	}

	public DDSituacionInicialCargas getSituacionInicialCargas() {
		return situacionInicialCargas;
	}

	public void setSituacionInicialCargas(DDSituacionInicialCargas situacionInicialCargas) {
		this.situacionInicialCargas = situacionInicialCargas;
	}

	public DDTipoTitularidad getTipoTitularidad() {
		return tipoTitularidad;
	}

	public void setTipoTitularidad(DDTipoTitularidad tipoTitularidad) {
		this.tipoTitularidad = tipoTitularidad;
	}

	public DDAutorizacionTransmision getEstadoAutorizaTransmision() {
		return estadoAutorizaTransmision;
	}

	public void setEstadoAutorizaTransmision(DDAutorizacionTransmision estadoAutorizaTransmision) {
		this.estadoAutorizaTransmision = estadoAutorizaTransmision;
	}

	public DDAnotacionConcurso getAnotacionConcurso() {
		return anotacionConcurso;
	}

	public void setAnotacionConcurso(DDAnotacionConcurso anotacionConcurso) {
		this.anotacionConcurso = anotacionConcurso;
	}

	public DDEstadoGestion getEstadoGestionCa() {
		return estadoGestionCa;
	}

	public void setEstadoGestionCa(DDEstadoGestion estadoGestionCa) {
		this.estadoGestionCa = estadoGestionCa;
	}

	public DDSinSiNo getConsFisica() {
		return consFisica;
	}

	public void setConsFisica(DDSinSiNo consFisica) {
		this.consFisica = consFisica;
	}

	public DDSinSiNo getConsJuridica() {
		return consJuridica;
	}

	public void setConsJuridica(DDSinSiNo consJuridica) {
		this.consJuridica = consJuridica;
	}

	public DDEstadoGestion getEstadoAfoActaFinObra() {
		return estadoAfoActaFinObra;
	}

	public void setEstadoAfoActaFinObra(DDEstadoGestion estadoAfoActaFinObra) {
		this.estadoAfoActaFinObra = estadoAfoActaFinObra;
	}

	public DDLicenciaPrimeraOcupacion getLicenciaPrimeraOcupacion() {
		return licenciaPrimeraOcupacion;
	}

	public void setLicenciaPrimeraOcupacion(DDLicenciaPrimeraOcupacion licenciaPrimeraOcupacion) {
		this.licenciaPrimeraOcupacion = licenciaPrimeraOcupacion;
	}

	public DDBoletines getBoletines() {
		return boletines;
	}

	public void setBoletines(DDBoletines boletines) {
		this.boletines = boletines;
	}

	public DDSeguroDecenal getSeguroDecenal() {
		return seguroDecenal;
	}

	public void setSeguroDecenal(DDSeguroDecenal seguroDecenal) {
		this.seguroDecenal = seguroDecenal;
	}

	public DDCedulaHabitabilidad getCedulaHabitibilidad() {
		return cedulaHabitibilidad;
	}

	public void setCedulaHabitibilidad(DDCedulaHabitabilidad cedulaHabitibilidad) {
		this.cedulaHabitibilidad = cedulaHabitibilidad;
	}

	public DDTipoArrendamiento getTipoArrendamiento() {
		return tipoArrendamiento;
	}

	public void setTipoArrendamiento(DDTipoArrendamiento tipoArrendamiento) {
		this.tipoArrendamiento = tipoArrendamiento;
	}

	public DDSinSiNo getNotificarArrendatarios() {
		return notificarArrendatarios;
	}

	public void setNotificarArrendatarios(DDSinSiNo notificarArrendatarios) {
		this.notificarArrendatarios = notificarArrendatarios;
	}

	public DDTipoExpediente getTipoExpediente() {
		return tipoExpediente;
	}

	public void setTipoExpediente(DDTipoExpediente tipoExpediente) {
		this.tipoExpediente = tipoExpediente;
	}

	public DDEstadoGestion getEstadoGestionEa() {
		return estadoGestionEa;
	}

	public void setEstadoGestionEa(DDEstadoGestion estadoGestionEa) {
		this.estadoGestionEa = estadoGestionEa;
	}

	public DDTipoIncidenciaRegistral getTipoIncidenciaRegistral() {
		return tipoIncidenciaRegistral;
	}

	public void setTipoIncidenciaRegistral(DDTipoIncidenciaRegistral tipoIncidenciaRegistral) {
		this.tipoIncidenciaRegistral = tipoIncidenciaRegistral;
	}

	public DDEstadoGestion getEstadoGestionCr() {
		return estadoGestionCr;
	}

	public void setEstadoGestionCr(DDEstadoGestion estadoGestionCr) {
		this.estadoGestionCr = estadoGestionCr;
	}

	public DDTipoOcupacionLegal getTipoOcupacionLegal() {
		return tipoOcupacionLegal;
	}

	public void setTipoOcupacionLegal(DDTipoOcupacionLegal tipoOcupacionLegal) {
		this.tipoOcupacionLegal = tipoOcupacionLegal;
	}

	public DDEstadoGestion getEstadoGestionIl() {
		return estadoGestionIl;
	}

	public void setEstadoGestionIl(DDEstadoGestion estadoGestionIl) {
		this.estadoGestionIl = estadoGestionIl;
	}

	public DDEstadoGestion getEstadoGestionOt() {
		return estadoGestionOt;
	}

	public void setEstadoGestionOt(DDEstadoGestion estadoGestionOt) {
		this.estadoGestionOt = estadoGestionOt;
	}

	public Date getFechaRevisionTitulo() {
		return fechaRevisionTitulo;
	}

	public void setFechaRevisionTitulo(Date fechaRevisionTitulo) {
		this.fechaRevisionTitulo = fechaRevisionTitulo;
	}

	public Double getPorcentajePropiedad() {
		return porcentajePropiedad;
	}

	public void setPorcentajePropiedad(Double porcentajePropiedad) {
		this.porcentajePropiedad = porcentajePropiedad;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Double getPorcentajeConsTasacionCf() {
		return porcentajeConsTasacionCf;
	}

	public void setPorcentajeConsTasacionCf(Double porcentajeConsTasacionCf) {
		this.porcentajeConsTasacionCf = porcentajeConsTasacionCf;
	}

	public Double getPorcentajeConsTasacionCj() {
		return porcentajeConsTasacionCj;
	}

	public void setPorcentajeConsTasacionCj(Double porcentajeConsTasacionCj) {
		this.porcentajeConsTasacionCj = porcentajeConsTasacionCj;
	}

	public Date getFechaContratoAlquiler() {
		return fechaContratoAlquiler;
	}

	public void setFechaContratoAlquiler(Date fechaContratoAlquiler) {
		this.fechaContratoAlquiler = fechaContratoAlquiler;
	}

	public String getLegislacionAplicableAlquiler() {
		return legislacionAplicableAlquiler;
	}

	public void setLegislacionAplicableAlquiler(String legislacionAplicableAlquiler) {
		this.legislacionAplicableAlquiler = legislacionAplicableAlquiler;
	}

	public String getDuracionContratoAlquiler() {
		return duracionContratoAlquiler;
	}

	public void setDuracionContratoAlquiler(String duracionContratoAlquiler) {
		this.duracionContratoAlquiler = duracionContratoAlquiler;
	}

	public String getTipoIncidenciaIloc() {
		return tipoIncidenciaIloc;
	}

	public void setTipoIncidenciaIloc(String tipoIncidenciaIloc) {
		this.tipoIncidenciaIloc = tipoIncidenciaIloc;
	}

	public String getDeterioroGrave() {
		return deterioroGrave;
	}

	public void setDeterioroGrave(String deterioroGrave) {
		this.deterioroGrave = deterioroGrave;
	}

	public String getTipoIncidenciaOtros() {
		return tipoIncidenciaOtros;
	}

	public void setTipoIncidenciaOtros(String tipoIncidenciaOtros) {
		this.tipoIncidenciaOtros = tipoIncidenciaOtros;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	@Override
	public Auditoria getAuditoria() {
		return this.auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
		
	}

	public DDEstadoGestion getEstadoCertificadoFinObra() {
		return estadoCertificadoFinObra;
	}

	public void setEstadoCertificadoFinObra(DDEstadoGestion estadoCertificadoFinObra) {
		this.estadoCertificadoFinObra = estadoCertificadoFinObra;
	}


	

}
