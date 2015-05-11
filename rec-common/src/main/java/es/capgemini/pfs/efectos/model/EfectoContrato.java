package es.capgemini.pfs.efectos.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

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
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDMoneda;

/**
 * Entidad Efectos del contrato.
 * @author Carlos Pérez
 *
 */

@Entity
@Table(name = "EFC_EFECTOS_CNT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class EfectoContrato implements Auditable, Serializable{

	private static final long serialVersionUID = -2285100277480296882L;

	@Id
	@Column(name = "EFC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EfectosContratoGenerator")
	@SequenceGenerator(name = "EfectosContratoGenerator", sequenceName = "S_EFC_EFECTOS_CNT")
	private Long id;
	
	@Column(name="EFC_CODIGO_ENTIDAD")
	private Integer codigoEntidad;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CNT_ID")
	private Contrato contrato;
	

	@Column(name="EFC_CODIGO_EFECTO")
	private Long codigoEfecto;
	
	@Column(name="EFC_CODIGO_LINEA")
	private Long codigoLinea;
	
	@Column(name="EFC_CODIGO_ACUERDO")
	private Long codigoAcuerdo;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TEF_ID")
	private DDTipoEfecto tipoEfecto;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_SEF_ID")
	private DDSituacionEfecto situacionEfecto;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MON_ID")
	private DDMoneda moneda;
	
	@Column(name = "EFC_IMPORTE_EFECTO")
	private Float importe;
	
	@Column(name = "EFC_CAPITAL")
	private Float capital;
	
	@Column(name = "EFC_INT_ORDIN_DEVEN")
	private Float interesesOrdinarios;
	
	@Column(name = "EFC_INT_ORDIN_MORAT")
	private Float interesesMoratorios;
	
	@Column(name = "EFC_COMISIONES")
	private Float comisiones;
	
	@Column(name = "EFC_GASTOS_NO_COBRADOS")
	private Float gastos;
	
	@Column(name = "EFC_IMPUESTOS")
	private Float impuestos;
	
	@Column(name = "EFC_FECHA_DESCUENTO")
	private Date fechaDescuento;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TFV_ID")
	private DDTipoFechaVenciento tipoFechaVencimiento;
	
	@Column(name = "EFC_FECHA_VENCIMIENTO")
	private Date fechaVencimiento;
	
	@Column(name = "EFC_FECHA_EXTRACCION")
	private Date fechaExtraccion;
	
	@Column(name = "EFC_FECHA_DATO")
	private Date fechaDato;
	
	@Column(name = "EFC_CHAR_EXTRA1")
	private String charExtra1;
	@Column(name = "EFC_CHAR_EXTRA2")
	private String charExtra2;
	
	@Column(name = "EFC_FLAG_EXTRA1")
	private Boolean flagExtra1;
	@Column(name = "EFC_FLAG_EXTRA2")
	private Boolean flagExtra2;

	@Column(name = "EFC_DATE_EXTRA1")
	private Date dateExtra1;
	@Column(name = "EFC_DATE_EXTRA2")
	private Date dateExtra2;
	
	@Column(name = "EFC_NUM_EXTRA1")
	private Float numExtra1;
	@Column(name = "EFC_NUM_EXTRA2")
	private Float numExtra2;
	
	@OneToMany(mappedBy = "efectoContrato", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "efc_id")
	@OrderBy("orden ASC")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<EfectoPersona> efectosPersona;
 
	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getCodigoEntidad() {
		return codigoEntidad;
	}

	public void setCodigoEntidad(Integer codigoEntidad) {
		this.codigoEntidad = codigoEntidad;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public Long getCodigoEfecto() {
		return codigoEfecto;
	}

	public void setCodigoEfecto(Long codigoEfecto) {
		this.codigoEfecto = codigoEfecto;
	}

	public Long getCodigoLinea() {
		return codigoLinea;
	}

	public void setCodigoLinea(Long codigoLinea) {
		this.codigoLinea = codigoLinea;
	}

	public Long getCodigoAcuerdo() {
		return codigoAcuerdo;
	}

	public void setCodigoAcuerdo(Long codigoAcuerdo) {
		this.codigoAcuerdo = codigoAcuerdo;
	}

	public DDTipoEfecto getTipoEfecto() {
		return tipoEfecto;
	}

	public void setTipoEfecto(DDTipoEfecto tipoEfecto) {
		this.tipoEfecto = tipoEfecto;
	}

	public DDSituacionEfecto getSituacionEfecto() {
		return situacionEfecto;
	}

	public void setSituacionEfecto(DDSituacionEfecto situacionEfecto) {
		this.situacionEfecto = situacionEfecto;
	}

	public DDMoneda getMoneda() {
		return moneda;
	}

	public void setMoneda(DDMoneda moneda) {
		this.moneda = moneda;
	}

	public Float getImporte() {
		return importe;
	}

	public void setImporte(Float importe) {
		this.importe = importe;
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

	public Date getFechaDescuento() {
		return fechaDescuento;
	}

	public void setFechaDescuento(Date fechaDescuento) {
		this.fechaDescuento = fechaDescuento;
	}

	public DDTipoFechaVenciento getTipoFechaVencimiento() {
		return tipoFechaVencimiento;
	}

	public void setTipoFechaVencimiento(DDTipoFechaVenciento tipoFechaVencimiento) {
		this.tipoFechaVencimiento = tipoFechaVencimiento;
	}

	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
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

	public Float getNumExtra1() {
		return numExtra1;
	}

	public void setNumExtra1(Float numExtra1) {
		this.numExtra1 = numExtra1;
	}

	public Float getNumExtra2() {
		return numExtra2;
	}

	public void setNumExtra2(Float numExtra2) {
		this.numExtra2 = numExtra2;
	}

	public List<EfectoPersona> getEfectosPersona() {
		return efectosPersona;
	}

	public void setEfectosPersona(List<EfectoPersona> efectosPersona) {
		this.efectosPersona = efectosPersona;
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

}

