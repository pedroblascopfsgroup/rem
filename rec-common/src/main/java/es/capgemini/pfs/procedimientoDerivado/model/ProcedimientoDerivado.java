package es.capgemini.pfs.procedimientoDerivado.model;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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
import org.hibernate.annotations.Cascade;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;

/**
 * PONER JAVADOC FO.
 * @author fo
 *
 */
@Entity
@Table(name = "PRD_PROCEDIMIENTOS_DERIVADOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ProcedimientoDerivado implements Auditable, Serializable {
	/**
	 * serialVersionUID.
	 */
	private static final long serialVersionUID = -6939044306440437957L;

	@Id
	@Column(name = "PRD_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ProcedimientoDerivadoGenerator")
	@SequenceGenerator(name = "ProcedimientoDerivadoGenerator", sequenceName = "S_PRD_PROCED_DERIVADOS")
	private Long id;

	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "DPR_ID")
	@Cascade({org.hibernate.annotations.CascadeType.ALL})
	private DecisionProcedimiento decisionProcedimiento;

	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "PRC_ID")
	@Cascade({org.hibernate.annotations.CascadeType.ALL})
	private Procedimiento procedimiento;

    @Column(name="SYS_GUID")
	private String guid;
	
	@Version
	private Long version;

	@Embedded
	private Auditoria auditoria;

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the decisionProcedimiento
	 */
	public DecisionProcedimiento getDecisionProcedimiento() {
		return decisionProcedimiento;
	}

	/**
	 * @param decisionProcedimiento the decisionProcedimiento to set
	 */
	public void setDecisionProcedimiento(DecisionProcedimiento decisionProcedimiento) {
		this.decisionProcedimiento = decisionProcedimiento;
	}

	/**
	 * @return the procedimiento
	 */
	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	/**
	 * @param procedimiento the procedimiento to set
	 */
	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	/**
	 * @return the guid
	 */
	public String getGuid() {
		return guid;
	}

	/**
	 * @param guid the guid to set
	 */
	public void setGuid(String guid) {
		this.guid = guid;
	}

	/**
	 * @return the version
	 */
	public Long getVersion() {
		return version;
	}

	/**
	 * @param version the version to set
	 */
	public void setVersion(Long version) {
		this.version = version;
	}

	/**
	 * @return the auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * @param auditoria the auditoria to set
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
