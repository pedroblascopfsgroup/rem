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
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.capgemini.pfs.direccion.model.DDComunidadAutonoma;



/**
 * Modelo que gestiona la relación entre paises, comunidades autónomas y provincias.
 * 
 * @author Anahuac de Vicente
 */
@Entity
@Table(name = "ACT_CMP_COMAUTONOMA_PROVINCIA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class RelComAutonomaProvincia implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "AJD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RelComAutonomaProvinciaGenerator")
    @SequenceGenerator(name = "RelComAutonomaProvinciaGenerator", sequenceName = "S_ACT_CMP_COMAUTO_PROV")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DD_CIC_ID")
	private DDCicCodigoIsoCirbeBKP pais;
	   
	@ManyToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
    
    @ManyToOne
    @JoinColumn(name = "DD_CMA_ID")
    private DDComunidadAutonoma comunidadAutonoma;
    
   
	

	
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

	public DDCicCodigoIsoCirbeBKP getPais() {
		return pais;
	}
	
	public void setPais(DDCicCodigoIsoCirbeBKP pais) {
		this.pais = pais;
	}
	
	public DDProvincia getProvincia() {
		return provincia;
	}
	
	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}
	
	public DDComunidadAutonoma getComunidadAutonoma() {
		return comunidadAutonoma;
	}
	
	public void setComunidadAutonoma(DDComunidadAutonoma comunidadAutonoma) {
		this.comunidadAutonoma = comunidadAutonoma;
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
