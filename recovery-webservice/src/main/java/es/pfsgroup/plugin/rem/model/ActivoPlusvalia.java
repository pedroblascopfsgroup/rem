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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo que gestiona la plusvalía de un activo.
 * 
 * @author Mariam Lliso
 */
@Entity
@Table(name = "ACT_PLS_PLUSVALIA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoPlusvalia implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ACT_PLS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoPlusvaliaGenerator")
	@SequenceGenerator(name = "ActivoPlusvaliaGenerator", sequenceName = "S_ACT_PLS_PLUSVALIA")
	private Long id;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

	@Column(name = "ACT_PLS_FECHA_RECEPCION_PLUSVALIA")
	private Date dateRecepcionPlus;
	
	@Column(name = "ACT_PLS_FECHA_PRESENTACION_PLUSVALIA")
	private Date datePresentacionPlus;
	
	@Column(name = "ACT_PLS_FECHA_PRESENTACION_RECURSO")
	private Date datePresentacionRecu;
	
	@Column(name = "ACT_PLS_FECHA_RESPUESTA_RECURSO")
	private Date dateRespuestaRecu;
	
    @Column(name = "ACT_PLS_APERTURA_Y_SEGUIMIENTO_EXP")
   	private Integer aperturaSeguimientoExp;
    
    @Column(name = "ACT_PLS_IMPORTE_PAGADO")
   	private Integer importePagado;
    
	@ManyToOne
    @JoinColumn(name = "GPV_ID")
    private GastoProveedor gastoProveedor; 
    
    @Column(name = "ACT_PLS_MINUSVALIA")
   	private Integer minusvalia;
	
	@Version
	private Long version;

	@Embedded
	private Auditoria auditoria;

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

	public Date getDateRecepcionPlus() {
		return dateRecepcionPlus;
	}

	public void setDateRecepcionPlus(Date dateRecepcionPlus) {
		this.dateRecepcionPlus = dateRecepcionPlus;
	}

	public Date getDatePresentacionPlus() {
		return datePresentacionPlus;
	}

	public void setDatePresentacionPlus(Date datePresentacionPlus) {
		this.datePresentacionPlus = datePresentacionPlus;
	}

	public Date getDatePresentacionRecu() {
		return datePresentacionRecu;
	}

	public void setDatePresentacionRec(Date datePresentacionRecu) {
		this.datePresentacionRecu = datePresentacionRecu;
	}

	public Date getDateRespuestaRecu() {
		return dateRespuestaRecu;
	}

	public void setDateRespuestaRecu(Date dateRespuestaRecu) {
		this.dateRespuestaRecu = dateRespuestaRecu;
	}

	public Integer getAperturaSeguimientoExp() {
		return aperturaSeguimientoExp;
	}

	public void setAperturaSeguimientoExp(Integer aperturaSeguimientoExp) {
		this.aperturaSeguimientoExp = aperturaSeguimientoExp;
	}

	public Integer getImportePagado() {
		return importePagado;
	}

	public void setImportePagado(Integer importePagado) {
		this.importePagado = importePagado;
	}

	public GastoProveedor getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(GastoProveedor gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}

	public Integer getMinusvalia() {
		return minusvalia;
	}

	public void setMinusvalia(Integer minusvalia) {
		this.minusvalia = minusvalia;
	}
	
	
	
}
	