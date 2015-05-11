package es.pfsgroup.plugin.recovery.expediente.cobrosPagos.model;

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
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cobropago.model.DDEstadoCobroPago;
import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;
import es.capgemini.pfs.cobropago.model.DDTipoCobroPago;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.plugin.recovery.liquidaciones.model.DDModalidadCobro;
import es.pfsgroup.plugin.recovery.liquidaciones.model.DDOrigenCobro;
import es.pfsgroup.plugin.recovery.liquidaciones.model.DDTipoImputacion;

/**
 * Clase que representa los Cobros / Pagos
 * 
 * @author
 * 
 */
@Entity
@Where(clause = "CNT_ID is not null")
@Table(name = "CPA_COBROS_PAGOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class RecobroPagoContrato implements Auditable, Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "CPA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CobroPagoGenerator")
	@SequenceGenerator(name = "CobroPagoGenerator", sequenceName = "S_CPA_COBROS_PAGOS")
	private Long id;

	@Column(name = "CPA_FECHA")
	private Date fecha;

	@Column(name = "CPA_IMPORTE")
	private Float importe;

	@ManyToOne
	@JoinColumn(name = "DD_TCP_ID")
	private DDTipoCobroPago tipoCobroPago;

	@ManyToOne
	@JoinColumn(name = "CNT_ID")
	private Contrato contrato;

	// @Column(name = "CPA_PERIOD_CARGA")
	// private Integer periodoCarga;

	@Column(name = "CPA_OBSERVACIONES")
	private String observaciones;

	@ManyToOne
	@JoinColumn(name = "DD_OC_ID")
	private DDOrigenCobro origenCobro;

	@Column(name = "CPA_REVISADO")
	private Boolean revisado;

	@Column(name = "CPA_FECHA_EXTRACCION")
	private Date fechaExtraccion;

	@Column(name = "CPA_CODIGO_COBRO")
	private String codigoCobro;

	@Formula("(select to_number(substr(cnt.cnt_contrato,0,5)) from CNT_CONTRATOS cnt where cnt.cnt_id = cnt_id)")
	private Integer codigoPropietario;

	@Formula("(select to_number(substr(cnt.cnt_contrato,-15)) from CNT_CONTRATOS cnt where cnt.cnt_id = cnt_id)")
	private Long numeroEspec;

	@Column(name = "CPA_FECHA_VALOR")
	private Date fechaValor;

	@Column(name = "CPA_FECHA_MOVIMIENTO")
	private Date fechaMovimiento;

	@Column(name = "CPA_COBRO_FACTURABLE")
	private Boolean cobroFacturable;

	@Column(name = "CPA_CAPITAL")
	private Float capital;

	@Column(name = "CPA_INTERESES_ORDINAR")
	private Float interesesOrdinarios;

	@Column(name = "CPA_INTERESES_MORATOR")
	private Float interesesMoratorios;

	@Column(name = "CPA_COMISIONES")
	private Float comisiones;

	@Column(name = "CPA_GASTOS")
	private Float gastos;

	@Column(name = "CPA_IMPUESTOS")
	private Float impuestos;

	@ManyToOne
	@JoinColumn(name = "DD_SCP_ID")
	private DDSubtipoCobroPago subTipo;

	@ManyToOne
	@JoinColumn(name = "DD_ECP_ID")
	private DDEstadoCobroPago estado;

	@ManyToOne
	@JoinColumn(name = "ASU_ID")
	private Asunto asunto;

	@ManyToOne
	@JoinColumn(name = "PRC_ID")
	private Procedimiento procedimiento;

	@ManyToOne
	@JoinColumn(name = "DD_MC_ID")
	private DDModalidadCobro modalidadCobro;

	@ManyToOne
	@JoinColumn(name = "DD_TIM_ID")
	private DDTipoImputacion tipoImputacion;

	@Column(name = "CPA_FECHA_DATO")
	private Date fechaDato;
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the procedimiento
	 */
	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	/**
	 * @param procedimiento
	 *            the procedimiento to set
	 */
	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	/**
	 * @return the asunto
	 */
	public Asunto getAsunto() {
		return asunto;
	}

	/**
	 * @param asunto
	 *            the asunto to set
	 */
	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}

	/**
	 * @return the estado
	 */
	public DDEstadoCobroPago getEstado() {
		return estado;
	}

	/**
	 * @param estado
	 *            the estado to set
	 */
	public void setEstado(DDEstadoCobroPago estado) {
		this.estado = estado;
	}

	/**
	 * @return the subTipo
	 */
	public DDSubtipoCobroPago getSubTipo() {
		return subTipo;
	}

	/**
	 * @param subTipo
	 *            the subTipo to set
	 */
	public void setSubTipo(DDSubtipoCobroPago subTipo) {
		this.subTipo = subTipo;
	}

	/**
	 * @return the importe
	 */
	public Float getImporte() {
		return importe;
	}

	/**
	 * @param importe
	 *            the importe to set
	 */
	public void setImporte(Float importe) {
		this.importe = importe;
	}

	/**
	 * @return the fecha
	 */
	public Date getFecha() {
		return fecha;
	}

	/**
	 * @param fecha
	 *            the fecha to set
	 */
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	/**
	 * @return the auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * @param auditoria
	 *            the auditoria to set
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * @return the version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * @param version
	 *            the version to set
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}

	public DDTipoCobroPago getTipoCobroPago() {
		return tipoCobroPago;
	}

	public void setTipoCobroPago(DDTipoCobroPago tipoCobroPago) {
		this.tipoCobroPago = tipoCobroPago;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	// public Integer getPeriodoCarga() {
	// return periodoCarga;
	// }
	//
	// public void setPeriodoCarga(Integer periodoCarga) {
	// this.periodoCarga = periodoCarga;
	// }

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public DDOrigenCobro getOrigenCobro() {
		return origenCobro;
	}

	public void setOrigenCobro(DDOrigenCobro origenCobro) {
		this.origenCobro = origenCobro;
	}

	public Boolean getRevisado() {
		return revisado;
	}

	public void setRevisado(Boolean revisado) {
		this.revisado = revisado;
	}

	public Date getFechaExtraccion() {
		return fechaExtraccion;
	}

	public void setFechaExtraccion(Date fechaExtraccion) {
		this.fechaExtraccion = fechaExtraccion;
	}

	public String getCodigoCobro() {
		return codigoCobro;
	}

	public void setCodigoCobro(String codigoCobro) {
		this.codigoCobro = codigoCobro;
	}

	public Integer getCodigoPropietario() {
		return codigoPropietario;
	}

	public void setCodigoPropietario(Integer codigoPropietario) {
		this.codigoPropietario = codigoPropietario;
	}

	public Long getNumeroEspec() {
		return numeroEspec;
	}

	public void setNumeroEspec(Long numeroEspec) {
		this.numeroEspec = numeroEspec;
	}

	public Date getFechaValor() {
		return fechaValor;
	}

	public void setFechaValor(Date fechaValor) {
		this.fechaValor = fechaValor;
	}

	public Date getFechaMovimiento() {
		return fechaMovimiento;
	}

	public void setFechaMovimiento(Date fechaMovimiento) {
		this.fechaMovimiento = fechaMovimiento;
	}

	public Boolean getCobroFacturable() {
		return cobroFacturable;
	}

	public void setCobroFacturable(Boolean cobroFacturable) {
		this.cobroFacturable = cobroFacturable;
	}

	public Float getCapital() {
		return capital;
	}

	public void setCapital(Float capital) {
		this.capital = capital;
	}

	public Float getInteresesOrdinarios() {
		return interesesOrdinarios;
	}

	public void setInteresesOrdinarios(Float interesesOrdinarios) {
		this.interesesOrdinarios = interesesOrdinarios;
	}

	public Float getInteresesMoratorios() {
		return interesesMoratorios;
	}

	public void setInteresesMoratorios(Float interesesMoratorios) {
		this.interesesMoratorios = interesesMoratorios;
	}

	public Float getComisiones() {
		return comisiones;
	}

	public void setComisiones(Float comisiones) {
		this.comisiones = comisiones;
	}

	public Float getGastos() {
		return gastos;
	}

	public void setGastos(Float gastos) {
		this.gastos = gastos;
	}

	public Float getImpuestos() {
		return impuestos;
	}

	public void setImpuestos(Float impuestos) {
		this.impuestos = impuestos;
	}

	public DDModalidadCobro getModalidadCobro() {
		return modalidadCobro;
	}

	public void setModalidadCobro(DDModalidadCobro modalidadCobro) {
		this.modalidadCobro = modalidadCobro;
	}

	public DDTipoImputacion getTipoImputacion() {
		return tipoImputacion;
	}

	public void setTipoImputacion(DDTipoImputacion tipoImputacion) {
		this.tipoImputacion = tipoImputacion;
	}

	public Date getFechaDato() {
		return fechaDato;
	}

	public void setFechaDato(Date fechaDato) {
		this.fechaDato = fechaDato;
	}

}
