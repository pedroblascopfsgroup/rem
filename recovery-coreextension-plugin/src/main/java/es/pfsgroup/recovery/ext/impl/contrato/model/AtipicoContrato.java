package es.pfsgroup.recovery.ext.impl.contrato.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDTipoProductoEntidad;

/**
 * Clase que representa las entradas de las tabla CPE_CONTRATOS_PERSONAS.
 */
@Entity
@Table(name = "ATC_ATIPICOS_CNT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class AtipicoContrato implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ATC_ID")
	private Long id;

	@Column(name = "ATC_CODIGO_ATIPICO")
	private Long codigo;

	@Column(name = "ATC_FECHA_EXTRACCION")
	private Date fechaExtraccion;

	@Column(name = "ATC_FECHA_DATO")
	private Date fechaDato;

	@Column(name = "ATC_NUMERO_CONTRATO")
	private Long numeroContrato;

	@Column(name = "ATC_NUMERO_SPEC")
	private Long numeroSpec;

	@Column(name = "ATC_IMPORTE_ATIPICO")
	private Long importe;

	@Column(name = "ATC_FECHA_VALOR")
	private Date fechaValor;

	@Column(name = "ATC_FECHA_MOVIMIENTO")
	private Date fechaMovimiento;

	@Column(name = "ATC_CHAR_EXTRA1")
	private String strExtra1;

	@Column(name = "ATC_CHAR_EXTRA2")
	private String strExtra2;

	@Column(name = "ATC_FLAG_EXTRA1")
	private Boolean flagExtra1;

	@Column(name = "ATC_FLAG_EXTRA2")
	private Boolean flagExtra2;

	@Column(name = "ATC_DATE_EXTRA1")
	private Date fechaExtra1;

	@Column(name = "ATC_DATE_EXTRA2")
	private Date fechaExtra2;

	@Column(name = "ATC_NUM_EXTRA1")
	private Long numExtra1;

	@Column(name = "ATC_NUM_EXTRA2")
	private Long numExtra2;

	@Column(name = "SYS_GUID")
	private String sysGuid;

	// Tipo de producto entidad
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TPE_ID")
	private DDTipoProductoEntidad tipoProductoEntidad;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TAT_ID")
	private DDTipoAtipicoContrato tipoAtipicoContrato;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_MAT_ID")
	private DDMotivoAtipicoContrato motivoAtipicoContrato;

	@ManyToOne
	@JoinColumn(name = "CNT_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Contrato contrato;

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
	 * @return the codigo
	 */
	public Long getCodigo() {
		return codigo;
	}

	/**
	 * @param codigo
	 *            the codigo to set
	 */
	public void setCodigo(Long codigo) {
		this.codigo = codigo;
	}

	/**
	 * @return the fechaExtraccion
	 */
	public Date getFechaExtraccion() {
		return fechaExtraccion;
	}

	/**
	 * @param fechaExtraccion
	 *            the fechaExtraccion to set
	 */
	public void setFechaExtraccion(Date fechaExtraccion) {
		this.fechaExtraccion = fechaExtraccion;
	}

	/**
	 * @return the fechaDato
	 */
	public Date getFechaDato() {
		return fechaDato;
	}

	/**
	 * @param fechaDato
	 *            the fechaDato to set
	 */
	public void setFechaDato(Date fechaDato) {
		this.fechaDato = fechaDato;
	}

	/**
	 * @return the numeroContrato
	 */
	public Long getNumeroContrato() {
		return numeroContrato;
	}

	/**
	 * @param numeroContrato
	 *            the numeroContrato to set
	 */
	public void setNumeroContrato(Long numeroContrato) {
		this.numeroContrato = numeroContrato;
	}

	/**
	 * @return the numeroSpec
	 */
	public Long getNumeroSpec() {
		return numeroSpec;
	}

	/**
	 * @param numeroSpec
	 *            the numeroSpec to set
	 */
	public void setNumeroSpec(Long numeroSpec) {
		this.numeroSpec = numeroSpec;
	}

	/**
	 * @return the importe
	 */
	public Long getImporte() {
		return importe;
	}

	/**
	 * @param importe
	 *            the importe to set
	 */
	public void setImporte(Long importe) {
		this.importe = importe;
	}

	/**
	 * @return the fechaValor
	 */
	public Date getFechaValor() {
		return fechaValor;
	}

	/**
	 * @param fechaValor
	 *            the fechaValor to set
	 */
	public void setFechaValor(Date fechaValor) {
		this.fechaValor = fechaValor;
	}

	/**
	 * @return the fechaMovimiento
	 */
	public Date getFechaMovimiento() {
		return fechaMovimiento;
	}

	/**
	 * @param fechaMovimiento
	 *            the fechaMovimiento to set
	 */
	public void setFechaMovimiento(Date fechaMovimiento) {
		this.fechaMovimiento = fechaMovimiento;
	}

	/**
	 * @return the strExtra1
	 */
	public String getStrExtra1() {
		return strExtra1;
	}

	/**
	 * @param strExtra1
	 *            the strExtra1 to set
	 */
	public void setStrExtra1(String strExtra1) {
		this.strExtra1 = strExtra1;
	}

	/**
	 * @return the strExtra2
	 */
	public String getStrExtra2() {
		return strExtra2;
	}

	/**
	 * @param strExtra2
	 *            the strExtra2 to set
	 */
	public void setStrExtra2(String strExtra2) {
		this.strExtra2 = strExtra2;
	}

	/**
	 * @return the flagExtra1
	 */
	public Boolean getFlagExtra1() {
		return flagExtra1;
	}

	/**
	 * @param flagExtra1
	 *            the flagExtra1 to set
	 */
	public void setFlagExtra1(Boolean flagExtra1) {
		this.flagExtra1 = flagExtra1;
	}

	/**
	 * @return the flagExtra2
	 */
	public Boolean getFlagExtra2() {
		return flagExtra2;
	}

	/**
	 * @param flagExtra2
	 *            the flagExtra2 to set
	 */
	public void setFlagExtra2(Boolean flagExtra2) {
		this.flagExtra2 = flagExtra2;
	}

	/**
	 * @return the fechaExtra1
	 */
	public Date getFechaExtra1() {
		return fechaExtra1;
	}

	/**
	 * @param fechaExtra1
	 *            the fechaExtra1 to set
	 */
	public void setFechaExtra1(Date fechaExtra1) {
		this.fechaExtra1 = fechaExtra1;
	}

	/**
	 * @return the fechaExtra2
	 */
	public Date getFechaExtra2() {
		return fechaExtra2;
	}

	/**
	 * @param fechaExtra2
	 *            the fechaExtra2 to set
	 */
	public void setFechaExtra2(Date fechaExtra2) {
		this.fechaExtra2 = fechaExtra2;
	}

	/**
	 * @return the numExtra1
	 */
	public Long getNumExtra1() {
		return numExtra1;
	}

	/**
	 * @param numExtra1
	 *            the numExtra1 to set
	 */
	public void setNumExtra1(Long numExtra1) {
		this.numExtra1 = numExtra1;
	}

	/**
	 * @return the numExtra2
	 */
	public Long getNumExtra2() {
		return numExtra2;
	}

	/**
	 * @param numExtra2
	 *            the numExtra2 to set
	 */
	public void setNumExtra2(Long numExtra2) {
		this.numExtra2 = numExtra2;
	}

	/**
	 * @return the sysGuid
	 */
	public String getSysGuid() {
		return sysGuid;
	}

	/**
	 * @param sysGuid
	 *            the sysGuid to set
	 */
	public void setSysGuid(String sysGuid) {
		this.sysGuid = sysGuid;
	}

	/**
	 * @return the tipoProductoEntidad
	 */
	public DDTipoProductoEntidad getTipoProductoEntidad() {
		return tipoProductoEntidad;
	}

	/**
	 * @param tipoProductoEntidad
	 *            the tipoProductoEntidad to set
	 */
	public void setTipoProductoEntidad(DDTipoProductoEntidad tipoProductoEntidad) {
		this.tipoProductoEntidad = tipoProductoEntidad;
	}

	/**
	 * @return the tipoAtipicoContrato
	 */
	public DDTipoAtipicoContrato getTipoAtipicoContrato() {
		return tipoAtipicoContrato;
	}

	/**
	 * @param tipoAtipicoContrato
	 *            the tipoAtipicoContrato to set
	 */
	public void setTipoAtipicoContrato(DDTipoAtipicoContrato tipoAtipicoContrato) {
		this.tipoAtipicoContrato = tipoAtipicoContrato;
	}

	/**
	 * @return the motivoAtipicoContrato
	 */
	public DDMotivoAtipicoContrato getMotivoAtipicoContrato() {
		return motivoAtipicoContrato;
	}

	/**
	 * @param motivoAtipicoContrato
	 *            the motivoAtipicoContrato to set
	 */
	public void setMotivoAtipicoContrato(
			DDMotivoAtipicoContrato motivoAtipicoContrato) {
		this.motivoAtipicoContrato = motivoAtipicoContrato;
	}

	/**
	 * @return the contrato
	 */
	public Contrato getContrato() {
		return contrato;
	}

	/**
	 * @param contrato
	 *            the contrato to set
	 */
	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
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

}
