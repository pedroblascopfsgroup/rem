package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGasto;



/**
 * Modelo que gestiona la Configuracion Subcartera Posesion
 * 
 * @author Juan Jose Sanjuan
 *
 */
@Entity
@Table(name = "CSP_CONFIG_SUBCARTERA_POSESION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ConfiguracionSubcarteraPosesion implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7785802535778510517L;

	@Id
    @Column(name = "CSP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfiguracionSubcarteraPosesionGenerator")
    @SequenceGenerator(name = "ConfiguracionSubcarteraPosesionGenerator", sequenceName = "S_CSP_CONFIG_SUBCARTERA_POSESION")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_SCR_ID")
	private DDSubcartera subcartera;	
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

    /**
     * Constructor.
     */
    public ConfiguracionSubcarteraPosesion() {}

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
