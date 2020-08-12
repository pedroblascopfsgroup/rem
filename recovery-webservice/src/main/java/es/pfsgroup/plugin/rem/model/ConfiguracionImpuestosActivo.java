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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.dd.DDCalculoImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;


/**
 * Modelo que gestiona la informacion de una oferta
 *
 * @author Cristian Montoya
 *
 */
@Entity
@Table(name = "CIA_CONFIG_IMPUESTOS_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ConfiguracionImpuestosActivo implements Serializable, Auditable {
	
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CIA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfiguracionImpuestosGenerator")
    @SequenceGenerator(name = "ConfiguracionImpuestosGenerator", sequenceName = "S_CIA_CONFIG_IMPUESTOS_ACTIVO")
    private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_UPO_ID")
	private DDUnidadPoblacional unidadPoblacional;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STG_ID")
    private DDSubtipoGasto subtipoGasto;    
	
	@Column(name="CIA_FECHA_INICIO")
	private Date fechaInicio;
	
	@Column(name="CIA_FECHA_FIN")
	private Date fechaFin;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPE_ID")
    private DDTipoPeriocidad tipoPeriocidad;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CAI_ID")
	private DDCalculoImpuesto calculoImpuesto;

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

	public DDUnidadPoblacional getUnidadPoblacional() {
		return unidadPoblacional;
	}

	public void setUnidadPoblacional(DDUnidadPoblacional unidadPoblacional) {
		this.unidadPoblacional = unidadPoblacional;
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

	public DDTipoPeriocidad getTipoPeriocidad() {
		return tipoPeriocidad;
	}

	public void setTipoPeriocidad(DDTipoPeriocidad tipoPeriocidad) {
		this.tipoPeriocidad = tipoPeriocidad;
	}

	public DDCalculoImpuesto getCalculoImpuesto() {
		return calculoImpuesto;
	}

	public void setCalculoImpuesto(DDCalculoImpuesto calculoImpuesto) {
		this.calculoImpuesto = calculoImpuesto;
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
