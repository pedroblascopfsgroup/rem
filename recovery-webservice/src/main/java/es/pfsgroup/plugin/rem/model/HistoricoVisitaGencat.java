package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
@Table(name = "ACT_HVG_HIST_VISITA_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class HistoricoVisitaGencat implements Serializable, Auditable {

	private static final long serialVersionUID = -4429075330108977278L;
	
	@Id
    @Column(name = "HVG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoVisitaGencatGenerator")
    @SequenceGenerator(name = "HistoricoVisitaGencatGenerator", sequenceName = "S_ACT_HVG_HIST_VISITA_GENCAT")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "HCG_ID")
	private HistoricoComunicacionGencat historicoComunicacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "VIS_ID")
	private Visita visita;
	
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

	public HistoricoComunicacionGencat getHistoricoComunicacion() {
		return historicoComunicacion;
	}

	public void setHistoricoComunicacion(HistoricoComunicacionGencat historicoComunicacion) {
		this.historicoComunicacion = historicoComunicacion;
	}

	public Visita getVisita() {
		return visita;
	}

	public void setVisita(Visita visita) {
		this.visita = visita;
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
