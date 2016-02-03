package es.pfsgroup.plugins.domain;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dsm.model.Entidad;
@Entity
@Table(name = "EPL_ENTIDAD_PLUGIN", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class EntidadPlugin implements Serializable, Auditable{

	private static final long serialVersionUID = -3265768943362017097L;

	@Id
    @Column(name = "EPL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EntidadPluginGenerator")
    @SequenceGenerator(name = "EntidadPluginGenerator", sequenceName = "${master.schema}.S_EPL_ENTIDAD_PLUGIN")
	private Long id;
	
	@Column(name = "EPL_PLUGIN_CODE",nullable = false)
	private String pluginCode;
	
	@JoinColumn(name = "ENTIDAD_ID", nullable = false)
    @ManyToOne(fetch = FetchType.EAGER)
	private Entidad entidad;
	
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

	public String getPluginCode() {
		return pluginCode;
	}

	public void setPluginCode(String pluginCode) {
		this.pluginCode = pluginCode;
	}

	public Entidad getEntidad() {
		return entidad;
	}

	public void setEntidad(Entidad entidad) {
		this.entidad = entidad;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

	

}
