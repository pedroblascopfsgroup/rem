package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import es.pfsgroup.plugin.rem.model.dd.DDTipoAdelanto;



/**
 * Modelo que gestiona la información de las provisiones y suplidos de los trabajos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_PSU_PROVISION_SUPLIDO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class TrabajoProvisionSuplido implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;		

	
	@Id
    @Column(name = "PSU_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TrabajoProvisionSuplidoGenerator")
    @SequenceGenerator(name = "TrabajoProvisionSuplidoGenerator", sequenceName = "S_ACT_PSU_PROVISION_SUPLIDO")
    private Long id;	
   
    @ManyToOne
    @JoinColumn(name = "TBJ_ID")
	private Trabajo trabajo;
    
    @ManyToOne
    @JoinColumn(name = "DD_TAD_ID")
    private DDTipoAdelanto tipoAdelanto;
	
    @Column(name = "PSU_CONCEPTO")
	private String concepto;
    
    @Column(name = "PSU_IMPORTE")
	private Double importe;
	
	@Column(name = "PSU_FECHA")
	private Date fecha;
	
	
	
	
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

	public DDTipoAdelanto getTipoAdelanto() {
		return tipoAdelanto;
	}

	public void setTipoAdelanto(DDTipoAdelanto tipoAdelanto) {
		this.tipoAdelanto = tipoAdelanto;
	}

	public String getConcepto() {
		return concepto;
	}

	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
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
