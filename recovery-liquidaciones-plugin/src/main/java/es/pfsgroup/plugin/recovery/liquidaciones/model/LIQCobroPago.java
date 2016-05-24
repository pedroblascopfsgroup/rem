package es.pfsgroup.plugin.recovery.liquidaciones.model;

import java.io.Serializable;
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
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cobropago.model.CobroPago;
import es.capgemini.pfs.cobropago.model.DDEstadoCobroPago;
import es.capgemini.pfs.cobropago.model.DDSubtipoCobroPago;


import es.capgemini.pfs.cobropago.model.DDTipoCobroPago;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableConceptoEntrega;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableTipoEntrega;

@Entity
@Table(name = "CPA_COBROS_PAGOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class LIQCobroPago implements Auditable, Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4828134585141618353L;

	@Id
    @Column(name = "CPA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CobroPagoGenerator")
    @SequenceGenerator(name = "CobroPagoGenerator", sequenceName = "S_CPA_COBROS_PAGOS")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "PRC_ID")
    private Procedimiento procedimiento;

    @ManyToOne
    @JoinColumn(name = "ASU_ID")
    private Asunto asunto;

    @ManyToOne
    @JoinColumn(name = "DD_ECP_ID")
    @NotNull(message = "plugin.liquidaciones.model.liqcobropago.estado.null")
    private DDEstadoCobroPago estado;

    @ManyToOne
    @JoinColumn(name = "DD_SCP_ID")
    @NotNull(message = "plugin.liquidaciones.model.liqcobropago.subtipo.null")
    private DDSubtipoCobroPago subTipo;

    @Column(name = "CPA_IMPORTE")
    @NotNull(message = "plugin.liquidaciones.model.liqcobropago.importe.null")
    private Float importe;

    @Column(name = "CPA_FECHA")
    @NotNull(message = "plugin.liquidaciones.model.liqcobropago.fecha.null")
    private Date fecha;

    @Column(name = "CPA_OBSERVACIONES")
    private String observaciones;
    
    @ManyToOne
    @JoinColumn(name = "DD_OC_ID")
    private DDOrigenCobro origenCobro;
    
    @ManyToOne
    @JoinColumn(name = "DD_MC_ID")
    private DDModalidadCobro modalidadCobro;
    

    @ManyToOne
    @JoinColumn(name = "DD_TIM_ID")
    private DDTipoImputacion tipoImputacion;
    
    @ManyToOne
    @JoinColumn(name = "DD_ATE_ID")
    private DDAdjContableTipoEntrega tipoEntrega;
    
    @ManyToOne
    @JoinColumn(name = "DD_ACE_ID")
    private DDAdjContableConceptoEntrega conceptoEntrega;
    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;
    
    @ManyToOne
    @JoinColumn(name = "CNT_ID")
    private Contrato contrato;
    
    @Column(name = "CPA_REVISADO")
    private Integer revisado;
    
    @Column(name = "CPA_CAPITAL")
    private Float capital;

    @Column(name = "CPA_CODIGO_COBRO")
	private String codigoCobro;
   
    @Column(name = "CPA_FECHA_VALOR")
	private Date fechaValor;
    
    @Column(name = "CPA_CAPITAL_NO_VENCIDO")
	private Float capitalNoVencido;
    
    @Column(name = "CPA_INTERESES_ORDINAR")
	private Float interesesOrdinarios;
    
    @Column(name = "CPA_INTERESES_MORATOR")
	private Float interesesMoratorios;
    
    @Column(name = "CPA_IMPUESTOS")
	private Float impuestos;
    
    @Column(name = "CPA_GASTOS_PROCU")
	private Float gastosProcurador;
    
    @Column(name = "CPA_GASTOS_ABOGA")
	private Float gastosAbogado;
    
    @Column(name = "CPA_GASTOS_OTROS")
	private Float gastosOtros;
    
    
    @Column(name = "CPA_COBRO_FACTURABLE")
   	private Integer cobroFacturable;
    
    @Column(name = "CPA_COMISIONES")
	private Float comisiones;
    
    @Column(name = "CPA_FECHA_DATO")
    private Date fechaDato;
    
    @Column(name = "CPA_FECHA_EXTRACCION")
    private Date fechaExtraccion;
    
    @Column(name = "CPA_FECHA_MOVIMIENTO")
    private Date fechaMovimiento;
    
    @Column(name = "CPA_GASTOS")
	private Float gastos;
    
    @Column(name = "CPA_NUMERO_RECIBO")
	private Float numeroRecibo;
    
    @ManyToOne
    @JoinColumn(name = "DD_TCP_ID")
    private DDTipoCobroPago tipoCobroPago;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public Asunto getAsunto() {
		return asunto;
	}

	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}

	public DDEstadoCobroPago getEstado() {
		return estado;
	}

	public void setEstado(DDEstadoCobroPago estado) {
		this.estado = estado;
	}

	public DDSubtipoCobroPago getSubTipo() {
		return subTipo;
	}

	public void setSubTipo(DDSubtipoCobroPago subTipo) {
		this.subTipo = subTipo;
	}

	public Float getImporte() {
		return importe;
	}

	public void setImporte(Float importe) {
		this.importe = importe;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

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

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public Integer getRevisado() {
		return revisado;
	}

	public void setRevisado(Integer revisado) {
		this.revisado = revisado;
	}

	public Float getCapital() {
		return capital;
	}

	public void setCapital(Float capital) {
		this.capital = capital;
	}

	public String getCodigoCobro() {
		return codigoCobro;
	}

	public void setCodigoCobro(String codigoCobro) {
		this.codigoCobro = codigoCobro;
	}

	public Date getFechaValor() {
		return fechaValor;
	}

	public void setFechaValor(Date fechaValor) {
		this.fechaValor = fechaValor;
	}

	public Float getCapitalNoVencido() {
		return capitalNoVencido;
	}

	public void setCapitalNoVencido(Float capitalNoVencido) {
		this.capitalNoVencido = capitalNoVencido;
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

	public Float getImpuestos() {
		return impuestos;
	}

	public void setImpuestos(Float impuestos) {
		this.impuestos = impuestos;
	}

	public Float getGastosProcurador() {
		return gastosProcurador;
	}

	public void setGastosProcurador(Float gastosProcurador) {
		this.gastosProcurador = gastosProcurador;
	}

	public Float getGastosAbogado() {
		return gastosAbogado;
	}

	public void setGastosAbogado(Float gastosAbogado) {
		this.gastosAbogado = gastosAbogado;
	}

	public Float getGastosOtros() {
		return gastosOtros;
	}

	public void setGastosOtros(Float gastosOtros) {
		this.gastosOtros = gastosOtros;
	}

	public Integer getCobroFacturable() {
		return cobroFacturable;
	}

	public void setCobroFacturable(Integer cobroFacturable) {
		this.cobroFacturable = cobroFacturable;
	}

	public Float getComisiones() {
		return comisiones;
	}

	public void setComisiones(Float comisiones) {
		this.comisiones = comisiones;
	}

	public Date getFechaDato() {
		return fechaDato;
	}

	public void setFechaDato(Date fechaDato) {
		this.fechaDato = fechaDato;
	}

	public Date getFechaExtraccion() {
		return fechaExtraccion;
	}

	public void setFechaExtraccion(Date fechaExtraccion) {
		this.fechaExtraccion = fechaExtraccion;
	}

	public Date getFechaMovimiento() {
		return fechaMovimiento;
	}

	public void setFechaMovimiento(Date fechaMovimiento) {
		this.fechaMovimiento = fechaMovimiento;
	}

	public Float getGastos() {
		return gastos;
	}

	public void setGastos(Float gastos) {
		this.gastos = gastos;
	}

	public Float getNumeroRecibo() {
		return numeroRecibo;
	}

	public void setNumeroRecibo(Float numeroRecibo) {
		this.numeroRecibo = numeroRecibo;
	}

	public DDTipoCobroPago getTipoCobroPago() {
		return tipoCobroPago;
	}

	public void setTipoCobroPago(DDTipoCobroPago tipoCobroPago) {
		this.tipoCobroPago = tipoCobroPago;
	}
    
	
}
