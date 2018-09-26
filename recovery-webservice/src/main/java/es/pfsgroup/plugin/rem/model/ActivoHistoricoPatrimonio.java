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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDAdecuacionAlquiler;

/**
 * Modelo que gestiona el patrimonio de un activo.
 * 
 * @author Daniel Algaba
 */
@Entity
@Table(name = "HIST_PTA_PATRIMONIO_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoHistoricoPatrimonio implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "HIST_PTA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoHistoricoPatrimonio")
	@SequenceGenerator(name = "ActivoHistoricoPatrimonio", sequenceName = "S_HIST_PTA_PATRIMONIO_ACTIVO")
	private Long id;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_ADA_ID")
	private DDAdecuacionAlquiler AdecuacionAlquiler;

	@Column(name = "CHECK_HPM")
	private Boolean checkHPM;

	@Column(name = "FECHA_INI_ADA")
	private Date fechaInicioAdecuacionAlquiler;

	@Column(name = "FECHA_FIN_ADA")
	private Date fechaFinAdecuacionAlquiler;

	@Column(name = "FECHA_INI_HPM")
	private Date fechaInicioHPM;

	@Column(name = "FECHA_FIN_HPM")
	private Date fechaFinHPM;
	
	@Column(name = "PTA_RENTA_ANTIGUA")
	private Boolean checkRentaAntigua;

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

	public DDAdecuacionAlquiler getAdecuacionAlquiler() {
		return AdecuacionAlquiler;
	}

	public void setAdecuacionAlquiler(DDAdecuacionAlquiler adecuacionAlquiler) {
		AdecuacionAlquiler = adecuacionAlquiler;
	}

	public Boolean getCheckHPM() {
		return checkHPM;
	}

	public void setCheckHPM(Boolean checkHPM) {
		this.checkHPM = checkHPM;
	}

	public Date getFechaInicioAdecuacionAlquiler() {
		return fechaInicioAdecuacionAlquiler;
	}

	public void setFechaInicioAdecuacionAlquiler(Date fechaInicioAdecuacionAlquiler) {
		this.fechaInicioAdecuacionAlquiler = fechaInicioAdecuacionAlquiler;
	}

	public Date getFechaFinAdecuacionAlquiler() {
		return fechaFinAdecuacionAlquiler;
	}

	public void setFechaFinAdecuacionAlquiler(Date fechaFinAdecuacionAlquiler) {
		this.fechaFinAdecuacionAlquiler = fechaFinAdecuacionAlquiler;
	}

	public Date getFechaInicioHPM() {
		return fechaInicioHPM;
	}

	public void setFechaInicioHPM(Date fechaInicioHPM) {
		this.fechaInicioHPM = fechaInicioHPM;
	}

	public Date getFechaFinHPM() {
		return fechaFinHPM;
	}

	public void setFechaFinHPM(Date fechaFinHPM) {
		this.fechaFinHPM = fechaFinHPM;
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

	public Boolean getCheckRentaAntigua() {
		return checkRentaAntigua;
	}

	public void setCheckRentaAntigua(Boolean checkRentaAntigua) {
		this.checkRentaAntigua = checkRentaAntigua;
	}
	
	
}
