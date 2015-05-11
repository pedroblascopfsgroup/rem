package es.pfsgroup.recovery.recobroCommon.esquema.model;

import java.io.Serializable;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;

/**
 * Clase donde se relacionan las Subcarteras con su reparto de Agencias
 * @author Diana
 *
 */
@Entity
@Table(name = "RCF_SUA_SUBCARTERA_AGENCIAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroSubcarteraAgencia implements Auditable, Serializable {
	
	private static final long serialVersionUID = 3942949594730121658L;

	@Id
    @Column(name = "RCF_SUA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SubcarteraAgenciaGenerator")
	@SequenceGenerator(name = "SubcarteraAgenciaGenerator", sequenceName = "S_RCF_SUA_SUBCARTERA_AGENCIAS")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "RCF_AGE_ID", nullable = false)
	private RecobroAgencia agencia;
	
	@ManyToOne
	@JoinColumn(name = "RCF_SCA_ID", nullable = false)
	private RecobroSubCartera subCartera;
	
	@Column(name = "RCF_SUA_COEFICIENTE")
	private Integer reparto;	
	
	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public RecobroAgencia getAgencia() {
		return agencia;
	}

	public void setAgencia(RecobroAgencia agencia) {
		this.agencia = agencia;
	}

	public RecobroSubCartera getSubCartera() {
		return subCartera;
	}

	public void setSubCartera(RecobroSubCartera subCartera) {
		this.subCartera = subCartera;
	}

	public Integer getReparto() {
		return reparto;
	}

	public void setReparto(Integer reparto) {
		this.reparto = reparto;
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
