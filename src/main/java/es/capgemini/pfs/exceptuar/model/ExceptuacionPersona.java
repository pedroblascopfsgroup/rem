package es.capgemini.pfs.exceptuar.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.persona.model.Persona;

@Entity
@Table(name = "EPE_EXCEPTUACION_PERSONA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@PrimaryKeyJoinColumn(name = "EXC_ID")
public class ExceptuacionPersona extends Exceptuacion implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1267973976400188051L;

	@ManyToOne
	@JoinColumn(name = "PER_ID")
	private Persona persona;

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

}
