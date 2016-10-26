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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencion;


/**
 * Modelo que gestiona la información de los activos integrados.
 * 
 * @author Daniel Gutiérrez
 *
 */
@Entity
@Table(name = "AIN_ACTIVO_INTEGRADO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoIntegrado implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "AIN_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoIntegradoGenerator")
    @SequenceGenerator(name = "ActivoIntegradoGenerator", sequenceName = "S_AIN_ACTIVO_INTEGRADO")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PVE_ID")
	private ActivoProveedor proveedor;
	
	@Column(name = "AIN_PARTICIPACION")
	private Double participacion;
	
	@Column(name = "AIN_FECHA_INCLUSION")
	private Date fechaInclusion;
	
	@Column(name = "AIN_FECHA_EXCLUSION")
	private Date fechaExclusion;
	
	@Column(name = "AIN_MOTIVO_EXCLUSION")
	private String motivoExclusion;
	
	@Column(name = "AIN_OBSERVACIONES")
	private String observaciones;
	
	@Column(name = "AIN_PAGO_RETENIDO")
	private Integer retenerPago;
	
	@ManyToOne
	@JoinColumn(name = "DD_MRE_ID")
	private DDMotivoRetencion motivoRetencion;
	
	@Column(name = "AIN_FECHA_RETENCION_PAGO")
	private Date fechaRetencionPago;
	
    
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public ActivoProveedor getProveedor() {
		return proveedor;
	}

	public void setProveedor(ActivoProveedor proveedor) {
		this.proveedor = proveedor;
	}

	public Double getParticipacion() {
		return participacion;
	}

	public void setParticipacion(Double participacion) {
		this.participacion = participacion;
	}

	public Date getFechaInclusion() {
		return fechaInclusion;
	}

	public void setFechaInclusion(Date fechaInclusion) {
		this.fechaInclusion = fechaInclusion;
	}

	public Date getFechaExclusion() {
		return fechaExclusion;
	}

	public void setFechaExclusion(Date fechaExclusion) {
		this.fechaExclusion = fechaExclusion;
	}

	public String getMotivoExclusion() {
		return motivoExclusion;
	}

	public void setMotivoExclusion(String motivoExclusion) {
		this.motivoExclusion = motivoExclusion;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Integer getRetenerPago() {
		return retenerPago;
	}

	public void setRetenerPago(Integer retenerPago) {
		this.retenerPago = retenerPago;
	}

	public Date getFechaRetencionPago() {
		return fechaRetencionPago;
	}

	public void setFechaRetencionPago(Date fechaRetencionPago) {
		this.fechaRetencionPago = fechaRetencionPago;
	}

	public DDMotivoRetencion getMotivoRetencion() {
		return motivoRetencion;
	}

	public void setMotivoRetencion(DDMotivoRetencion motivoRetencion) {
		this.motivoRetencion = motivoRetencion;
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
