package es.pfsgroup.plugin.rem.model;

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
import es.capgemini.pfs.direccion.model.Localidad;


/**
 * Modelo que gestiona la configuración de municipios.
 */
@Entity
@Table(name = "CMU_CONFIG_MUNICIPIOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ConfiguracionMunicipios implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CMU_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfiguracionMunicipiosGenerator")
    @SequenceGenerator(name = "ConfiguracionMunicipiosGenerator", sequenceName = "S_CMU_CONFIG_MUNICIPIOS")
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "DD_LOC_ID")
    private Localidad localidad; 

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

	public Localidad getLocalidad() {
		return localidad;
	}

	public void setLocalidad(Localidad localidad) {
		this.localidad = localidad;
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