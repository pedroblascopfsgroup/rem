package es.capgemini.pfs.contrato.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Entidad CAC_CONTRATOS_ACTUACION_CURSO
 *
 * @author Jorge Ros	
 *
 */
@Entity
@Table(name = "CAC_CONTRATOS_ACTUACION_CURSO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ContratosActuacionCurso implements Serializable, Auditable {
	
	private static final long serialVersionUID = 1L;
 
	@Id
	@Column(name = "CAC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ContratosActuacionCursoGenerator")
	@SequenceGenerator(name = "ContratosActuacionCursoGenerator", sequenceName = "S_CAC_CNT_ACTUACION_CURSO")
	private Long id;
	
	@OneToOne
    @JoinColumn(name = "CNT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Contrato contrato;
	
	@OneToMany
    @JoinColumn(name = "PER_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Persona> personas;
	
	@Column(name ="CAC_ACTUACION_EN_CURSO")
	private Boolean actuacionEnCurso;
	
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
	 * @return the contrato
	 */
	public Contrato getContrato() {
		return contrato;
	}

	/**
	 * @param contrato the contrato to set
	 */
	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	/**
	 * @return the persona
	 */
	public List<Persona> getPersona() {
		return personas;
	}

	/**
	 * @param persona the persona to set
	 */
	public void setPersona(List<Persona> personas) {
		this.personas = personas;
	}

	/**
	 * @return the actuacionEnCurso
	 */
	public Boolean getActuacionEnCurso() {
		return actuacionEnCurso;
	}

	/**
	 * @param actuacionEnCurso the actuacionEnCurso to set
	 */
	public void setActuacionEnCurso(Boolean actuacionEnCurso) {
		this.actuacionEnCurso = actuacionEnCurso;
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
