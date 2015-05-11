package es.pfsgroup.plugin.recovery.coreextension.subasta.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.ManyToOne;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.persona.model.Persona;

@Embeddable
public class ProcedimientoPersonaId implements Serializable {

	private static final long serialVersionUID = 2736381971094731344L;

	@ManyToOne
	private Procedimiento procedimiento;

	@ManyToOne
	private Persona persona;

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

	@Override
	public int hashCode() {
		int result;
		result = (procedimiento != null ? procedimiento.hashCode() : 0);
		result = 17 * result + (persona != null ? persona.hashCode() : 0);
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (!(obj instanceof ProcedimientoPersonaId))
			return false;
		ProcedimientoPersonaId other = (ProcedimientoPersonaId) obj;
		if (persona == null) {
			if (other.persona != null)
				return false;
		} else if (!persona.equals(other.persona))
			return false;
		if (persona == null) {
			if (other.persona != null)
				return false;
		} else if (!persona.equals(other.persona))
			return false;
		return true;
	}

}
