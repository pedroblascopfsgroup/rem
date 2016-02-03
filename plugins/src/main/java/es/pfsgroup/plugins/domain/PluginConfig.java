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
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
@Entity
@Table(name = "PLC_PLUGIN_CONFIG", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class PluginConfig implements Serializable, Auditable{
	
	public PluginConfig() {}
	
	public PluginConfig(String key, String value) {
		super();
		this.key = key;
		this.value = value;
	}

	private static final long serialVersionUID = -8657126115398918466L;

	
	@Id
    @Column(name = "PLC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PluginConfigGenerator")
    @SequenceGenerator(name = "PluginConfigGenerator", sequenceName = "${master.schema}.S_PLC_PLUGIN_CONFIG")
	private Long id;
	
	@Column(name = "PLC_PLUGIN_CODE")
	@NotNull
	@NotEmpty
	private String pluginCode;
	
	@Column(name = "PLC_KEY")
	@NotNull
	@NotEmpty
	private String key;
	
	@Column(name = "PLC_VALUE")
	@NotNull
	@NotEmpty
	private String value;
	
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

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
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

	public void setPluginCode(String pluginCode) {
		this.pluginCode = pluginCode;
	}

	public String getPluginCode() {
		return pluginCode;
	}
	

}
