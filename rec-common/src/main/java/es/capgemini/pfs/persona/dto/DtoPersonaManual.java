package es.capgemini.pfs.persona.dto;

import es.capgemini.pfs.persona.model.Persona;

public class DtoPersonaManual {
	private Persona persona;
	private Boolean manual;
	
	public Persona getPersona() {
		return persona;
	}
	public void setPersona(Persona persona) {
		this.persona = persona;
	}
	public Boolean getManual() {
		return manual;
	}
	public void setManual(Boolean manual) {
		this.manual = manual;
	}
}
