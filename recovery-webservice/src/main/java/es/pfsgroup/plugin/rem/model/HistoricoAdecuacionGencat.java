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

@Entity
@Table(name = "ACT_HAG_HIST_ADECUA_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class HistoricoAdecuacionGencat implements Serializable, Auditable {

	private static final long serialVersionUID = 5910940035703021446L;
	
	@Id
    @Column(name = "HAG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoAdecuacionGencatGenerator")
    @SequenceGenerator(name = "HistoricoAdecuacionGencatGenerator", sequenceName = "S_ACT_HAG_HIST_ADECUA_GENCAT")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "HCG_ID")
	private HistoricoComunicacionGencat historicoComunicacion;
	
	@Column(name = "HAG_REFORMA")
	private Boolean necesitaReforma;
	
	@Column(name = "HAG_IMPORTE")
	private Double importeReforma;
	
	@Column(name = "HAG_FECHA_REVISION")
	private Date fechaRevision;
	
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

	public HistoricoComunicacionGencat getComunicacion() {
		return historicoComunicacion;
	}

	public void setComunicacion(HistoricoComunicacionGencat historicoComunicacion) {
		this.historicoComunicacion = historicoComunicacion;
	}

	public Boolean getNecesitaReforma() {
		return necesitaReforma;
	}

	public void setNecesitaReforma(Boolean necesitaReforma) {
		this.necesitaReforma = necesitaReforma;
	}

	public Double getImporteReforma() {
		return importeReforma;
	}

	public void setImporteReforma(Double importeReforma) {
		this.importeReforma = importeReforma;
	}

	public Date getFechaRevision() {
		return fechaRevision;
	}

	public void setFechaRevision(Date fechaRevision) {
		this.fechaRevision = fechaRevision;
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
