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
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAltaSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoBajaSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDPeriodicidad;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoSuministro;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSuministro;


/**
 * Modelo que gestiona la información comercial específica de los activos de tipo vivienda.
 *  
 * @author Ivan Rubio
 *
 */
@Entity
@Table(name = "ACT_SUM_SUMINISTROS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoSuministros implements Serializable, Auditable {
				
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "SUM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoSuministrosGenerator")
    @SequenceGenerator(name = "ActivoSuministrosGenerator", sequenceName = "S_ACT_SUM_SUMINISTROS")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
	private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TSU_ID")
    private DDTipoSuministro tipoSuministro; 
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SSU_ID")
    private DDSubtipoSuministro subtipoSuministro; 
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SUM_COMPANIA_SUMINISTRO")
    private ActivoProveedor companiaSuministro; 
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SUM_DOMICILIADO")
	private DDSinSiNo domiciliado;
	
	@Column(name = "SUM_NUMERO_CONTRATO")
	private String numContrato;
	
	@Column(name = "SUM_NUMERO_CUPS")
	private String numCups;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SUM_PERIODICIDAD")
	private DDPeriodicidad periodicidad;
	
	@Column(name = "SUM_FECHA_ALTA")
	private Date fechaAlta;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SUM_MOTIVO_ALTA")
	private DDMotivoAltaSuministro motivoAlta;
	
	@Column(name = "SUM_FECHA_BAJA")
	private Date fechaBaja;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SUM_MOTIVO_BAJA")
	private DDMotivoBajaSuministro motivoBaja;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SUM_VALIDADO")
	private DDSinSiNo validado;
	
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

	public DDTipoSuministro getTipoSuministro() {
		return tipoSuministro;
	}

	public void setTipoSuministro(DDTipoSuministro tipoSuministro) {
		this.tipoSuministro = tipoSuministro;
	}

	public DDSubtipoSuministro getSubtipoSuministro() {
		return subtipoSuministro;
	}

	public void setSubtipoSuministro(DDSubtipoSuministro subtipoSuministro) {
		this.subtipoSuministro = subtipoSuministro;
	}

	public ActivoProveedor getCompaniaSuministro() {
		return companiaSuministro;
	}

	public void setCompaniaSuministro(ActivoProveedor companiaSuministro) {
		this.companiaSuministro = companiaSuministro;
	}

	public DDSinSiNo getDomiciliado() {
		return domiciliado;
	}

	public void setDomiciliado(DDSinSiNo domiciliado) {
		this.domiciliado = domiciliado;
	}

	public String getNumContrato() {
		return numContrato;
	}

	public void setNumContrato(String numContrato) {
		this.numContrato = numContrato;
	}

	public String getNumCups() {
		return numCups;
	}

	public void setNumCups(String numCups) {
		this.numCups = numCups;
	}

	public DDPeriodicidad getPeriodicidad() {
		return periodicidad;
	}

	public void setPeriodicidad(DDPeriodicidad periodicidad) {
		this.periodicidad = periodicidad;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public DDMotivoAltaSuministro getMotivoAlta() {
		return motivoAlta;
	}

	public void setMotivoAlta(DDMotivoAltaSuministro motivoAlta) {
		this.motivoAlta = motivoAlta;
	}

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public DDMotivoBajaSuministro getMotivoBaja() {
		return motivoBaja;
	}

	public void setMotivoBaja(DDMotivoBajaSuministro motivoBaja) {
		this.motivoBaja = motivoBaja;
	}

	public DDSinSiNo getValidado() {
		return validado;
	}

	public void setValidado(DDSinSiNo validado) {
		this.validado = validado;
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