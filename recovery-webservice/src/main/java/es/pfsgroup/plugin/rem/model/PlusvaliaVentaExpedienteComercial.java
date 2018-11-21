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



/**
 * Modelo que gestiona la informacion de los adjuntos de los trabajos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "EPV_ECO_PLUSVALIAVENTA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class PlusvaliaVentaExpedienteComercial implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "EPV_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PlusvaliaVentaExpedienteComercialGenerator")
    @SequenceGenerator(name = "PlusvaliaVentaExpedienteComercialGenerator", sequenceName = "S_EPV_ECO_PLUSVALIAVENTA")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;   	
	
	@Column(name = "EPV_EXENTO")
	private Long exento;
	
	@Column(name = "EPV_AUTOLIQUIDACION")
	private Long autoliquidacion;
	
	@Column(name = "EPV_FECHA_ESCRITO_AYTO")
	private Date fechaEscritoAyt;
	
	@Column(name = "EPV_OBSERVACIONES")
	private String observaciones;
	
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

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	public Long getExento() {
		return exento;
	}

	public void setExento(Long exento) {
		this.exento = exento;
	}

	public Long getAutoliquidacion() {
		return autoliquidacion;
	}

	public void setAutoliquidacion(Long autoliquidacion) {
		this.autoliquidacion = autoliquidacion;
	}

	public Date getFechaEscritoAyt() {
		return fechaEscritoAyt;
	}

	public void setFechaEscritoAyt(Date fechaEscritoAyt) {
		this.fechaEscritoAyt = fechaEscritoAyt;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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
