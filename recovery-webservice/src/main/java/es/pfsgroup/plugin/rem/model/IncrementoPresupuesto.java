package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.Locale;

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
 * Modelo que gestiona la información de los incrementos de presupuestos de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_INP_INC_PRESUPUESTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class IncrementoPresupuesto implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;		
	
	@Id
    @Column(name = "INP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "IncrementoPresupuestoGenerator")
    @SequenceGenerator(name = "IncrementoPresupuestoGenerator", sequenceName = "S_ACT_INP_INC_PRESUPUESTO")
    private Long id;	

    @ManyToOne
    @JoinColumn(name = "PTO_ID")
    private PresupuestoActivo presupuestoActivo;
    
    @ManyToOne
    @JoinColumn(name = "TBJ_ID")
	private Trabajo trabajo;
	
	@Column(name = "INP_IMPORTE_INCREMENTO")
	private Float importeIncremento;
	
	@Column(name = "INP_FECHA_APROBACION")
	private Date fechaAprobacion;
	
	
	
	
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

	public PresupuestoActivo getPresupuestoActivo() {
		return presupuestoActivo;
	}

	public void setPresupuestoActivo(PresupuestoActivo presupuestoActivo) {
		this.presupuestoActivo = presupuestoActivo;
	}

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
	}

	public Float getImporteIncremento() {
		return importeIncremento;
	}

	public void setImporteIncremento(Float importeIncremento) {
		this.importeIncremento = importeIncremento;
	}

	public void setImporteIncremento(String importeIncremento) {
		//Si el importe de incremento proviene de una pantalla (viene como String), 
		// es necesario parsear el valor para ajustar el formato de zona.
		NumberFormat valorNumericoZona = NumberFormat.getInstance(new Locale("es","ES"));
		try {
			this.importeIncremento = valorNumericoZona.parse(importeIncremento).floatValue();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public Date getFechaAprobacion() {
		return fechaAprobacion;
	}

	public void setFechaAprobacion(Date fechaAprobacion) {
		this.fechaAprobacion = fechaAprobacion;
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
