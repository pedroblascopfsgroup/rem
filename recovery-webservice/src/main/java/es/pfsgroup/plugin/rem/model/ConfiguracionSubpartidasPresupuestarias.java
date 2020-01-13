package es.pfsgroup.plugin.rem.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo que gestiona la tabla de configuracion de subpartidas presupuestarias
 * @author Cristian Montoya
 *
 */
@Entity
@Table(name = "CPS_CONFIG_SUBPTDAS_PRE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class ConfiguracionSubpartidasPresupuestarias implements Auditable {
		    
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "CPS_ID")	
    private Long id;    

	@ManyToOne
	@JoinColumn(name = "CCC_ID")
	ConfigCuentaContable configCuentaContable;
	 
	@Column(name = "CPS_DESCRIPCION")   
	private String descripcion;
	    	    
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

	public ConfigCuentaContable getConfigCuentaContable() {
		return configCuentaContable;
	}

	public void setConfigCuentaContable(ConfigCuentaContable configCuentaContable) {
		this.configCuentaContable = configCuentaContable;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
