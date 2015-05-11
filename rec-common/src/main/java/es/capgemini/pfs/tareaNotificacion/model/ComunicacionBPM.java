package es.capgemini.pfs.tareaNotificacion.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
/**
 * Clase que representa a una comunicacion que tiene un proceso BPM asociado.
 * @author jbosnjak
 *
 */
@Entity
@Table(name = "CMB_COMUNICACION_BPM",schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ComunicacionBPM implements Serializable,Auditable{

	/**
	 * serial.
	 */
	private static final long serialVersionUID = -4737933835175794322L;

	@Id
    @Column(name = "CMB_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ComunicacionBPMGenerator")
    @SequenceGenerator(name = "ComunicacionBPMGenerator", sequenceName = "S_CMB_COMUNICACION_BPM")
    private Long id;

	@Column(name="CMB_PROCESS_BPM")
	private Long idBPM;

	@OneToOne(mappedBy="comunicacionBPM")
	private TareaNotificacion tarea;

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
	 * @return the tarea
	 */
	public TareaNotificacion getTarea() {
		return tarea;
	}
	/**
	 * @param tarea the tarea to set
	 */
	public void setTarea(TareaNotificacion tarea) {
		this.tarea = tarea;
	}

}
