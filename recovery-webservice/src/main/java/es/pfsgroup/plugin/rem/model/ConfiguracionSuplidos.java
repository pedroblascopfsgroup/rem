package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGasto;

/**
 * Modelo que gestiona la tabla de configuracion de suplidos
 * @author Cristian Montoya
 *
 */
@Entity
@Table(name = "ACT_CONFIG_SUPLIDOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class ConfiguracionSuplidos implements Auditable, Serializable {
		    
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "SUP_ID")	
    private Long id;    

	@ManyToOne
	@JoinColumn(name = "DD_CRA_ID")
	private DDCartera cartera;
	
	@ManyToOne
	@JoinColumn(name = "DD_SCR_ID")
	private DDSubcartera subCartera;
	
	@ManyToOne
	@JoinColumn(name = "DD_TGA_ID")
	private DDTipoGasto tipoGasto;
	
	@ManyToOne
	@JoinColumn(name = "DD_STG_ID")
	private DDSubtipoGasto subtipoGasto;
	    	    
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

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDSubcartera getSubCartera() {
		return subCartera;
	}

	public void setSubCartera(DDSubcartera subCartera) {
		this.subCartera = subCartera;
	}

	public DDTipoGasto getTipoGasto() {
		return tipoGasto;
	}

	public void setTipoGasto(DDTipoGasto tipoGasto) {
		this.tipoGasto = tipoGasto;
	}

	public DDSubtipoGasto getSubtipoGasto() {
		return subtipoGasto;
	}

	public void setSubtipoGasto(DDSubtipoGasto subtipoGasto) {
		this.subtipoGasto = subtipoGasto;
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
