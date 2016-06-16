package es.capgemini.pfs.expediente.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa la entidad Sancion.
 */

@Entity
@Table(name = "SAE_SANCION_EXPEDIENTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Sancion implements Serializable, Auditable {
    
	public static final String CODIGO_DECISION_SANCION_APROBADA = "APRB";
	public static final String CODIGO_DECISION_SANCION_APROBADA_CON_CONDICIONES = "APRB_COND";
	public static final String CODIGO_DECISION_SANCION_RECHAZADA = "RECHZ";
	
	private static final long serialVersionUID = -1353637087467504894L;

    @Id
    @Column(name = "SAE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "SancionGenerator")
    @SequenceGenerator(name = "SancionGenerator", sequenceName = "S_SAE_SANCION_EXPEDIENTE")
    private Long id;

	@ManyToOne
    @JoinColumn(name = "DD_DES_ID")
    private DDDecisionSancion decision;
	
	@Column(name = "SAE_FECHA_ELEVACION")
    private Date fechaElevacion;
	
	@Column(name = "SAE_FECHA_SANCION")
    private Date fechaSancion;
	
	@Column(name = "SAE_NUMERO_WORK_FLOW")
    private String numWorkFlow;
	
	@Column(name="SAE_OBSERVACION")
	private String observaciones;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;


    public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDDecisionSancion getDecision() {
		return decision;
	}

	public void setDecision(DDDecisionSancion decision) {
		this.decision = decision;
	}

	public Date getFechaElevacion() {
		return fechaElevacion;
	}

	public void setFechaElevacion(Date fechaElevacion) {
		this.fechaElevacion = fechaElevacion;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}

	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public String getNumWorkFlow() {
		return numWorkFlow;
	}

	public void setNumWorkFlow(String numWorkFlow) {
		this.numWorkFlow = numWorkFlow;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
