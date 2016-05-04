package es.pfsgroup.plugin.liquidaciones.avanzado.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;

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
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableConceptoEntrega;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableTipoEntrega;

@Entity
@Table(name = "ENT_CAL_LIQUIDACION", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class EntregasCalculoLiq implements Auditable, Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4502479621786306745L;
	
	@Id
    @Column(name = "ENT_CAL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EntregasCalculoLiqGenerator")
    @SequenceGenerator(name = "EntregasCalculoLiqGenerator", sequenceName = "S_ENT_CAL_LIQUIDACION")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "CAL_ID")
	private CalculoLiquidacion calculoLiquidacion;
	
	@Column(name = "ENT_FECHA")
	private Date fechaEntrega;
	
	@Column(name = "ENT_FECHA_VALOR")
	private Date fechaValor;
	
	@ManyToOne
	@JoinColumn(name = "DD_ATE_ID")
	private DDAdjContableTipoEntrega tipoEntrega;
	
	@ManyToOne
	@JoinColumn(name = "DD_ACE_ID")
	private DDAdjContableConceptoEntrega conceptoEntrega;
	
	@Column(name = "ENT_TOTAL")
	private BigDecimal totalEntrega;
	
	@Column(name = "ENT_GASTOS_PROCURADOR")
	private BigDecimal gastosProcurador;
	
	@Column(name = "ENT_GASTOS_LETRADO")
	private BigDecimal gastosLetrado;
	
	@Column(name = "ENT_OTROS_GASTOS")
	private BigDecimal otrosGastos;
	
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

	public CalculoLiquidacion getCalculoLiquidacion() {
		return calculoLiquidacion;
	}

	public void setCalculoLiquidacion(CalculoLiquidacion calculoLiquidacion) {
		this.calculoLiquidacion = calculoLiquidacion;
	}

	public Date getFechaEntrega() {
		return fechaEntrega;
	}

	public void setFechaEntrega(Date fechaEntrega) {
		this.fechaEntrega = fechaEntrega;
	}

	public Date getFechaValor() {
		return fechaValor;
	}

	public void setFechaValor(Date fechaValor) {
		this.fechaValor = fechaValor;
	}

	public DDAdjContableTipoEntrega getTipoEntrega() {
		return tipoEntrega;
	}

	public void setTipoEntrega(DDAdjContableTipoEntrega tipoEntrega) {
		this.tipoEntrega = tipoEntrega;
	}

	public DDAdjContableConceptoEntrega getConceptoEntrega() {
		return conceptoEntrega;
	}

	public void setConceptoEntrega(DDAdjContableConceptoEntrega conceptoEntrega) {
		this.conceptoEntrega = conceptoEntrega;
	}

	public BigDecimal getTotalEntrega() {
		return totalEntrega;
	}

	public void setTotalEntrega(BigDecimal totalEntrega) {
		this.totalEntrega = totalEntrega;
	}

	public BigDecimal getGastosProcurador() {
		return gastosProcurador;
	}

	public void setGastosProcurador(BigDecimal gastosProcurador) {
		this.gastosProcurador = gastosProcurador;
	}

	public BigDecimal getGastosLetrado() {
		return gastosLetrado;
	}

	public void setGastosLetrado(BigDecimal gastosLetrado) {
		this.gastosLetrado = gastosLetrado;
	}

	public BigDecimal getOtrosGastos() {
		return otrosGastos;
	}

	public void setOtrosGastos(BigDecimal otrosGastos) {
		this.otrosGastos = otrosGastos;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
	
}
