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
import es.pfsgroup.plugin.rem.model.dd.DDResultadoCampo;



/**
 * Modelo que gestiona el historico de scoring de alquiler
 * 
 * @author Sergio Beleña
 *
 */
@Entity
@Table(name = "SCO_HIS_SCORING", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class HistoricoScoringAlquiler implements Serializable,Auditable  {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "SCO_HIS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoScoringAlquilerGenerator")
    @SequenceGenerator(name = "HistoricoScoringAlquilerGenerator", sequenceName = "S_SCO_HIS_SCORING")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SCO_ID")
    private ScoringAlquiler scoringAlquiler;
	
	
	@Column(name = "SCO_HIS_FECHA_SANCION")
	private Date fechaSancion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_REC_ID")
	private DDResultadoCampo resultadoScoring;
	
	@Column(name = "SCO_HIS_ID_SOLICITUD")
	private String idSolicitud;
	
	@Column(name = "SCO_HIS_DOCUMENTO_SCORING")
	private String documentoScoring;
	
	@Column(name = "SCO_HIS_MESES_FIANZA")
	private Integer mesesFianza;
	
	@Column(name = "SCO_HIS_IMPORTE_FIANZA")
	private Long importFianza;
	
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

	public ScoringAlquiler getScoringAlquiler() {
		return scoringAlquiler;
	}

	public void setScoringAlquiler(ScoringAlquiler scoringAlquiler) {
		this.scoringAlquiler = scoringAlquiler;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}

	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public String getIdSolicitud() {
		return idSolicitud;
	}

	public void setIdSolicitud(String idSolicitud) {
		this.idSolicitud = idSolicitud;
	}

	public String getDocumentoScoring() {
		return documentoScoring;
	}

	public void setDocumentoScoring(String documentoScoring) {
		this.documentoScoring = documentoScoring;
	}

	public Integer getMesesFianza() {
		return mesesFianza;
	}

	public void setMesesFianza(Integer mesesFianza) {
		this.mesesFianza = mesesFianza;
	}

	public Long getImportFianza() {
		return importFianza;
	}

	public void setImportFianza(Long importFianza) {
		this.importFianza = importFianza;
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

	public DDResultadoCampo getResultadoScoring() {
		return resultadoScoring;
	}

	public void setResultadoScoring(DDResultadoCampo resultadoScoring) {
		this.resultadoScoring = resultadoScoring;
	}

}
