package es.capgemini.pfs.asunto.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa una ficha de aceptación de un asunto.
 * @author pamuller
 *
 */
@Entity(name="AFA_FICHA_ACEPTACION")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class FichaAceptacion implements Auditable, Serializable{

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name="AFA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "FichaAceptacionGenerator")
    @SequenceGenerator(name = "FichaAceptacionGenerator", sequenceName = "S_AFA_FICHA_ACEPTACION")
	private Long id;

	@OneToOne
	@JoinColumn(name="ASU_ID")
	private Asunto asunto;

	@Column(name="AFA_ACEPTADO")
	private Boolean aceptacion;

	@Column(name="AFA_CONFLICTO")
	private Boolean conflicto;

	@Column(name="AFA_DOC_RECOPILADA")
	private Boolean documentacionRecibida;

	@OneToMany
	@JoinColumn(name="AFA_ID")
	@OrderBy("id desc")
	private List<ObservacionAceptacion> observaciones;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/**
	 * Constructor default.
	 * Inicializo las variables porque hibernate no está tomando los defaults de la base.
	 */
	public FichaAceptacion(){
		//aceptacion = Boolean.FALSE;
		//conflicto = Boolean.FALSE;
		//documentacionRecibida = Boolean.FALSE;
	}

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
	 * @return the aceptacion
	 */
	public Boolean getAceptacion() {
		return aceptacion;
	}

	/**
	 * @param aceptacion the aceptacion to set
	 */
	public void setAceptacion(Boolean aceptacion) {
		this.aceptacion = aceptacion;
	}

	/**
	 * @return the conflicto
	 */
	public Boolean getConflicto() {
		return conflicto;
	}

	/**
	 * @param conflicto the conflicto to set
	 */
	public void setConflicto(Boolean conflicto) {
		this.conflicto = conflicto;
	}

	/**
	 * @return the documentacionRecibida
	 */
	public Boolean getDocumentacionRecibida() {
		return documentacionRecibida;
	}

	/**
	 * @param documentacionRecibida the documentacionRecibida to set
	 */
	public void setDocumentacionRecibida(Boolean documentacionRecibida) {
		this.documentacionRecibida = documentacionRecibida;
	}

	/**
	 * @return the observaciones
	 */
	public List<ObservacionAceptacion> getObservaciones() {
		return observaciones;
	}

	/**
	 * @param observaciones the observaciones to set
	 */
	public void setObservaciones(List<ObservacionAceptacion> observaciones) {
		this.observaciones = observaciones;
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

	/**
	 * @return the asunto
	 */
	public Asunto getAsunto() {
		return asunto;
	}

	/**
	 * @param asunto the asunto to set
	 */
	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}

}
