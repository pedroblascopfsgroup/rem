package es.capgemini.pfs.bien.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * 
 * @author carlos
 *
 */
@Entity
@Table(name = "PRB_PRC_BIE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class ProcedimientoBien implements Serializable, Auditable {
	
	private static final long serialVersionUID = -6225922640471631973L;

	@Id
    @Column(name = "PRB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ProcedimientoBienGenerator")
	@SequenceGenerator(name = "ProcedimientoBienGenerator", sequenceName = "S_PRB_PRC_BIE")
    private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PRC_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private Procedimiento procedimiento;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private Bien bien;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SGB_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private DDSolvenciaGarantia solvenciaGarantia;	
	    
    @Version
    private Integer version;

    @Column(name = "SYS_GUID")
    private String guid;
    
    @Embedded
    private Auditoria auditoria;

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public Bien getBien() {
		return bien;
	}

	public void setBien(Bien bien) {
		this.bien = bien;
	}
	
	public DDSolvenciaGarantia getSolvenciaGarantia() {
		return solvenciaGarantia;
	}

	public void setSolvenciaGarantia(DDSolvenciaGarantia solvenciaGarantia) {
		this.solvenciaGarantia = solvenciaGarantia;
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
