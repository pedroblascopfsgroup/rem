package es.pfsgroup.plugin.rem.model;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.io.Serializable;



/**
 * Modelo que gestiona la Configuracion Bloqueo de Asuntos
 * 
 * @author Adrián Molina
 *
 */
@Entity
@Table(name = "CBA_CONFIG_BLOQUEO_ASUNTOS_MINERVA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ConfiguracionBloqueoAsuntosMinerva implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7785802535778510517L;

	@Id
    @Column(name = "CBA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfiguracionBloqueoAsuntosMinervaGenerator")
    @SequenceGenerator(name = "ConfiguracionBloqueoAsuntosMinervaGenerator", sequenceName = "S_CBA_CONFIG_BLOQUEO_ASUNTOS_MINERVA")
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
    public ConfiguracionBloqueoAsuntosMinerva() {}

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
