package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDMetodoActualizacionRenta;


/**
 *  
 * @author Lara Pablo
 *
 */
@Entity
@Table(name = "ARL_ACTU_RENTA_LIBRE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ActualizacionRentaLibre implements Serializable, Auditable {

	private static final long serialVersionUID = -2333323398245528237L;


	@Id
    @Column(name = "ARL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActualizacionRentaLibreGenerator")
    @SequenceGenerator(name = "ActualizacionRentaLibreGenerator", sequenceName = "S_ARL_ACTU_RENTA_LIBRE")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COE_ID")
    private CondicionanteExpediente condicionanteExpediente;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MTA_ID")
	private DDMetodoActualizacionRenta metodoActualizacionRenta;
    
    @Column(name="ARL_FECHA_ACTU")
    private Date fechaActualizacion;
    
    @Column(name="ARL_IMPORTE_ACTU")
    private Double importeActualizacion;
    
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

	public CondicionanteExpediente getCondicionanteExpediente() {
		return condicionanteExpediente;
	}

	public void setCondicionanteExpediente(CondicionanteExpediente condicionanteExpediente) {
		this.condicionanteExpediente = condicionanteExpediente;
	}

	public DDMetodoActualizacionRenta getMetodoActualizacionRenta() {
		return metodoActualizacionRenta;
	}

	public void setMetodoActualizacionRenta(DDMetodoActualizacionRenta metodoActualizacionRenta) {
		this.metodoActualizacionRenta = metodoActualizacionRenta;
	}

	public Date getFechaActualizacion() {
		return fechaActualizacion;
	}

	public void setFechaActualizacion(Date fechaActualizacion) {
		this.fechaActualizacion = fechaActualizacion;
	}

	public Double getImporteActualizacion() {
		return importeActualizacion;
	}

	public void setImporteActualizacion(Double importeActualizacion) {
		this.importeActualizacion = importeActualizacion;
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
