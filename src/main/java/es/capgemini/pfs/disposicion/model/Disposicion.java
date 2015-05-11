package es.capgemini.pfs.disposicion.model;

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
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDMoneda;

/**
 * Entidad Disposiciones.
 * @author Carlos Pérez
 *
 */

@Entity
@Table(name = "DSP_DISPOSICIONES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class Disposicion implements Auditable, Serializable{

	private static final long serialVersionUID = 7650617106086355922L;

	@Id
	@Column(name = "DSP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DisposicionesGenerator")
	@SequenceGenerator(name = "DisposicionesGenerator", sequenceName = "S_DSP_DISPOSICIONES")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CNT_ID")
	private Contrato contrato;
	
	@Column(name="DSP_CODIGO_ENTIDAD")
	private Integer codigoEntidad;
	
	@Column(name="DSP_CODIGO_DISPOSICION")
	private Long codigoDisposicion;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DTI_ID")
    private DDTipoDisposicion tipoDisposicion;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DST_ID")
    private DDSubTipoDisposicion subTipoDisposicion;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DSI_ID")
    private DDSituacionDisposicion situacionDisposicion;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MON_ID")
    private DDMoneda moneda;
    
	@Column(name = "DSP_IMPORTE_DISPOSICION")
	private Float importe;
	
	@Column(name = "DSP_CAPITAL")
	private Float capital;
	
	@Column(name = "DSP_INT_ORDIN_DEVEN")
	private Float interesesOrdinarios;
	
	@Column(name = "DSP_INT_ORDIN_MORAT")
	private Float interesesMoratorios;
	
	@Column(name = "DSP_COMISIONES")
	private Float comisiones;
	
	@Column(name = "DSP_GASTOS_NO_COBRADOS")
	private Float gastosNoCobrados;
	
	@Column(name = "DSP_IMPUESTOS")
	private Float impuestos;
	
	@Column(name = "DSP_FECHA_VENCIMIENTO")
	private Date fechaVencimiento;
	
	@Column(name = "DSP_FECHA_EXTRACCION")
	private Date fechaExtraccion;
	
	@Column(name = "DSP_FECHA_DATO")
	private Date fechaDato;
	
	@Column(name = "DSP_CHAR_EXTRA1")
	private String charExtra1;
	
	@Column(name = "DSP_CHAR_EXTRA2")
	private String charExtra2;
	
	@Column(name = "DSP_FLAG_EXTRA1")
	private Boolean flagExtra1;
	
	@Column(name = "DSP_FLAG_EXTRA2")
	private Boolean flagExtra2;
	
	@Column(name = "DSP_DATE_EXTRA1")
	private Date dateExtra1;
	
	@Column(name = "DSP_DATE_EXTRA2")
	private Date dateExtra2;
	
	@Column(name = "DSP_NUM_EXTRA1")
	private Float numExtra1;
	
	@Column(name = "DSP_NUM_EXTRA2")
	private Float numExtra2;
	
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

	public Long getCodigoDisposicion() {
		return codigoDisposicion;
	}

	public void setCodigoDisposicion(Long codigoDisposicion) {
		this.codigoDisposicion = codigoDisposicion;
	}

	public DDTipoDisposicion getTipoDisposicion() {
		return tipoDisposicion;
	}

	public void setTipoDisposicion(DDTipoDisposicion tipoDisposicion) {
		this.tipoDisposicion = tipoDisposicion;
	}

	public DDSubTipoDisposicion getSubTipoDisposicion() {
		return subTipoDisposicion;
	}

	public void setSubTipoDisposicion(DDSubTipoDisposicion subTipoDisposicion) {
		this.subTipoDisposicion = subTipoDisposicion;
	}

	public DDSituacionDisposicion getSituacionDisposicion() {
		return situacionDisposicion;
	}

	public void setSituacionDisposicion(DDSituacionDisposicion situacionDisposicion) {
		this.situacionDisposicion = situacionDisposicion;
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
