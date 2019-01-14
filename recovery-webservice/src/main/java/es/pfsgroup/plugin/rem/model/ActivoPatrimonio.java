package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import es.pfsgroup.plugin.rem.model.dd.DDAdecuacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInquilino;

/**
 * Modelo que gestiona el patrimonio de un activo.
 * 
 * @author Daniel Algaba
 */
@Entity
@Table(name = "ACT_PTA_PATRIMONIO_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoPatrimonio implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ACT_PTA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoPatrimonioGenerator")
	@SequenceGenerator(name = "ActivoPatrimonioGenerator", sequenceName = "S_ACT_PTA_PATRIMONIO_ACTIVO")
	private Long id;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_ADA_ID")
	private DDAdecuacionAlquiler adecuacionAlquiler;

	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_ADA_ID_ANTERIOR")
	private DDAdecuacionAlquiler adecuacionAlquilerAnterior;

	@Column(name = "CHECK_HPM")
	private Boolean checkHPM;
	
	@Column(name = "PTA_RENTA_ANTIGUA")
	private String comboRentaAntigua;
	
	@Column(name = "CHECK_SUBROGADO")
	private Boolean checkSubrogado;

	@ManyToOne
	@JoinColumn(name = "DD_TPI_ID")
	private DDTipoInquilino tipoInquilino;
	
	@ManyToOne
	@JoinColumn(name = "DD_EAL_ID")
	private DDTipoEstadoAlquiler tipoEstadoAlquiler;
	
	@Version
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Boolean getCheckSubrogado() {
		return checkSubrogado;
	}

	public void setCheckSubrogado(Boolean checkSubrogado) {
		this.checkSubrogado = checkSubrogado;
	}

	public DDTipoInquilino getTipoInquilino() {
		return tipoInquilino;
	}

	public void setTipoInquilino(DDTipoInquilino tipoInquilino) {
		this.tipoInquilino = tipoInquilino;
	}

	public DDTipoEstadoAlquiler getTipoEstadoAlquiler() {
		return tipoEstadoAlquiler;
	}

	public void setTipoEstadoAlquiler(DDTipoEstadoAlquiler tipoEstadoAlquiler) {
		this.tipoEstadoAlquiler = tipoEstadoAlquiler;
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

	public DDAdecuacionAlquiler getAdecuacionAlquiler() {
		return adecuacionAlquiler;
	}

	public void setAdecuacionAlquiler(DDAdecuacionAlquiler adecuacionAlquiler) {
		this.adecuacionAlquiler = adecuacionAlquiler;
	}

	public DDAdecuacionAlquiler getAdecuacionAlquilerAnterior() {
		return adecuacionAlquilerAnterior;
	}

	public void setAdecuacionAlquilerAnterior(DDAdecuacionAlquiler adecuacionAlquilerAnterior) {
		this.adecuacionAlquilerAnterior = adecuacionAlquilerAnterior;
	}

	public Boolean getCheckHPM() {
		return checkHPM;
	}

	public void setCheckHPM(Boolean checkHPM) {
		this.checkHPM = checkHPM;
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

	public String getComboRentaAntigua() {
		return comboRentaAntigua;
	}

	public void setComboRentaAntigua(String comboRentaAntigua) {
		this.comboRentaAntigua = comboRentaAntigua;
	}
	
	
}
