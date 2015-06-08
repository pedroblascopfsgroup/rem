package es.capgemini.pfs.contrato.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "ACN_ANTECED_CONTRATOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class AcnAntecedContratos implements Serializable, Auditable{

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name="CNT_ID")
	private Long id;
	
	@Column(name="ACN_NUM_REINCIDEN")
	private Integer numeroReincidencias;
	
	@Version
    private Integer version;
	
	@Embedded
	private Auditoria auditoria;

	public Integer getNumeroReincidencias() {
		return numeroReincidencias;
	}


	public Long getId() {
		return id;
	}


	public void setId(Long id) {
		this.id = id;
	}


	public void setNumeroReincidencias(Integer numeroReincidencias) {
		this.numeroReincidencias = numeroReincidencias;
	}

	public Integer getVersion() {
		return version;
	}


	public void setVersion(Integer version) {
		this.version = version;
	}


	public Auditoria getAuditoria() {
		
		return auditoria;
	}

	
	public void setAuditoria(Auditoria auditoria) {
		
		this.auditoria = auditoria;
		
	}
	
	

}
