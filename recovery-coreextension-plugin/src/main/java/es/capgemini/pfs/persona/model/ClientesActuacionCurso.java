package es.capgemini.pfs.persona.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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


/**
 * Entidad CLA_CLIENTES_ACTUACION_CURSO
 *
 * @author Jorge Ros	
 *
 */
@Entity
@Table(name = "CLA_CLIENTES_ACTUACION_CURSO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ClientesActuacionCurso implements Serializable, Auditable {
	
	private static final long serialVersionUID = 1L;
 
	@Id
	@Column(name = "CLA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ClientesActuacionCursoGenerator")
	@SequenceGenerator(name = "ClientesActuacionCursoGenerator", sequenceName = "S_CLA_CLIENTES_ACTUACION_CURSO")
	private Long id;
	
	@Column(name ="CLA_ACTUACION_EN_CURSO")
	private Boolean actuacionEnCurso;
	
	@OneToOne
    @JoinColumn(name = "PER_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Persona persona;
	
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
	 * @return the persona
	 */
	public Persona getPersona() {
		return persona;
	}

	/**
	 * @param persona the persona to set
	 */
	public void setPersona(Persona persona) {
		this.persona = persona;
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
