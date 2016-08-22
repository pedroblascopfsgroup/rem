package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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


/**
 * Modelo que gestiona la relación entre los trabajos y las tarifas configuradas para dichos trabajos.
 *  
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_TCT_TRABAJO_CFGTARIFA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class TrabajoConfiguracionTarifa implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "TCT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TrabajoConfiguracionTarifaGenerator")
    @SequenceGenerator(name = "TrabajoConfiguracionTarifaGenerator", sequenceName = "S_ACT_TCT_TRABAJO_CFGTARIFA")
    private Long id;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    private Trabajo trabajo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CFT_ID")
    private ConfiguracionTarifa configTarifa;
     
    @Column(name="TCT_PRECIO_UNITARIO")
    private Float precioUnitario;
    
    @Column(name="TCT_MEDICION")
    private Float medicion;



    
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

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
	}

	public ConfiguracionTarifa getConfigTarifa() {
		return configTarifa;
	}

	public void setConfigTarifa(ConfiguracionTarifa configTarifa) {
		this.configTarifa = configTarifa;
	}

	public Float getPrecioUnitario() {
		return precioUnitario;
	}

	public void setPrecioUnitario(Float precioUnitario) {
		this.precioUnitario = precioUnitario;
	}

	public Float getMedicion() {
		return medicion;
	}

	public void setMedicion(Float medicion) {
		this.medicion = medicion;
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
