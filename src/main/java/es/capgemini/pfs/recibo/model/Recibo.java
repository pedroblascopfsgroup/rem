package es.capgemini.pfs.recibo.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import javax.annotation.Resource;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.antecedenteinterno.model.AntecedenteInterno;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.multigestor.model.EXTGestorEntidad;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.titulo.model.Titulo;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.Describible;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * Entidad Recibos.
 * @author Carlos Pérez
 *
 */

@Entity
@Table(name = "REC_RECIBOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class Recibo implements Auditable, Serializable{

	private static final long serialVersionUID = -4439212840396671891L;

	@Id
	@Column(name = "REC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "RecibosGenerator")
	@SequenceGenerator(name = "RecibosGenerator", sequenceName = "S_REC_RECIBOS")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CNT_ID")
	private Contrato contrato;
	
	@Column(name="REC_CODIGO_ENTIDAD")
	private Integer codigoEntidad;
	
	@Column(name="REC_CODIGO_RECIBO")
	private Long codigoRecibo;
	
	@Column(name = "REC_FECHA_VENCIMIENTO")
	private Date fechaVencimiento;
	
	@Column(name = "REC_FECHA_FACTURACION")
	private Date fechaFacturacion;
	
	@Column(name = "REC_CC_DOMICILIACION")
	private String ccDomiciliacion;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TRE_ID")
    private DDTipoRecibo tipoRecibo;

    @Column(name="REC_TIPO_INTERES")
    private Float tipoInteres;
    
    @Column(name="REC_IMPORTE_RECIBO")
    private Float importeRecibo;
    
    @Column(name="REC_IMPORTE_IMPAGADO")
    private Float importeImpagado;
    
    @Column(name="REC_CAPITAL")
    private Float capital;
    
    @Column(name="REC_INTERESES_ORDINAR")
    private Float interesesOrdinarios;
    
    @Column(name="REC_INTERESES_MORATOR")
    private Float interesesMoratorios;
    
    @Column(name="REC_COMISIONES")
    private Float comisiones;
    
    @Column(name="REC_GASTOS_NO_COBRADOS")
    private Float gastosNoCobrados;
    
    @Column(name="REC_IMPUESTOS")
    private Float impuestos;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SIR_ID")
    private DDSituacionRecibo situacionRecibo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MID_ID")
    private DDMotivoDevolucion motivoDevolucion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MIR_ID")
    private DDMotivoRechazo motivoRechazo;
    
    @Column(name="REC_FECHA_EXTRACCION")
    private Date fechaExtraccion;
    
    @Column(name="REC_FECHA_DATO")
    private Date fechaDato;

    @Column(name="REC_CHAR_EXTRA1")
    private String charExtra1;
    
    @Column(name="REC_CHAR_EXTRA2")
    private String charExtra2;

    @Column(name="REC_FLAG_EXTRA1")
    private Boolean flagExtra1;
    
    @Column(name="REC_FLAG_EXTRA2")
    private Boolean flagExtra2;

    @Column(name="REC_DATE_EXTRA1")
    private Date dateExtra1;
    
    @Column(name="REC_DATE_EXTRA2")
    private Date dateExtra2;

    @Column(name="REC_NUM_EXTRA1")
    private Float floatExtra1;
    
    @Column(name="REC_NUM_EXTRA2")
    private Float floatExtra2;
    
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

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public Integer getCodigoEntidad() {
		return codigoEntidad;
	}

	public void setCodigoEntidad(Integer codigoEntidad) {
		this.codigoEntidad = codigoEntidad;
	}

	public Long getCodigoRecibo() {
		return codigoRecibo;
	}

	public void setCodigoRecibo(Long codigoRecibo) {
		this.codigoRecibo = codigoRecibo;
	}

	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}

	public Date getFechaFacturacion() {
		return fechaFacturacion;
	}

	public void setFechaFacturacion(Date fechaFacturacion) {
		this.fechaFacturacion = fechaFacturacion;
	}

	public String getCcDomiciliacion() {
		return ccDomiciliacion;
	}

	public void setCcDomiciliacion(String ccDomiciliacion) {
		this.ccDomiciliacion = ccDomiciliacion;
	}

	public DDTipoRecibo getTipoRecibo() {
		return tipoRecibo;
	}

	public void setTipoRecibo(DDTipoRecibo tipoRecibo) {
		this.tipoRecibo = tipoRecibo;
	}

	public Float getTipoInteres() {
		return tipoInteres;
	}

	public void setTipoInteres(Float tipoInteres) {
		this.tipoInteres = tipoInteres;
	}

	public Float getImporteRecibo() {
		return importeRecibo;
	}

	public void setImporteRecibo(Float importeRecibo) {
		this.importeRecibo = importeRecibo;
	}

	public Float getImporteImpagado() {
		return importeImpagado;
	}

	public void setImporteImpagado(Float importeImpagado) {
		this.importeImpagado = importeImpagado;
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

	public Float getGastosNoCobrados() {
		return gastosNoCobrados;
	}

	public void setGastosNoCobrados(Float gastosNoCobrados) {
		this.gastosNoCobrados = gastosNoCobrados;
	}

	public Float getImpuestos() {
		return impuestos;
	}

	public void setImpuestos(Float impuestos) {
		this.impuestos = impuestos;
	}

	public DDSituacionRecibo getSituacionRecibo() {
		return situacionRecibo;
	}

	public void setSituacionRecibo(DDSituacionRecibo situacionRecibo) {
		this.situacionRecibo = situacionRecibo;
	}

	public DDMotivoDevolucion getMotivoDevolucion() {
		return motivoDevolucion;
	}

	public void setMotivoDevolucion(DDMotivoDevolucion motivoDevolucion) {
		this.motivoDevolucion = motivoDevolucion;
	}

	public DDMotivoRechazo getMotivoRechazo() {
		return motivoRechazo;
	}

	public void setMotivoRechazo(DDMotivoRechazo motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}

	public Date getFechaExtraccion() {
		return fechaExtraccion;
	}

	public void setFechaExtraccion(Date fechaExtraccion) {
		this.fechaExtraccion = fechaExtraccion;
	}

	public Date getFechaDato() {
		return fechaDato;
	}

	public void setFechaDato(Date fechaDato) {
		this.fechaDato = fechaDato;
	}

	public String getCharExtra1() {
		return charExtra1;
	}

	public void setCharExtra1(String charExtra1) {
		this.charExtra1 = charExtra1;
	}

	public String getCharExtra2() {
		return charExtra2;
	}

	public void setCharExtra2(String charExtra2) {
		this.charExtra2 = charExtra2;
	}

	public Boolean getFlagExtra1() {
		return flagExtra1;
	}

	public void setFlagExtra1(Boolean flagExtra1) {
		this.flagExtra1 = flagExtra1;
	}

	public Boolean getFlagExtra2() {
		return flagExtra2;
	}

	public void setFlagExtra2(Boolean flagExtra2) {
		this.flagExtra2 = flagExtra2;
	}

	public Date getDateExtra1() {
		return dateExtra1;
	}

	public void setDateExtra1(Date dateExtra1) {
		this.dateExtra1 = dateExtra1;
	}

	public Date getDateExtra2() {
		return dateExtra2;
	}

	public void setDateExtra2(Date dateExtra2) {
		this.dateExtra2 = dateExtra2;
	}

	public Float getFloatExtra1() {
		return floatExtra1;
	}

	public void setFloatExtra1(Float floatExtra1) {
		this.floatExtra1 = floatExtra1;
	}

	public Float getFloatExtra2() {
		return floatExtra2;
	}

	public void setFloatExtra2(Float floatExtra2) {
		this.floatExtra2 = floatExtra2;
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
