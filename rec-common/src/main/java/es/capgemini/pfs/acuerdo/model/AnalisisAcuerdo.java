package es.capgemini.pfs.acuerdo.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa a un AnalisisAcuerdo.
 * @author pamuller
 *
 */
@Entity
@Table(name="ANA_ANALIS_ACUERDO", schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class AnalisisAcuerdo implements Serializable,Auditable{

	private static final long serialVersionUID = 0L;

	@Id
	@Column(name="ANA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "AnalisisAcuerdoGenerator")
    @SequenceGenerator(name = "AnalisisAcuerdoGenerator", sequenceName = "S_ANA_ANALIS_ACUERDO")
	private Long id;

	@OneToOne
	@JoinColumn(name="ACU_ID")
	private Acuerdo acuerdo;

	@ManyToOne
	@JoinColumn(name="DD_ACT_ID")
	private DDConclusionTituloAcuerdo ddConclusionTituloAcuerdo;

	@Column(name="ANA_OBSERV_TITULOS")
	private String observacionesTitulos;

	@ManyToOne
	@JoinColumn(name="DD_ACC_ID")
	private DDAnalisisCapacidadPago ddAnalisisCapacidadPago;

	@Column(name="ANA_IMPORTE_PAGO")
	private Double importePago;

	@Column(name="ANA_OBSERV_PAGO")
	private String observacionesPago;

	@ManyToOne
	@JoinColumn(name="DD_ACS_ID")
	private DDCambioSolvenciaAcuerdo ddCambioSolvenciaAcuerdo;

	@Column(name="ANA_IMPORTE_SOLVENCIA")
	private Double importeSolvencia;

	@Column(name="ANA_OBSERV_SOLVENCIA")
	private String observacionesSolvencia;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return the acuerdo
	 */
	public Acuerdo getAcuerdo() {
		return acuerdo;
	}
	/**
	 * @param acuerdo the acuerdo to set
	 */
	public void setAcuerdo(Acuerdo acuerdo) {
		this.acuerdo = acuerdo;
	}
	/**
	 * @return the ddConclusionTituloAcuerdo
	 */
	public DDConclusionTituloAcuerdo getDdConclusionTituloAcuerdo() {
		return ddConclusionTituloAcuerdo;
	}
	/**
	 * @param ddConclusionTituloAcuerdo the ddConclusionTituloAcuerdo to set
	 */
	public void setDdConclusionTituloAcuerdo(
			DDConclusionTituloAcuerdo ddConclusionTituloAcuerdo) {
		this.ddConclusionTituloAcuerdo = ddConclusionTituloAcuerdo;
	}
	/**
	 * @return the observacionesTitulos
	 */
	public String getObservacionesTitulos() {
		return observacionesTitulos;
	}
	/**
	 * @param observacionesTitulos the observacionesTitulos to set
	 */
	public void setObservacionesTitulos(String observacionesTitulos) {
		this.observacionesTitulos = observacionesTitulos;
	}
	/**
	 * @return the ddAnalisisCapacidadPago
	 */
	public DDAnalisisCapacidadPago getDdAnalisisCapacidadPago() {
		return ddAnalisisCapacidadPago;
	}
	/**
	 * @param ddAnalisisCapacidadPago the ddAnalisisCapacidadPago to set
	 */
	public void setDdAnalisisCapacidadPago(
			DDAnalisisCapacidadPago ddAnalisisCapacidadPago) {
		this.ddAnalisisCapacidadPago = ddAnalisisCapacidadPago;
	}
	/**
	 * @return the importePago
	 */
	public Double getImportePago() {
		return importePago;
	}
	/**
	 * @param importePago the importePago to set
	 */
	public void setImportePago(Double importePago) {
		this.importePago = importePago;
	}
	/**
	 * @return the observacionesPago
	 */
	public String getObservacionesPago() {
		return observacionesPago;
	}
	/**
	 * @param observacionesPago the observacionesPago to set
	 */
	public void setObservacionesPago(String observacionesPago) {
		this.observacionesPago = observacionesPago;
	}
	/**
	 * @return the ddCambioSolvenciaAcuerdo
	 */
	public DDCambioSolvenciaAcuerdo getDdCambioSolvenciaAcuerdo() {
		return ddCambioSolvenciaAcuerdo;
	}
	/**
	 * @param ddCambioSolvenciaAcuerdo the ddCambioSolvenciaAcuerdo to set
	 */
	public void setDdCambioSolvenciaAcuerdo(
			DDCambioSolvenciaAcuerdo ddCambioSolvenciaAcuerdo) {
		this.ddCambioSolvenciaAcuerdo = ddCambioSolvenciaAcuerdo;
	}
	/**
	 * @return the importeSolvencia
	 */
	public Double getImporteSolvencia() {
		return importeSolvencia;
	}
	/**
	 * @param importeSolvencia the importeSolvencia to set
	 */
	public void setImporteSolvencia(Double importeSolvencia) {
		this.importeSolvencia = importeSolvencia;
	}
	/**
	 * @return the observacionesSolvencia
	 */
	public String getObservacionesSolvencia() {
		return observacionesSolvencia;
	}
	/**
	 * @param observacionesSolvencia the observacionesSolvencia to set
	 */
	public void setObservacionesSolvencia(String observacionesSolvencia) {
		this.observacionesSolvencia = observacionesSolvencia;
	}
	/**
	 * @return the version
	 */
	public Integer getVersion() {
		return version;
	}
	/**
	 * @param version the version to set
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}
	/**
	 * @return the auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}
	/**
	 * @param auditoria the auditoria to set
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
