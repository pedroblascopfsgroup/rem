package es.capgemini.pfs.expediente.model;

import java.io.Serializable;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


/**
 * Clase que modela la solicitud de cancelación de un expediente.
 * @author pamuller
 *
 */
@Entity
@Table(name = "SCX_SOL_CANCELAC_EXP", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class SolicitudCancelacion implements Serializable, Auditable{

	private static final long serialVersionUID = 7871340171588015923L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "SolCancExpGen")
	@SequenceGenerator(name = "SolCancExpGen", sequenceName = "S_SCX_SOL_CANCELAC_EXP")
	@Column(name="SCX_ID")
	private Long id;

	@ManyToOne
	@JoinColumn(name="EXP_ID")
	private Expediente expediente;

	@Column(name="SCX_DETALLE")
	private String detalle;

	@Column(name="SCX_ACEPTADA")
	private Boolean aceptada;

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
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the expediente
	 */
	public Expediente getExpediente() {
		return expediente;
	}

	/**
	 * @param expediente the expediente to set
	 */
	public void setExpediente(Expediente expediente) {
		this.expediente = expediente;
	}

	/**
	 * @return the detalle
	 */
	public String getDetalle() {
		return detalle;
	}

	/**
	 * @param detalle the detalle to set
	 */
	public void setDetalle(String detalle) {
		this.detalle = detalle;
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

	/**
	 * @return the version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * @return the aceptada
	 */
	public Boolean getAceptada() {
		return aceptada;
	}

	/**
	 * @param aceptada the aceptada to set
	 */
	public void setAceptada(Boolean aceptada) {
		this.aceptada = aceptada;
	}

}
