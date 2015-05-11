package es.capgemini.pfs.persona.model;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.telefonos.model.Telefono;

@Entity
@Table(name = "TEL_PER", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class PersonasTelefono implements  Serializable, Auditable{

	private static final long serialVersionUID = -3449235993387457676L;

	@Id
    @Column(name = "TEL_PER_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PersonasTelefonoGenerator")
    @SequenceGenerator(name = "PersonasTelefonoGenerator", sequenceName = "S_TEL_PER")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "TEL_ID")
	private Telefono telefono;
	
	@ManyToOne
    @JoinColumn(name = "PER_ID")
	private Persona persona;

	@Embedded
    private Auditoria auditoria;
	
	@Version
	private Integer version;
	 
	/**
     * Setea el estado de borrado de la relaci�n.
     * @param borrado Si la tarea está o no borrada
     */
    public void setBorrado(Boolean borrado) {
        auditoria.setBorrado(borrado);
    }
    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}


	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

	public Telefono getTelefono() {
		return telefono;
	}

	public void setTelefono(Telefono telefono) {
		this.telefono = telefono;
	}

}
