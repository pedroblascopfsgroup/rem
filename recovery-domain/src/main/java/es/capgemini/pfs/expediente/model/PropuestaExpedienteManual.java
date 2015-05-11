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
 * Clase que representa la entidad Propuesta de expedienteExpediente.
 *
 */
@Entity
@Table(name = "PEM_PROP_EXP_MANUAL", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class PropuestaExpedienteManual implements Serializable, Auditable {

    private static final long serialVersionUID = -1353637087467504824L;

    @Id
    @Column(name = "PEM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PropuestaExpedienteManualGenerator")
    @SequenceGenerator(name = "PropuestaExpedienteManualGenerator", sequenceName = "S_PEM_PROP_EXP_MANUAL")
    private Long id;

    @ManyToOne
    @JoinColumn(name="EXP_ID")
    private Expediente expediente;

    @ManyToOne
    @JoinColumn(name="DD_MEX_ID")
    private DDMotivoExpedienteManual motivo;

    @Column(name="OBSERVACIONES")
    private String observaciones;

    @Column(name="PEM_PROCESS_BPM")
    private Long idBPM;

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
	 * @return the motivo
	 */
	public DDMotivoExpedienteManual getMotivo() {
		return motivo;
	}

	/**
	 * @param motivo the motivo to set
	 */
	public void setMotivo(DDMotivoExpedienteManual motivo) {
		this.motivo = motivo;
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
	 * @param version the version to set
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}

	/**
	 * @return the observaciones
	 */
	public String getObservaciones() {
		return observaciones;
	}

	/**
	 * @param observaciones the observaciones to set
	 */
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	/**
	 * @return the idBPM
	 */
	public Long getIdBPM() {
		return idBPM;
	}

	/**
	 * @param idBPM the idBPM to set
	 */
	public void setIdBPM(Long idBPM) {
		this.idBPM = idBPM;
	}

    }
