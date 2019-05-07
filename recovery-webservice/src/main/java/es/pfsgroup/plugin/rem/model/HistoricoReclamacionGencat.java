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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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
@Table(name = "ACT_HRG_HIST_RECLAM_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class HistoricoReclamacionGencat implements Serializable, Auditable {
	
	private static final long serialVersionUID = -8762337597075995673L;

	@Id
    @Column(name = "HRG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoReclamacionGencatGenerator")
    @SequenceGenerator(name = "HistoricoReclamacionGencatGenerator", sequenceName = "S_ACT_HRG_HIST_RECLAM_GENCAT")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "HCG_ID")
	private HistoricoComunicacionGencat historicoComunicacion;
	
	@Column(name = "HRG_FECHA_AVISO")
	private Date fechaAviso;
	
	@Column(name = "HRG_FECHA_RECLAMACION")
	private Date fechaReclamacion;
	
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

	public Date getFechaAviso() {
		return fechaAviso;
	}

	public void setFechaAviso(Date fechaAviso) {
		this.fechaAviso = fechaAviso;
	}

	public Date getFechaReclamacion() {
		return fechaReclamacion;
	}

	public void setFechaReclamacion(Date fechaReclamacion) {
		this.fechaReclamacion = fechaReclamacion;
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
