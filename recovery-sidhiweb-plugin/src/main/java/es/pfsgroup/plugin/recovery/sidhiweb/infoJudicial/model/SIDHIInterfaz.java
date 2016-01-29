package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.sidhiweb.api.model.SIDHIInterfazInfo;


@Entity
@Table(name = "SIDHI_CFG_ITF_INTERFAZ", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class SIDHIInterfaz implements Auditable, Serializable, SIDHIInterfazInfo{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 4785176764477098360L;

	@Id
	@Column(name = "ITF_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SIDHIInterfazGenerator")
	@SequenceGenerator(name = "SIDHIInterfazGenerator", sequenceName = "S_SIDHI_CFG_ITF_INTERFAZ")
	private Long id;
	
	@Column(name = "ITF_CODIGO")
	private String codigo;
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.santander.batch.sidhi.infoJudicial.model.SIDHIInterfazInfo#getCodigo()
	 */
	public String getCodigo() {
		return codigo;
	}

	@Override
	public String toString() {
		return "SIDHIInterfaz [codigo=" + codigo + ", id=" + id + "]";
	}

}
