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
import es.pfsgroup.plugin.rem.model.dd.DDGarantiasAdicionales;
import es.pfsgroup.plugin.rem.model.dd.DDRatingScoringServicer;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoCampo;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoScoring;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoScoringServicer;



/**
 * Modelo que gestiona el scoring de alquiler
 * 
 * @author Sergio Beleña
 *
 */
@Entity
@Table(name = "SCO_SCORING", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ScoringAlquiler implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "SCO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ScoringAlquilerGenerator")
    @SequenceGenerator(name = "ScoringAlquilerGenerator", sequenceName = "S_SCO_SCORING")
    private Long id;
	
	
	@Column(name = "SCO_MOTIVO_RECHAZO")
    private String motivoRechazo;
	
	
	@Column(name = "SCO_ID_SOLICITUD")
	private String idSolicitud;
	
	@Column(name = "SCO_EN_REVISION")
	private Integer revision;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_REC_ID")
	private DDResultadoCampo resultadoScoring;

	@Column(name = "SCO_COMENTARIOS")
	private String comentarios;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_RAT_ID")
	private DDRatingScoringServicer ratingScoringServicer;  
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_RSE_ID")
	private DDResultadoScoringServicer resultadoScoringServicer;  
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_GAO_ID")
	private DDGarantiasAdicionales garantiasAdicionales;  
	
	@Column(name = "SCO_IMPORTE_GARANTIAS_AD")
    private Double importeGarantiasAdicionales;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_RSB_ID")
	private DDResultadoScoring resultadoScoringBc;
	
	@Column(name = "SCO_FECHA_SANCION_BC")
	private Date fechaSancionBc;
	
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

	public String getMotivoRechazo() {
		return motivoRechazo;
	}

	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}

	public String getIdSolicitud() {
		return idSolicitud;
	}

	public void setIdSolicitud(String idSolicitud) {
		this.idSolicitud = idSolicitud;
	}

	public Integer getRevision() {
		return revision;
	}

	public void setRevision(Integer revision) {
		this.revision = revision;
	}

	public String getComentarios() {
		return comentarios;
	}

	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
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

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	public DDResultadoCampo getResultadoScoring() {
		return resultadoScoring;
	}

	public void setResultadoScoring(DDResultadoCampo resultadoScoring) {
		this.resultadoScoring = resultadoScoring;
	}

	public DDRatingScoringServicer getRatingScoringServicer() {
		return ratingScoringServicer;
	}

	public void setRatingScoringServicer(DDRatingScoringServicer ratingScoringServicer) {
		this.ratingScoringServicer = ratingScoringServicer;
	}

	public DDResultadoScoringServicer getResultadoScoringServicer() {
		return resultadoScoringServicer;
	}

	public void setResultadoScoringServicer(DDResultadoScoringServicer resultadoScoringServicer) {
		this.resultadoScoringServicer = resultadoScoringServicer;
	}

	public DDGarantiasAdicionales getGarantiasAdicionales() {
		return garantiasAdicionales;
	}

	public void setGarantiasAdicionales(DDGarantiasAdicionales garantiasAdicionales) {
		this.garantiasAdicionales = garantiasAdicionales;
	}

	public Double getImporteGarantiasAdicionales() {
		return importeGarantiasAdicionales;
	}

	public void setImporteGarantiasAdicionales(Double importeGarantiasAdicionales) {
		this.importeGarantiasAdicionales = importeGarantiasAdicionales;
	}

	public DDResultadoScoring getResultadoScoringBc() {
		return resultadoScoringBc;
	}

	public void setResultadoScoringBc(DDResultadoScoring resultadoScoringBc) {
		this.resultadoScoringBc = resultadoScoringBc;
	}

	public Date getFechaSancionBc() {
		return fechaSancionBc;
	}

	public void setFechaSancionBc(Date fechaSancionBc) {
		this.fechaSancionBc = fechaSancionBc;
	}
	
}
