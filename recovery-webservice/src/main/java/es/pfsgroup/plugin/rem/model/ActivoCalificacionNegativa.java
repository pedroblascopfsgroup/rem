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
import javax.persistence.OneToOne;
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

/**
 * Modelo que gestiona la calificacion negativa de un activo
 * 
 * @author Juanjo Arbona
 */
@Entity
@Table(name = "ACT_CAN_CALIFICACION_NEG", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoCalificacionNegativa implements Serializable, Auditable {


	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ACT_CAN_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoCalificacionNegativaGenerator")
    @SequenceGenerator(name = "ActivoCalificacionNegativaGenerator", sequenceName = "S_ACT_CAN_CALIFICACION_NEG")
    private Long id;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MCN_ID")
    private DDMotivoCalificacionNegativa motivoCalificacionNegativa;
    
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_CAN_ID")
	private DDCalificacionNegativa calificacionNegativa;
    
    @Column(name = "CAN_DESCRIPCION")
	private String descripcion;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_EMN_ID")
  	private DDEstadoMotivoCalificacionNegativa estadoMotivoCalificacioNegativa;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_RSU_ID")
  	private DDResponsableSubsanar responsableSubsanar;
    
    @Column(name = "ACT_FECHA_SUBSANACION")
	private Date fechaSubsanacion;

    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "AHT_ID")
  	private HistoricoTramitacionTitulo historicoTramitacionTitulo;
    
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	public Date getFechaSubsanacion() {
		return fechaSubsanacion;
	}

	public void setFechaSubsanacion(Date fechaSubsanacion) {
		this.fechaSubsanacion = fechaSubsanacion;
	}

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

	public DDMotivoCalificacionNegativa getMotivoCalificacionNegativa() {
		return motivoCalificacionNegativa;
	}

	public void setMotivoCalificacionNegativa(DDMotivoCalificacionNegativa motivoCalificacionNegativa) {
		this.motivoCalificacionNegativa = motivoCalificacionNegativa;
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
	

	public DDEstadoMotivoCalificacionNegativa getEstadoMotivoCalificacionNegativa() {
		return estadoMotivoCalificacioNegativa;
	}

	public void setEstadoMotivoCalificacionNegativa(DDEstadoMotivoCalificacionNegativa estadoMotivoCalificacioNegativa) {
		this.estadoMotivoCalificacioNegativa = estadoMotivoCalificacioNegativa;
	}
	
	public DDResponsableSubsanar getResponsableSubsanar () {
		return responsableSubsanar;
	}
	public void setResponsableSubsanar(DDResponsableSubsanar responsableSubsanar) {
		this.responsableSubsanar = responsableSubsanar;
	}

	public HistoricoTramitacionTitulo getHistoricoTramitacionTitulo() {
		return historicoTramitacionTitulo;
	}

	public void setHistoricoTramitacionTitulo(HistoricoTramitacionTitulo historicoTramitacionTitulo) {
		this.historicoTramitacionTitulo = historicoTramitacionTitulo;
	}
	
}
