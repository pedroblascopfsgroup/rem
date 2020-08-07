package es.pfsgroup.plugin.rem.model;

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
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoMotivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDResponsableSubsanar;

@Entity
@Table(name = "ACT_CNA_CALIFICACION_NEG_AD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoCalificacionNegativaAdicional implements Serializable, Auditable{

	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "ACT_CNA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoCalifNegativAdicionalGenerator")
    @SequenceGenerator(name = "ActivoCalifNegativAdicionalGenerator", sequenceName = "S_ACT_CNA_CALIFICACION_NEG_AD")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
	private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MCN_ID")
	private DDMotivoCalificacionNegativa motivoCalifNegativa;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_CAN_ID")
	private DDCalificacionNegativa calificacionNegativa;
	
	@Column(name="CNA_DESCRIPCION")
	private String descripcion;
	
	@Column(name="ACT_FECHA_SUBSANACION")
	private Date fechaSubsanacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_EMN_ID")
	private DDEstadoMotivoCalificacionNegativa estadoCalificacionNegativa;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_RSU_ID")
	private DDResponsableSubsanar responsableSubsanar;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "HTA_ID")
	private ActivoHistoricoTituloAdicional historicoTitulo;
	
	@Column(name="CNA_PRINCIPAL")
	private Long principal;
	
	@Column(name="CNA_MATRICULA_PROP")
	private Long matricula;
	
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

	public DDMotivoCalificacionNegativa getMotivoCalifNegativa() {
		return motivoCalifNegativa;
	}

	public void setMotivoCalifNegativa(DDMotivoCalificacionNegativa motivoCalifNegativa) {
		this.motivoCalifNegativa = motivoCalifNegativa;
	}

	public DDCalificacionNegativa getCalificacionNegativa() {
		return calificacionNegativa;
	}

	public void setCalificacionNegativa(DDCalificacionNegativa calificacionNegativa) {
		this.calificacionNegativa = calificacionNegativa;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Date getFechaSubsanacion() {
		return fechaSubsanacion;
	}

	public void setFechaSubsanacion(Date fechaSubsanacion) {
		this.fechaSubsanacion = fechaSubsanacion;
	}

	public DDEstadoMotivoCalificacionNegativa getEstadoCalificacionNegativa() {
		return estadoCalificacionNegativa;
	}

	public void setEstadoCalificacionNegativa(DDEstadoMotivoCalificacionNegativa estadoCalificacionNegativa) {
		this.estadoCalificacionNegativa = estadoCalificacionNegativa;
	}

	public DDResponsableSubsanar getResponsableSubsanar() {
		return responsableSubsanar;
	}

	public void setResponsableSubsanar(DDResponsableSubsanar responsableSubsanar) {
		this.responsableSubsanar = responsableSubsanar;
	}

	public ActivoHistoricoTituloAdicional getHistoricoTitulo() {
		return historicoTitulo;
	}

	public void setHistoricoTitulo(ActivoHistoricoTituloAdicional historicoTitulo) {
		this.historicoTitulo = historicoTitulo;
	}

	public Long getPrincipal() {
		return principal;
	}

	public void setPrincipal(Long principal) {
		this.principal = principal;
	}

	public Long getMatricula() {
		return matricula;
	}

	public void setMatricula(Long matricula) {
		this.matricula = matricula;
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
}
