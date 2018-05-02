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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCalculoImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;

/**
 * Modelo que gestiona el perímetro de un activo
 * 
 * @author jros
 */
@Entity
@Table(name = "AIA_ADMIN_IMPUESTOS_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ImpuestosActivo implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "AIA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ImpuestosActivoGenerator")
    @SequenceGenerator(name = "ImpuestosActivoGenerator", sequenceName = "S_AIA_ADMIN_IMPUESTOS_ACTIVO")
    private Long id;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STG_ID")
	private DDSubtipoGasto subtipoGasto;
    
    @Column(name= "AIA_FECHA_INI")
    private Date fechaInicio;
    
    @Column(name= "AIA_FECHA_FIN")
    private Date fechaFin;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPE_ID")
	private DDTipoPeriocidad periodicidad;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CAI_ID")
	private DDCalculoImpuesto calculoImpuesto;
	
	@Embedded
	private Auditoria auditoria;
	
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public DDSubtipoGasto getSubtipoGasto() {
		return subtipoGasto;
	}

	public void setSubtipoGasto(DDSubtipoGasto subtipoGasto) {
		this.subtipoGasto = subtipoGasto;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public DDTipoPeriocidad getPeriodicidad() {
		return periodicidad;
	}

	public void setPeriodicidad(DDTipoPeriocidad periodicidad) {
		this.periodicidad = periodicidad;
	}

	public DDCalculoImpuesto getCalculoImpuesto() {
		return calculoImpuesto;
	}

	public void setCalculoImpuesto(DDCalculoImpuesto calculoImpuesto) {
		this.calculoImpuesto = calculoImpuesto;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
