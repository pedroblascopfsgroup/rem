package es.pfsgroup.plugin.precontencioso.liquidacion.model;

import java.io.Serializable;
import java.math.BigDecimal;
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
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;

@Entity
@Table(name = "PCO_LIQ_LIQUIDACIONES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class LiquidacionPCO implements Serializable, Auditable {

	private static final long serialVersionUID = -9076449499543642580L;

	@Id
	@Column(name = "PCO_LIQ_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "LiquidacionPCOGenerator")
	@SequenceGenerator(name = "LiquidacionPCOGenerator", sequenceName = "S_PCO_LIQ_LIQUIDACIONES")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "PCO_PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private ProcedimientoPCO procedimientoPCO;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_LIQ_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDEstadoLiquidacionPCO estadoLiquidacion;

	@ManyToOne
	@JoinColumn(name = "CNT_ID")
	private Contrato contrato;

	@Column(name = "PCO_LIQ_FECHA_SOLICITUD")
	private Date fechaSolicitud;

	@Column(name = "PCO_LIQ_FECHA_RECEPCION")
	private Date fechaRecepcion;

	@Column(name = "PCO_LIQ_FECHA_CONFIRMACION")
	private Date fechaConfirmacion;

	@Column(name = "PCO_LIQ_FECHA_VISADO")
	private Date fechaVisado;

	@Column(name = "PCO_LIQ_FECHA_CIERRE")
	private Date fechaCierre;

	@Column(name = "PCO_LIQ_CAPITAL_VENCIDO")
	private BigDecimal capitalVencido;

	@Column(name = "PCO_LIQ_CAPITAL_NO_VENCIDO")
	private BigDecimal capitalNoVencido;

	@Column(name = "PCO_LIQ_INTERESES_DEMORA")
	private BigDecimal interesesDemora;

	@Column(name = "PCO_LIQ_INTERESES_ORDINARIOS")
	private BigDecimal interesesOrdinarios;

	@Column(name = "PCO_LIQ_TOTAL")
	private BigDecimal total;

	@Column(name = "PCO_LIQ_ORI_CAPITAL_VENCIDO")
	private BigDecimal capitalVencidoOriginal;

	@Column(name = "PCO_LIQ_ORI_CAPITAL_NO_VENCIDO")
	private BigDecimal capitalNoVencidoOriginal;

	@Column(name = "PCO_LIQ_ORI_INTE_DEMORA")
	private BigDecimal interesesDemoraOriginal;

	@Column(name = "PCO_LIQ_ORI_INTE_ORDINARIOS")
	private BigDecimal interesesOrdinariosOriginal;

	@Column(name = "PCO_LIQ_ORI_TOTAL")
	private BigDecimal totalOriginal;

	@ManyToOne
	@JoinColumn(name = "USD_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private GestorDespacho apoderado;
	
	@ManyToOne
	@JoinColumn(name = "PCO_LIQ_SOLICITANTE")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private GestorDespacho solicitante;
	
	@Column(name = "PCO_LIQ_COMISIONES")
	private BigDecimal comisiones;
	
	@Column(name = "PCO_LIQ_GASTOS")
	private BigDecimal gastos;
	
	@Column(name = "PCO_LIQ_IMPUESTOS")
	private BigDecimal impuestos;
	
	@Column(name = "PCO_LIQ_ORI_COMISIONES")
	private BigDecimal comisionesOriginal;
	
	@Column(name = "PCO_LIQ_ORI_GASTOS")
	private BigDecimal gastosOriginal;
	
	@Column(name = "PCO_LIQ_ORI_IMPUESTOS")
	private BigDecimal impuestosOriginal;

	@Column(name = "SYS_GUID")
	private String sysGuid;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/*
	 * Formulas para el buscador de precontencioso
	 */

	@Formula(value = 
		" (SELECT TRUNC(SYSDATE) - TRUNC(pco_liq_liquidaciones.FECHACREAR) " +
		" FROM   pco_liq_liquidaciones " +
		"        INNER JOIN dd_pco_liq_estado " +
		"                ON dd_pco_liq_estado.dd_pco_liq_id = pco_liq_liquidaciones.dd_pco_liq_id " +
		" WHERE  pco_liq_liquidaciones.pco_liq_id = PCO_LIQ_ID " +
		"        AND pco_liq_liquidaciones.pco_liq_fecha_solicitud IS NOT NULL " +
		"        AND dd_pco_liq_estado.dd_pco_liq_codigo != '" + DDEstadoLiquidacionPCO.DESCARTADA + "' " +
		"        AND dd_pco_liq_estado.dd_pco_liq_codigo != '" + DDEstadoLiquidacionPCO.CONFIRMADA + "' ) ")
	private Integer diasEnGestion;

	/*
	 * GETTERS & SETTERS
	 */

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ProcedimientoPCO getProcedimientoPCO() {
		return procedimientoPCO;
	}

	public void setProcedimientoPCO(ProcedimientoPCO procedimientoPCO) {
		this.procedimientoPCO = procedimientoPCO;
	}

	public DDEstadoLiquidacionPCO getEstadoLiquidacion() {
		return estadoLiquidacion;
	}

	public void setEstadoLiquidacion(DDEstadoLiquidacionPCO estadoLiquidacion) {
		this.estadoLiquidacion = estadoLiquidacion;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}

	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}

	public Date getFechaConfirmacion() {
		return fechaConfirmacion;
	}

	public void setFechaConfirmacion(Date fechaConfirmacion) {
		this.fechaConfirmacion = fechaConfirmacion;
	}

	/**
	 * @return the fechaVisado
	 */
	public Date getFechaVisado() {
		return fechaVisado;
	}

	/**
	 * @param fechaVisado the fechaVisado to set
	 */
	public void setFechaVisado(Date fechaVisado) {
		this.fechaVisado = fechaVisado;
	}

	public Date getFechaCierre() {
		return fechaCierre;
	}

	public void setFechaCierre(Date fechaCierre) {
		this.fechaCierre = fechaCierre;
	}

	public BigDecimal getCapitalVencido() {
		return capitalVencido;
	}

	public void setCapitalVencido(BigDecimal capitalVencido) {
		this.capitalVencido = capitalVencido;
	}

	public BigDecimal getCapitalNoVencido() {
		return capitalNoVencido;
	}

	public void setCapitalNoVencido(BigDecimal capitalNoVencido) {
		this.capitalNoVencido = capitalNoVencido;
	}

	public BigDecimal getInteresesDemora() {
		return interesesDemora;
	}

	public void setInteresesDemora(BigDecimal interesesDemora) {
		this.interesesDemora = interesesDemora;
	}

	public BigDecimal getInteresesOrdinarios() {
		return interesesOrdinarios;
	}

	public void setInteresesOrdinarios(BigDecimal interesesOrdinarios) {
		this.interesesOrdinarios = interesesOrdinarios;
	}

	public BigDecimal getTotal() {
		return total;
	}

	public void setTotal(BigDecimal total) {
		this.total = total;
	}

	public BigDecimal getCapitalVencidoOriginal() {
		return capitalVencidoOriginal;
	}

	public void setCapitalVencidoOriginal(BigDecimal capitalVencidoOriginal) {
		this.capitalVencidoOriginal = capitalVencidoOriginal;
	}

	public BigDecimal getCapitalNoVencidoOriginal() {
		return capitalNoVencidoOriginal;
	}

	public void setCapitalNoVencidoOriginal(BigDecimal capitalNoVencidoOriginal) {
		this.capitalNoVencidoOriginal = capitalNoVencidoOriginal;
	}

	public BigDecimal getInteresesDemoraOriginal() {
		return interesesDemoraOriginal;
	}

	public void setInteresesDemoraOriginal(BigDecimal interesesDemoraOriginal) {
		this.interesesDemoraOriginal = interesesDemoraOriginal;
	}

	public BigDecimal getInteresesOrdinariosOriginal() {
		return interesesOrdinariosOriginal;
	}

	public void setInteresesOrdinariosOriginal(BigDecimal interesesOrdinariosOriginal) {
		this.interesesOrdinariosOriginal = interesesOrdinariosOriginal;
	}

	public BigDecimal getTotalOriginal() {
		return totalOriginal;
	}

	public void setTotalOriginal(BigDecimal totalOriginal) {
		this.totalOriginal = totalOriginal;
	}

	public GestorDespacho getApoderado() {
		return apoderado;
	}

	public void setApoderado(GestorDespacho apoderado) {
		this.apoderado = apoderado;
	}

	public String getSysGuid() {
		return sysGuid;
	}

	public void setSysGuid(String sysGuid) {
		this.sysGuid = sysGuid;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public BigDecimal getComisiones() {
		return comisiones;
	}

	public void setComisiones(BigDecimal comisiones) {
		this.comisiones = comisiones;
	}

	public BigDecimal getGastos() {
		return gastos;
	}

	public void setGastos(BigDecimal gastos) {
		this.gastos = gastos;
	}

	public BigDecimal getImpuestos() {
		return impuestos;
	}

	public void setImpuestos(BigDecimal impuestos) {
		this.impuestos = impuestos;
	}

	public BigDecimal getComisionesOriginal() {
		return comisionesOriginal;
	}

	public void setComisionesOriginal(BigDecimal comisionesOriginal) {
		this.comisionesOriginal = comisionesOriginal;
	}

	public BigDecimal getGastosOriginal() {
		return gastosOriginal;
	}

	public void setGastosOriginal(BigDecimal gastosOriginal) {
		this.gastosOriginal = gastosOriginal;
	}

	public BigDecimal getImpuestosOriginal() {
		return impuestosOriginal;
	}

	public void setImpuestosOriginal(BigDecimal impuestosOriginal) {
		this.impuestosOriginal = impuestosOriginal;
	}

	public GestorDespacho getSolicitante() {
		return solicitante;
	}

	public void setSolicitante(GestorDespacho solicitante) {
		this.solicitante = solicitante;
	}
}
