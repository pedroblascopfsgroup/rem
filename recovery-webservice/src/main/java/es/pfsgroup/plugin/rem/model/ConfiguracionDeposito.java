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
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

/**
 * Modelo que gestiona la tabla de configuracion deposito
 * 
 * 
 * @author IRF
 */
@Entity
@Table(name = "COD_CONFIGURACION_DEPOSITO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ConfiguracionDeposito implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "COD_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfiguracionDepositoGenerator")
	@SequenceGenerator(name = "ConfiguracionDepositoGenerator", sequenceName = "S_ALB_ALBARAN")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_SRC_ID")
	private DDSubcartera subcartera;

	@Column(name = "COD_DEPOSITO_NECESARIO")
	private String depositoNecesario;
	
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

	public DDSubcartera getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(DDSubcartera subcartera) {
		this.subcartera = subcartera;
	}

	public String getDepositoNecesario() {
		return depositoNecesario;
	}

	public void setDepositoNecesario(String depositoNecesario) {
		this.depositoNecesario = depositoNecesario;
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
